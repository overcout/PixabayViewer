import UIKit

struct MainAssembly {

    func build() -> UIViewController {
        let router = MainRouter()
        let presenter = MainPresenter(router: router)
        let pixabayService = PixabayService()
        let interactor = MainInteractor(presenter: presenter, pixabayService: pixabayService)
        let viewController = MainViewController(interactor: interactor)

        presenter.viewController = viewController
        router.viewController = viewController

        return viewController
    }
}
