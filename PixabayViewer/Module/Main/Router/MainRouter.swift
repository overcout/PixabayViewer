import Foundation
import UIKit

protocol MainRouterProtocol: AnyObject {
    func openDetail(_ imageURLs: [URL], index: Int)
    func show(error: Error)
}

final class MainRouter {
    
    weak var viewController: UIViewController?
}

// MARK: - MainRouterProtocol

extension MainRouter: MainRouterProtocol {
    
    func openDetail(_ imageURLs: [URL], index: Int) {
        let detailViewController = DetailViewController(imageURLs: imageURLs, index: index)
        viewController?.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func show(error: any Error) {
        let alert = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        viewController?.present(alert, animated: true)
    }
}
