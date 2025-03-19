import Foundation

protocol MainPresenterProtocol {

    func didFetchImages(images: [PixabayImage], graffitiImages: [PixabayImage])
    func didNotFetchImages(error: Error)
}

final class MainPresenter {
    
    // MARK: - MainPresenterProtocol Properties

    weak var viewController: MainViewControllerProtocol?
    
    // MARK: - Private Properties
    
    private let router: MainRouterProtocol
    
    // MARK: - Init

    init(router: MainRouterProtocol) {
        self.router = router
    }
}

// MARK: - MainPresenterProtocol

extension MainPresenter: MainPresenterProtocol {
    func didFetchImages(images: [PixabayImage], graffitiImages: [PixabayImage]) {
        let images: [(first: PixabayImage, second: PixabayImage)] = Array(zip(images, graffitiImages))
        let imageItems: [FormViewItemProtocol] = images.compactMap {
            guard let firstURL = URL(string: $0.first.webformatURL) else { return nil }
            guard let secondURL = URL(string: $0.second.webformatURL) else { return nil }

            let firstTapAction: () -> Void = { [weak router] in
                router?.openDetail([firstURL, secondURL], index: 0)
            }

            let secondTapAction: () -> Void = { [weak router] in
                router?.openDetail([firstURL, secondURL], index: 1)
            }

            let first = ImageItem(imageURL: firstURL, captionText: $0.first.tags, tapAction: firstTapAction)
            let second = ImageItem(imageURL: secondURL, captionText: $0.second.tags, tapAction: secondTapAction)
            
            return PixabayImageItem(first: first, second: second)
        }
        
        viewController?.setForm(items: imageItems)
    }
    
    func didNotFetchImages(error: Error) {
        router.show(error: error)
    }
}
