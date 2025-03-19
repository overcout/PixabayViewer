import UIKit

final class PixabayImageCell: UITableViewCell {
    
    // MARK: - Private Properties
    
    private let imageFirst = ImageView()
    private let imageSecond = ImageView()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageFirst.setImage(uiImage: nil)
        imageFirst.setCaption(text: nil)

        imageSecond.setImage(uiImage: nil)
        imageSecond.setCaption(text: nil)
    }
}

// MARK: - FormViewCellDelegate

extension PixabayImageCell: FormViewCellProtocol {

    func setFormItem(item: FormViewItemProtocol) {
        guard let item = item as? PixabayImageItem else { return }

        imageFirst.setImage(item: item.first)
        imageSecond.setImage(item: item.second)
    }

    var height: CGFloat { UITableView.automaticDimension }
}

// MARK: - Private

private extension PixabayImageCell {

    func setupViews() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.addSubview(imageFirst)
        imageFirst.clipsToBounds = true
        imageFirst.layer.cornerRadius = 16
        imageFirst.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageSecond)
        imageSecond.clipsToBounds = true
        imageSecond.layer.cornerRadius = 16
        imageSecond.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            imageFirst.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 16),
            imageFirst.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            imageFirst.trailingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -8),
            imageFirst.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            imageFirst.heightAnchor.constraint(equalTo: imageFirst.widthAnchor),

            imageSecond.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 16),
            imageSecond.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            imageSecond.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 8),
            imageSecond.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            imageSecond.heightAnchor.constraint(equalTo: imageSecond.widthAnchor),
        ])
    }
}
