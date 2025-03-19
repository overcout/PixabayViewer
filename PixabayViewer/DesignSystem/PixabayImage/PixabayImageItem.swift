import UIKit

struct PixabayImageItem {
    
    let first: ImageItem
    let second: ImageItem
}

// MARK: - FormViewItemProtocol

extension PixabayImageItem: FormViewItemProtocol {

    var identifier: String { "\(Self.self)" }
    var type: FormViewCellProtocol.Type { PixabayImageCell.self }
}
