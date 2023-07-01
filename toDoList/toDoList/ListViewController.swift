import UIKit

protocol ListViewControllerDelegate: AnyObject {
    func saveItem(_ todoItem: TodoItem)
    func deleteItem(_ id: String,_ reloadTable: Bool)
}

class ListViewController: UIViewController {
    private let fileCache: DataCache = FileCache()
    private var items: [TodoItem] = []
    
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
    
    private var countImage: Int = 0 {
        didSet {
            doneLabel.text = "Выполнено — 0"
        }
    }
    
    private lazy var addButton: UIButton = {
        let image = UIImage(named: "Add")?.withRenderingMode(.alwaysOriginal)
        let addButton = UIButton(primaryAction: UIAction(image: image, handler: { [weak self] _ in
            let taskViewController = TaskViewController()
            taskViewController.delegate = self
            self?.present(taskViewController, animated: true)
        }))
        addButton.translatesAutoresizingMaskIntoConstraints = false
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
        doneLabel.text = "Выполнено — 0"
        doneLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2896316225)
        return doneLabel
    }()
    
    private lazy var tasksDoneButton: UIButton = {
        let tasksDoneButton = UIButton(configuration: .plain())
        tasksDoneButton.translatesAutoresizingMaskIntoConstraints = false
        tasksDoneButton.configuration?.attributedTitle = AttributedString("Скрыть", attributes: attributeContainer)
        tasksDoneButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            if tasksDoneButton.titleLabel?.text == "Скрыть" {
                tasksDoneButton.configuration?.attributedTitle = AttributedString("Показать", attributes: attributeContainer)
            } else {
                tasksDoneButton.configuration?.attributedTitle = AttributedString("Скрыть", attributes: attributeContainer)
            }
        }), for: .touchUpInside)
        return tasksDoneButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        view.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.9647058824, blue: 0.9490196078, alpha: 1)
        navigationItem.title = "Мои дела"
        navigationController?.navigationBar.layoutMargins = UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 0)
        tableView.register(ListCell.self, forCellReuseIdentifier: ListCell.reuseId)
        try! fileCache.save(toFile: defaultName, format: .json)
        loadItems()
    }
    
    private func setupViews() {
        view.addSubview(tableView)
        view.addSubview(addButton)
        headerView.addSubview(doneLabel)
        headerView.addSubview(tasksDoneButton)
    }
    
    // MARK: Actions
    
    @objc func openTaskViewController() {
        let taskViewController = TaskViewController()
        navigationController?.present(taskViewController, animated: true)
    }
    
    private func loadItems() {
        do {
            try fileCache.load(from: defaultName, format: .json)
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
//        if let toDoItem = fileCache.items.first(where: { $0.value.id == id }), toDoItem.value.isCompleted {
//            countImage -= 1
//        }
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

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0 || indexPath.row == tableView.numberOfRows(inSection: 0) - 1 {
            let shape = CAShapeLayer()
            let rect = CGRect(x: 0, y: 0, width: cell.bounds.width, height: cell.bounds.size.height)
            let corners: UIRectCorner = indexPath.row == 0 ? [.topLeft, .topRight] : [.bottomRight, .bottomLeft]
            
            shape.path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: 16, height: 16)).cgPath
            cell.layer.mask = shape
            cell.layer.masksToBounds = true
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileCache.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListCell.reuseId, for: indexPath) as! ListCell
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "ellipse"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(changeImageButtonPressed(sender:)), for: .touchUpInside)
        cell.contentView.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
            button.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 30),
            button.heightAnchor.constraint(equalToConstant: 30),
        ])
        
        cell.textLabel?.text = fileCache.itemsSorted[indexPath.row].text
        cell.textLabel?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cell.textLabel!.leadingAnchor.constraint(equalTo: button.trailingAnchor, constant: 12),
            cell.textLabel!.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
        ])
        
        let arrowImageView = UIImageView()
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        arrowImageView.image = UIImage(named: "arrow")
        cell.contentView.addSubview(arrowImageView)
        
        NSLayoutConstraint.activate([
            arrowImageView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -32),
            arrowImageView.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
        ])
        return cell
    }

    @objc func changeImageButtonPressed(sender: UIButton) {
        let ellipse = UIImage(named: "Ellipse")
        let bounds = UIImage(named: "Bounds")
        
        
        if let cell = sender.superview?.superview as? ListCell,
           let indexPath = tableView.indexPath(for: cell) {
            if sender.image(for: .normal)?.pngData() == ellipse?.pngData() {
                var currentItem = fileCache.itemsSorted[indexPath.row]
                currentItem.isCompleted = true
                
                sender.setImage(bounds, for: .normal)
                countImage += 1
                
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: cell.textLabel?.text ?? "")
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                cell.textLabel?.attributedText = attributeString
            } else {
                var currentItem = fileCache.itemsSorted[indexPath.row]
                currentItem.isCompleted = false
                
                sender.setImage(ellipse, for: .normal)
                sender.setImage(ellipse, for: .normal)
                countImage -= 1
                
                let normalString: NSMutableAttributedString =  NSMutableAttributedString(string: fileCache.itemsSorted[indexPath.row].text)
                normalString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 0, range: NSMakeRange(0, normalString.length))
                cell.textLabel?.attributedText = normalString
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        let taskViewController = TaskViewController()
        taskViewController.transitioningDelegate = self
        taskViewController.modalPresentationStyle = .custom
        taskViewController.delegate = self
        taskViewController.currentTodoItem = fileCache.itemsSorted[indexPath.row]
        present(taskViewController, animated: true, completion: nil)
    }
    
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        56
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let doneAction = UIContextualAction(style: .normal, title: nil) { [weak self] _, _, completionHandler in
            guard let self = self else { return }
            
            if let cell = tableView.cellForRow(at: indexPath) as? ListCell,
               let button = cell.contentView.subviews.first(where: { $0 is UIButton }) as? UIButton {
                self.changeImageButtonPressed(sender: button)
            }
            completionHandler(true)
        }
        
        doneAction.backgroundColor = #colorLiteral(red: 0.2260308266, green: 0.8052191138, blue: 0.4233448207, alpha: 1)
        doneAction.image = UIImage(systemName: "checkmark.circle.fill")
        return UISwipeActionsConfiguration(actions: [doneAction])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, _ in
            guard let self else { return }
            let toDoItem = fileCache.itemsSorted[indexPath.row]
            
            deleteItem(toDoItem.id, false)
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
                                          actionProvider: { [weak self] _ in
            guard let self else { return UIMenu() }
            //            let inspectAction =
            //            UIAction(title: NSLocalizedString("Редактировать", comment: ""),
            //                     image: UIImage(systemName: "arrow.up.square"))
            //            { _ in
            //                self.editTask(index)
            //            }
            let deleteAction =
            UIAction(title: NSLocalizedString("Удалить", comment: ""),
                     image: UIImage(systemName: "trash"),
                     attributes: .destructive)
            { _ in
                let toDoItem = self.fileCache.itemsSorted[index]
                self.deleteItem(toDoItem.id)
            }
            return UIMenu(title: "", children: [deleteAction])
        })
    }
    
    
    func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        print("willPerformPreviewActionForMenuWith")
        guard let identifier = configuration.identifier as? String, let index = Int(identifier) else { return }
        let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0))
        animator.addCompletion {
            let vc = TaskViewController()
            self.present(vc, animated: true)
            print("animator")
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            
            addButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            doneLabel.topAnchor.constraint(equalTo: headerView.topAnchor),
            doneLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            doneLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 28),
            
            tasksDoneButton.topAnchor.constraint(equalTo: headerView.topAnchor),
            tasksDoneButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            tasksDoneButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
        ])
    }
}

extension ListViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomTransitionAnimator()
    }
}
