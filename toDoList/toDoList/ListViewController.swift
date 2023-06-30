import UIKit

protocol ListViewControllerDelegate: AnyObject {
    func saveItem(_ todoItem: TodoItem)
    func deleteItem(_ id: String,_ reloadTable: Bool)
}

class ListViewController: UIViewController {
    private let fileCache: DataCache = FileCache()
    
    //  var todoItem = [TodoItem]()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.9647058824, blue: 0.9490196078, alpha: 1)
        tableView.tableHeaderView = headerView
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var headerView: UIView = {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 40))
        return headerView
    }()
    
    private let attributeContainer: AttributeContainer = {
        var container = AttributeContainer()
        container.font = .systemFont(ofSize: 17, weight: .semibold)
        return container
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
    
    private let defaultName = "Task"
    
    private let doneLabel: UILabel = {
        let doneLabel = UILabel()
        doneLabel.translatesAutoresizingMaskIntoConstraints = false
        doneLabel.text = "Выполнено — 5"
        doneLabel.textColor = UIColor(named: "doneLabel")
        return doneLabel
    }()
    
    private lazy var showDoneTasksButton: UIButton = {
        let showDoneTasksButton = UIButton(configuration: .plain())
        showDoneTasksButton.translatesAutoresizingMaskIntoConstraints = false
        showDoneTasksButton.configuration?.attributedTitle = AttributedString("Показать", attributes: attributeContainer)
        showDoneTasksButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            if showDoneTasksButton.titleLabel?.text == "Показать" {
                showDoneTasksButton.configuration?.attributedTitle = AttributedString("Скрыть", attributes: attributeContainer)
            } else {
                showDoneTasksButton.configuration?.attributedTitle = AttributedString("Показать", attributes: attributeContainer)
            }
        }), for: .touchUpInside)
        return showDoneTasksButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        
        view.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.9647058824, blue: 0.9490196078, alpha: 1)
        navigationItem.title = "Мои дела"
        navigationController?.navigationBar.layoutMargins = UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 0)
        tableView.register(ListCell.self, forCellReuseIdentifier: ListCell.reuseId)
        loadItems()
    }
    
    private func setupViews() {
        view.addSubview(tableView)
        view.addSubview(addButton)
        headerView.addSubview(doneLabel)
        headerView.addSubview(showDoneTasksButton)
    }
    
    // MARK: Actions
    
    @objc func openTaskViewController() {
        let taskViewController = TaskViewController()
        navigationController?.present(taskViewController, animated: true)
    }
    
    private func loadItems() {
        do {
            try fileCache.load(from: defaultName, format: .json)
            items = fileCache.itemsSorted
            tableView.reloadData()
        } catch {
            debugPrint("error")
        }
    }

}


   
    extension ListViewController: ListViewControllerDelegate {
        func saveItem(_ todoItem: TodoItem) {
            fileCache.add(todoItem)
            do {
                try fileCache.save(toFile: defaultName, format: .json)
            } catch {
                debugPrint("error")
            }
            tableView.reloadData()
        }
        
        func deleteItem(_ id: String,_ reloadTable: Bool = true) {
            fileCache.remove(id: id)
            do {
                try fileCache.save(toFile: defaultName, format: .json)
            } catch {
                debugPrint("error")
            }
            if reloadTable {
                tableView.reloadData()
            }
        }
    }

private var items: [TodoItem] = []
    

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListCell.reuseId, for: indexPath) as? ListCell
//        let item = items[indexPath.row]
   //     cell?.setUI(fileCache.itemsSorted[indexPath.row])

               
          
        
//        let button = UIButton(type: .custom)
//        button.setImage(UIImage(named: "ellipse"), for: .normal)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.addTarget(self, action: #selector(changeImageButtonPressed(sender:)), for: .touchUpInside)
//
//        cell.contentView.addSubview(button)
//
//        NSLayoutConstraint.activate([
//            button.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
//            button.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
//            button.widthAnchor.constraint(equalToConstant: 30),
//            button.heightAnchor.constraint(equalToConstant: 30),
//        ])
        
        return cell ?? UITableViewCell()
    }
    
