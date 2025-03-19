import UIKit

final class FormView: UITableView {
    
    // MARK: - Public Properties
    
    var onPaginate: (() -> Void)?
    
    var items: [FormViewItemProtocol] = []
    
    // MARK: - Private Properties
    
    private let identifier: String = "defalutCellIdentifier"
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero, style: .plain)
        setupFormView()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not implemented")
    }
    
    // MARK: - Objc
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
            setBottomInset(to: keyboardHeight)
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        setBottomInset(to: 0.0)
    }
    
    // MARK: - Internal

    func set(items: [FormViewItemProtocol]) {
        guard Thread.isMainThread else {
            DispatchQueue.main.sync { [weak self] in self?.set(items: items) }
            return
        }
        self.items = items
        items.forEach { register($0.type, forCellReuseIdentifier: $0.identifier) }
        reloadData()
        layoutIfNeeded()
    }
    
    func insert(item: FormViewItemProtocol, scrolling: Bool = true) {
        guard Thread.isMainThread else {
            DispatchQueue.main.sync { [weak self] in self?.insert(item: item) }
            return
        }
        register(item.type, forCellReuseIdentifier: item.identifier)
        let path = IndexPath(row: items.count, section: 0)
        self.items.append(item)
        insertRows(at: [path], with: .right)
        guard scrolling else { return }
        scrollToRow(at: path, at: .bottom, animated: true)
    }
}

// MARK: - UITableViewDelegate

extension FormView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = items[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: item.identifier) as? FormViewCellProtocol else {
            return UITableView.automaticDimension
        }
        return cell.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.contentSize.height > 0 else { return }
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let tableViewHeight = scrollView.frame.height
        
        if offsetY > contentHeight - tableViewHeight * 1.5 {
            onPaginate?()
        }
    }
}

// MARK: - UITableViewDataSource

extension FormView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: item.identifier) as? FormViewCellProtocol
        ?? item.type.init(style: .default, reuseIdentifier: item.identifier)
        cell.selectionStyle = .none
        cell.setFormItem(item: item)
        return cell
    }
}

// MARK: - Private

private extension FormView {
    
    func setupFormView() {
        separatorStyle = .none
        delegate = self
        dataSource = self
        estimatedRowHeight = 60
        backgroundColor = .clear
    }

    func setBottomInset(to value: CGFloat) {
        let edgeInset = UIEdgeInsets(top: 0, left: 0, bottom: value, right: 0)
        
        self.contentInset = edgeInset
        self.scrollIndicatorInsets = edgeInset
    }
}
