import Foundation

protocol MainInteractorProtocol {
    
    func didSearch(query: String)
    func didPaginate()
}

final class MainInteractor {
    
    struct State {
        
        let query: String
        let totalHits: Int
        var currentPage: Int
        var images: [PixabayResponse]
        var graffitiImages: [PixabayResponse]
    }
    
    // MARK: - Private Properties
    
    private var state: State?
    private var currentTask: Task<Void, Never>?
    
    // MARK: - Dependencies
    
    private let presenter: MainPresenterProtocol
    private let pixabayService: PixabayServiceProtocol
    
    // MARK: - Init
    
    init(presenter: MainPresenterProtocol, pixabayService: PixabayServiceProtocol) {
        self.presenter = presenter
        self.pixabayService = pixabayService
    }
}

// MARK: - MainInteractorProtocol

extension MainInteractor: MainInteractorProtocol {
    
    func didSearch(query: String) {
        guard currentTask == nil else { return }
        
        currentTask = Task { [weak self] in
            guard let self else { return }
            
            do {
                async let imagesTask = try await self.pixabayService.getImages(query: query, page: 1)
                async let graffitiTask = try await self.pixabayService.getImages(query: "\(query) graffiti", page: 1)
                
                let (images, graffiti) = await (try imagesTask, try graffitiTask)
                
                self.state = State(
                    query: query,
                    totalHits: min(
                        images.totalHits,
                        graffiti.totalHits
                    ),
                    currentPage: 1,
                    images: [images],
                    graffitiImages: [graffiti]
                )
                
                self.presenter.didFetchImages(
                    images: images.hits,
                    graffitiImages: graffiti.hits
                )
            } catch {
                self.presenter.didNotFetchImages(error: error)
            }
            
            currentTask = nil
        }
    }
    
    func didPaginate() {
        guard currentTask == nil else { return }
        
        guard let state else { return }
        let pagesCount = state.totalHits / 10
        
        if pagesCount > state.currentPage {
            currentTask = Task { [weak self] in
                guard let self else { return }
                
                do {
                    let page = state.currentPage + 1
                    async let imagesTask = try await self.pixabayService.getImages(query: state.query, page: page)
                    async let graffitiTask = try await self.pixabayService.getImages(query: "\(state.query) graffiti", page: page)
                    
                    let (images, graffiti) = await (try imagesTask, try graffitiTask)
                    
                    self.state?.currentPage += 1
                    self.state?.images.append(images)
                    self.state?.graffitiImages.append(graffiti)
                    
                    self.presenter.didFetchImages(
                        images: self.state?.images.flatMap(\.hits) ?? [],
                        graffitiImages: self.state?.graffitiImages.flatMap(\.hits) ?? []
                    )
                } catch {
                    self.presenter.didNotFetchImages(error: error)
                }
                
                currentTask = nil
            }
        }
    }
}
