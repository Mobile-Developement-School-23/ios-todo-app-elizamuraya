
import Foundation
import UIKit

class ListViewController: UIViewController {

    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.estimatedRowHeight = 56
        tableView.separatorStyle = .singleLine
        tableView.showsVerticalScrollIndicator = true
        tableView.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.9647058824, blue: 0.9490196078, alpha: 1)
        tableView.tableHeaderView = headerView
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        // tableView.pin(to: view)
        // tableView.register(ListCell.self, forCellReuseIdentifier: ListCell.idTableViewCell)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        
        view.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.9647058824, blue: 0.9490196078, alpha: 1)
        navigationItem.title = "Мои дела"
        navigationController?.navigationBar.layoutMargins = UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 0)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        //   setUpConstraints()
        
    }
    
    private func setupViews() {
        view.addSubview(tableView)
        view.addSubview(addButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            addButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
        ])
    }
    
    private lazy var headerView: UIView = {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 40))
        headerView.addSubview(doneLabel)
        headerView.addSubview(showDoneTasksButton)
        NSLayoutConstraint.activate([
            doneLabel.topAnchor.constraint(equalTo: headerView.topAnchor),
            doneLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            doneLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            showDoneTasksButton.topAnchor.constraint(equalTo: headerView.topAnchor),
            showDoneTasksButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            showDoneTasksButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
        ])
        return headerView
    }()
    
    private let doneLabel: UILabel = {
        let doneLabel = UILabel()
        doneLabel.translatesAutoresizingMaskIntoConstraints = false
        doneLabel.text = "Выполнено — 5"
        doneLabel.textColor = UIColor(named: "doneLabel")
        return doneLabel
    }()
    
    private lazy var showDoneTasksButton: UIButton = {
        let showDoneTasksButton = UIButton(configuration: .plain(), primaryAction: UIAction(handler: { [weak self] _ in
            guard let self else { return }
            if self.showDoneTasksButton.titleLabel?.text == "Показать" {
                self.showDoneTasksButton.configuration?.attributedTitle = AttributedString("Скрыть", attributes: self.attributeContainer)
            } else {
                self.showDoneTasksButton.configuration?.attributedTitle = AttributedString("Показать", attributes: self.attributeContainer)
            }
        }))
        
        showDoneTasksButton.translatesAutoresizingMaskIntoConstraints = false
        showDoneTasksButton.configuration?.attributedTitle = AttributedString("Показать", attributes: attributeContainer)
        return showDoneTasksButton
    }()
    
    private let addButton: UIButton = {
        let image = UIImage(named: "Add")?.withRenderingMode(.alwaysOriginal)
        let addButton = UIButton(primaryAction: UIAction(image: image, handler: { _ in
            
        }))
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.addTarget(self, action: #selector(openTaskViewController), for: .touchUpInside)
        addButton.layer.shadowColor = UIColor.black.cgColor
        addButton.layer.shadowOffset = CGSize(width: 0, height: 8)
        addButton.layer.shadowOpacity = 0.3
        addButton.layer.shadowRadius = 10
        return addButton
    }()
    
    @objc func openTaskViewController() {
        let taskViewController = TaskViewController()
       // present(taskViewController, animated: true)
        navigationController?.pushViewController(taskViewController, animated: true)
       // self.navigationController?.present(taskViewController, animated: true)
    }
    private let attributeContainer: AttributeContainer = {
        var container = AttributeContainer()
        container.font = .systemFont(ofSize: 17, weight: .semibold)
        return container
    }()
    
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    
        func tableView(_: UITableView, cellForRowAt _: IndexPath) -> UITableViewCell {
             let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
             cell.textLabel?.text = "123"
             return cell
         }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//         let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomViewCell
//         let button = UIButton(type: .custom)
//         button.setImage(UIImage(named: "ellipse"), for: .normal)
//         button.translatesAutoresizingMaskIntoConstraints = false
//         button.addTarget(self, action: #selector(changeImageButtonPressed(sender:)), for: .touchUpInside)
//
//         cell.contentView.addSubview(button)
//
//         NSLayoutConstraint.activate([
//             button.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
//             button.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
//             button.widthAnchor.constraint(equalToConstant: 30),
//             button.heightAnchor.constraint(equalToConstant: 30),
//         ])
//
//         return cell
//     }



     @objc func changeImageButtonPressed(sender: UIButton) {
         let addImage = UIImage(named: "ellipse")
         let item1Image = UIImage(named: "bounds")
         if sender.image(for: .normal)?.pngData() == addImage?.pngData() {
             sender.setImage(item1Image, for: .normal)
         } else {
             sender.setImage(addImage, for: .normal)
         }
     }
    
    
    

    
    func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
         print(indexPath.row)
         if indexPath.row == 0 || indexPath.row == tableView.numberOfRows(inSection: 0) - 1 {
             let shape = CAShapeLayer()
             let rect = CGRect(x: 0, y: 0, width: cell.bounds.width, height: cell.bounds.size.height)
             let corners: UIRectCorner = indexPath.row == 0 ? [.topLeft, .topRight] : [.bottomRight, .bottomLeft]

             shape.path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: 16, height: 16)).cgPath
             cell.layer.mask = shape
             cell.layer.masksToBounds = true
         }
     }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
        let taskViewController = TaskViewController()
        taskViewController.transitioningDelegate = self
        taskViewController.modalPresentationStyle = .custom
        present(taskViewController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
           56
       }
    
    func tableView(_: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point _: CGPoint) -> UIContextMenuConfiguration? {
           let index = indexPath.row
           let identifier = "\(index)" as NSString
           return UIContextMenuConfiguration(identifier: identifier,
                                             previewProvider: nil,
                                             actionProvider: { _ in
                                                 let inspectAction =
                                                     UIAction(title: NSLocalizedString("InspectTitle", comment: ""),
                                                              image: UIImage(systemName: "arrow.up.square"))
                                                 { _ in
                                                    
                                                 }
                                                 let duplicateAction =
                                                     UIAction(title: NSLocalizedString("DuplicateTitle", comment: ""),
                                                              image: UIImage(systemName: "plus.square.on.square"))
                                                 { _ in
                                                     
                                                 }
                                                 let deleteAction =
                                                     UIAction(title: NSLocalizedString("DeleteTitle", comment: ""),
                                                              image: UIImage(systemName: "trash"),
                                                              attributes: .destructive)
                                                 { _ in
                                                  
                                                 }
                                                 return UIMenu(title: "", children: [inspectAction, duplicateAction, deleteAction])
                                             })
       }

       func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
           print("willPerformPreviewActionForMenuWith")
           guard let identifier = configuration.identifier as? String, let index = Int(identifier) else { return }
           let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0))
           animator.addCompletion {
               let vc = TaskViewController()
   //            self.show(vc, sender: cell)
               self.present(vc, animated: true)
               print("animator")
           }
       }

    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: ListCell.idTableViewCell, for: indexPath) as! ListCell
//        cell.task.text =  "Task \(indexPath.row + 1)"
//        return cell
//    }
    
}

extension ListViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomTransitionAnimator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomTransitionAnimator()
    }
}

extension ListViewController {
    func fetchData() -> [TodoItem] {
        let item1 = TodoItem(text: "some task", importance: .normal, dateCreated: Date(), dateChanged: Date())
        let item2 = TodoItem(text: "some task", importance: .high, dateCreated: Date(), dateChanged: Date())
        let item3 = TodoItem(text: "some task", importance: .low, dateCreated: Date(), dateChanged: Date())
        
        return [item1, item2, item3]
    }
}
