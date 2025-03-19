import UIKit

protocol FormViewCellProtocol where Self: UITableViewCell {

    func setFormItem(item: FormViewItemProtocol)

    var height: CGFloat { get }
}
