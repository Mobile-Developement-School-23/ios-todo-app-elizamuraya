

import UIKit

class ListCell: UITableViewCell {

   // static let idTableViewCell = "idTableViewCell"

      let task: UILabel = {
          let label = UILabel()
          label.numberOfLines = 3
          label.tintColor = .black
          label.translatesAutoresizingMaskIntoConstraints = false
          return label
      }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
          backgroundColor = .white
          layer.cornerRadius = 16
          selectionStyle = .none
          addSubview(task)
      }

    private func setupConstraints() {
            NSLayoutConstraint.activate([
                heightAnchor.constraint(greaterThanOrEqualToConstant: 60),
                task.centerYAnchor.constraint(equalTo: centerYAnchor),
                task.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
                task.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            ])
        }
}
