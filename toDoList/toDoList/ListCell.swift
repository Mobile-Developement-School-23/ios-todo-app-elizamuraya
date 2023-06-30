import UIKit

class ListCell: UITableViewCell {
    static let reuseId = "ListCell"
    var corners: UIRectCorner = []
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let shape = CAShapeLayer()
        let rect = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.size.height)
        shape.path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: 16, height: 16)).cgPath
        layer.mask = shape
        layer.masksToBounds = true
    }
    
    func setUI(_ todoItem: TodoItem) {
            textLabel?.text = todoItem.text
            textLabel?.numberOfLines = 3
        
            let button = UIButton(type: .custom)
            button.setImage(UIImage(named: "ellipse"), for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(changeImageButtonPressed(sender:)), for: .touchUpInside)

            contentView.addSubview(button)

            NSLayoutConstraint.activate([
                button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                button.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                button.widthAnchor.constraint(equalToConstant: 30),
                button.heightAnchor.constraint(equalToConstant: 30),
            ])

            accessoryView = button
            accessoryType = .none
        }

        @objc func changeImageButtonPressed(sender: UIButton) {
            let addImage = UIImage(named: "ellipse")
            let item1Image = UIImage(named: "bounds")

            if sender.image(for: .normal)?.pngData() == addImage?.pngData() {
                sender.setImage(item1Image, for: .normal)
            } else {
                sender.setImage(addImage, for: .normal)
            }
        }
}
