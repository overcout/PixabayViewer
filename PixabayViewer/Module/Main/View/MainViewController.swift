import UIKit

protocol MainViewControllerProtocol: AnyObject {

    func setForm(items: [FormViewItemProtocol])
}

final class MainViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private let interactor: MainInteractorProtocol
    
    private let textField = UITextField()
    
    private let formView = FormView()

    // MARK: - Init

    init(interactor: MainInteractorProtocol) {
        self.interactor = interactor

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
    }
}

// MARK: - UITextFieldDelegate

extension MainViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let query = textField.text else { return true }

        interactor.didSearch(query: query)
        
        return true
    }
}

// MARK: - Private

private extension MainViewController {
    
    func setupViews() {
        navigationItem.title = "Pixabay"
        view.backgroundColor = .systemBackground

        view.addSubview(textField)
        textField.placeholder = "Search..."
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        textField.keyboardType = .default
        textField.returnKeyType = .search
        textField.clearButtonMode = .whileEditing
        textField.contentVerticalAlignment = .center
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(formView)
        formView.contentOffset = .init(x: 0, y: 16)
        formView.translatesAutoresizingMaskIntoConstraints = false
        
        formView.onPaginate = { [weak self] in
            self?.interactor.didPaginate()
        }
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 40),
            formView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 16),
            formView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            formView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            formView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - MainViewControllerProtocol

extension MainViewController: MainViewControllerProtocol {

    func setForm(items: [any FormViewItemProtocol]) {
        formView.set(items: items)
    }
}