//    @objc func changeImageButtonPressed(sender: UIButton) {
//        let addImage = UIImage(named: "ellipse")
//        let item1Image = UIImage(named: "bounds")
//        if sender.image(for: .normal)?.pngData() == addImage?.pngData() {
//            sender.setImage(item1Image, for: .normal)
//        } else {
//            sender.setImage(addImage, for: .normal)
//        }
//    }
    
    func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? ListCell {
            if indexPath.row == 0 {
                cell.corners = [.topLeft, .topRight]
            } else if indexPath.row == tableView.numberOfRows(inSection: 0) - 1 {
                cell.corners = [.bottomRight, .bottomLeft]
            }
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
        print(fileCache.items.count)
        return 10
       
    }
    
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        56
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let doneAction = UIContextualAction(style: .normal, title: nil) { _, _, _ in
            
        }
        doneAction.backgroundColor = #colorLiteral(red: 0.2260308266, green: 0.8052191138, blue: 0.4233448207, alpha: 1)
        doneAction.image = UIImage(systemName: "checkmark.circle.fill")
        return UISwipeActionsConfiguration(actions: [doneAction])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, _ in
            guard let self else { return }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        deleteAction.image = UIImage(systemName: "trash.fill")
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
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
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            addButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            doneLabel.topAnchor.constraint(equalTo: headerView.topAnchor),
            doneLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            doneLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            
            showDoneTasksButton.topAnchor.constraint(equalTo: headerView.topAnchor),
            showDoneTasksButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            showDoneTasksButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
        ])
    }
    
}

extension ListViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomTransitionAnimator()
    }
    
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


//
//    @objc func changeImageButtonPressed(sender: UIButton) {
//        let addImage = UIImage(named: "ellipse")
//        let item1Image = UIImage(named: "bounds")
//        if sender.image(for: .normal)?.pngData() == addImage?.pngData() {
//            sender.setImage(item1Image, for: .normal)
//        } else {
//            sender.setImage(addImage, for: .normal)
//        }
//    }
//
//
//    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return CustomTransitionAnimator()
//    }




//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: ListCell.idTableViewCell, for: indexPath) as! ListCell
//        cell.task.text =  "Task \(indexPath.row + 1)"
//        return cell
//    }


//    func setCrossed() {
//        guard let viewModel else {return}
//        if viewModel.done {
//            task.textColor = .lightGray
//            let attributedString = NSAttributedString(string: task.text ?? "", attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue])
//            task.attributedText = attributedString
//        } else {
//            task.textColor = .black let attributedString = NSAttributedString(string: task.text ?? "", attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.self])
//            task.attributedText = attributedString
//
////        }
//    }

//    private let attributeContainer: AttributeContainer = {
//           var container = AttributeContainer()
//           container.font = .systemFont(ofSize: 17, weight: .semibold)
//           return container
//       }()






//
//    private func editTask(_ index: Int) {
//            let taskViewController = TaskViewController()
//        TaskViewController.todoItem = fileCache.tasksSorted[index]
//        taskViewController.delegate = self
//            present(taskViewController, animated: true)
//        }



//    func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//
//        //        if indexPath.row == 0  || indexPath.row == 4 {
//        //                  let shape = CAShapeLayer()
//        //                  let rect = CGRect(x: 0, y: 0, width: cell.bounds.width, height: cell.bounds.size.height)
//        //                  let corners: UIRectCorner = indexPath.row == 0 ? [.topLeft, .topRight] : [.bottomRight, .bottomLeft]
//        //
//        //                  shape.path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: 16, height: 16)).cgPath
//        //                  cell.layer.mask = shape
//        //                  cell.layer.masksToBounds = true
//
//        print(indexPath.row)
//        if indexPath.row == 0 || indexPath.row == tableView.numberOfRows(inSection: 0) - 1 {
//            let shape = CAShapeLayer()
//            let rect = CGRect(x: 0, y: 0, width: cell.bounds.width, height: cell.bounds.size.height)
//            let corners: UIRectCorner = indexPath.row == 0 ? [.topLeft, .topRight] : [.bottomRight, .bottomLeft]
//
//            shape.path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: 16, height: 16)).cgPath
//            cell.layer.mask = shape
//            cell.layer.masksToBounds = true
//        }
//    }
