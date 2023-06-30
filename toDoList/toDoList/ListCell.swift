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
    }
}

//      let task: UILabel = {
//          let label = UILabel()
//          label.numberOfLines = 3
//          label.tintColor = .black
//          label.translatesAutoresizingMaskIntoConstraints = false
//          return label
//      }()
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setupViews()
//        setupConstraints()
//
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func setupViews() {
//          backgroundColor = .white
//          layer.cornerRadius = 16
//          selectionStyle = .none
//          addSubview(task)
//      }
//
//    private func setupConstraints() {
//            NSLayoutConstraint.activate([
//                heightAnchor.constraint(greaterThanOrEqualToConstant: 60),
//                task.centerYAnchor.constraint(equalTo: centerYAnchor),
//                task.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
//                task.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
//            ])
//        }
//}
