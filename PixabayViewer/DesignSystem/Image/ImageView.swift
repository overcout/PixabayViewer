import UIKit

final class ImageView: UIImageView {
    
    // MARK: - Private Properties
    
    private var tapAction: (() -> Void)?
    
    // MARK: - Subviews
    
    private let captionBackground = UIView()
    private let caption = UILabel()
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not implemented")
    }
    
    // MARK: - Internal
    
    func setImage(uiImage: UIImage?) {
        self.image = uiImage
    }
    
    func setCaption(text: String?) {
        caption.text = text
    }
    
    func setImage(item: ImageItem) {
        tapAction = item.tapAction
        caption.text = item.captionText
        load(url: item.imageURL, placeholder: nil)
    }
}

// MARK: - Private

private extension ImageView {
    
    func setupViews() {
        contentMode = .scaleAspectFill
        addSubview(captionBackground)
        captionBackground.backgroundColor = .systemBrown
        captionBackground.translatesAutoresizingMaskIntoConstraints = false
        addSubview(caption)
        caption.textColor = .systemBackground
        caption.translatesAutoresizingMaskIntoConstraints = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        isUserInteractionEnabled = true
        addGestureRecognizer(tapGesture)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            caption.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            caption.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            caption.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            captionBackground.bottomAnchor.constraint(equalTo: bottomAnchor),
            captionBackground.leadingAnchor.constraint(equalTo: leadingAnchor),
            captionBackground.trailingAnchor.constraint(equalTo: trailingAnchor),
            captionBackground.topAnchor.constraint(equalTo: caption.topAnchor, constant: -4)
        ])
    }
    
    @objc func imageTapped() {
        tapAction?()
    }
}
