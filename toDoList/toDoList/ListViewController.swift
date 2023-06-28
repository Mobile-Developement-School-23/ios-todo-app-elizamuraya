
import Foundation
import UIKit

class ListViewController: UIViewController {
    
    //    private lazy var newTaskButton: UIButton = {
    //        let button = UIButton()
    //        button.setTitle("Перейти к дз2", for: .normal)
    //        button.backgroundColor = .white
    //        button.setTitleColor(.black, for: .normal)
    //        button.frame = CGRect(x: 100, y: 100, width: 200, height: 52)
    //        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    //        button.layer.cornerRadius = 16
    //        return button
    //    }()
    //
    //    @objc private func didTapButton() {
    //        let rootVC = TaskViewController()
    //        let navVC = UINavigationController(rootViewController: rootVC)
    //        present(navVC, animated: true)
    //    }
    //
    
    
    
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
        self.navigationController?.present(taskViewController, animated: true)
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


//extension ListViewController {
//    private func setUpConstraints() {
//
//        NSLayoutConstraint.activate([
//            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
//            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//        ])
//    }
//}
//class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
//    
//    weak var ListViewControllerDelegate: TableViewDelegate?
//    private let tableView = TableView()
//    private let fileCache = FileCache()
//    
//    private let headerView: UIView = {
//            let view = UIView()
//            view.backgroundColor = .lightGray
//            return view
//        }()
//    
//    override init(frame: CGRect, style: UITableView.Style) {
//            super.init(frame: frame, style: style)
//            
//            translatesAutoresizingMaskIntoConstraints = false
//            dataSource = self
//            delegate = self
//            register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.idTableViewCell)
//            
//            tableHeaderView = headerView
//        }
//        
//        required init?(coder: NSCoder) {
//            fatalError("init(coder:) has not been implemented")
//        }
//        
//        override func layoutSubviews() {
//            super.layoutSubviews()
//            headerView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height / 20)
//        }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        
//        fileCache.add(TodoItem(text: "Task 1", importance: .normal, dateCreated: Date(), dateChanged: Date()))
//        fileCache.add(TodoItem(text: "Task 2", importance: .high, dateCreated: Date(),  dateChanged: Date()))
//        fileCache.add(TodoItem(text: "Task 3", importance: .low, dateCreated: Date(),  dateChanged: Date()))
//        
//        tableView.mainViewControllerDelegate = self
//        view.addSubview(tableView)
//        
//        NSLayoutConstraint.activate([
//            tableView.topAnchor.constraint(equalTo: view.topAnchor),
//            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
//    }
//    
//    func getItems() -> [TodoItem] {
//        return fileCache.getAll()
//    }
//    
//    func cellTapped(withItem item: TodoItem) {
//        print("Cell tapped with item: \(item.text)")
//    }
//}
//
//protocol TableViewDelegate: AnyObject {
//    func getItems() -> [TodoItem]
//    func cellTapped(withItem item: TodoItem)
//}
//
//class TableView: UITableView, UITableViewDataSource, UITableViewDelegate {
//    weak var mainViewControllerDelegate: TableViewDelegate?
//    
//    init() {
//        super.init(frame: .zero, style: .plain)
//        
//        translatesAutoresizingMaskIntoConstraints = false
//        dataSource = self
//        delegate = self
//        register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.idTableViewCell)
//        tableFooterView = UIView()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//          let titleLabel = UILabel()
//          titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
//          titleLabel.textColor = .white
//          titleLabel.text = "Header Title"
//          
//          headerView.addSubview(titleLabel)
//          titleLabel.translatesAutoresizingMaskIntoConstraints = false
//          
//          NSLayoutConstraint.activate([
//              titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
//              titleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
//              titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor),
//              titleLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor)
//          ])
//          
//          return headerView
//      }
//    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//           return frame.height / 20
//       }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return mainViewControllerDelegate?.getItems().count ?? 0
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = dequeueReusableCell(withIdentifier: TableViewCell.idTableViewCell, for: indexPath) as! TableViewCell
//        
//        if let item = mainViewControllerDelegate?.getItems()[indexPath.row] {
//            cell.task.text = item.text
//        }
//        
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let item = mainViewControllerDelegate?.getItems()[indexPath.row] {
//            mainViewControllerDelegate?.cellTapped(withItem: item)
//        }
//    }
//}
//
//class TableViewCell: UITableViewCell {
//    static let idTableViewCell = "idTableViewCell"
//    
//    let task: UILabel = {
//        let label = UILabel()
//        label.numberOfLines = 3
//        label.tintColor = .black
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setUpViews()
//        setUpConstraints()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func setUpViews() {
//        backgroundColor = .clear
//        selectionStyle = .none
//        addSubview(task)
//    }
//    
//    private func setUpConstraints() {
//        NSLayoutConstraint.activate([
//            task.topAnchor.constraint(equalTo: self.topAnchor, constant: 30),
//            task.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
//            task.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
//            task.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30),
//        ])
//    }
//}
//

//class ListViewController: UIViewController {
//    private let tableView = TableView()
//    private let fileCache = FileCache()
//
//
//    override func viewDidLoad() {
//
//        super.viewDidLoad()
//        setupViews()
//        setupConstraints()
//        title = "Мои дела"
//
//        fileCache.add(TodoItem(text: "Task 1", importance: .normal, dateCreated: Date(), dateChanged: Date()))
//        fileCache.add(TodoItem(text: "Task 2", importance: .high, dateCreated: Date(),  dateChanged: Date()))
//        fileCache.add(TodoItem(text: "Task 3", importance: .low, dateCreated: Date(),  dateChanged: Date()))
//
//       // tableView.ListViewControllerDelegate = self
//      //  view.addSubview(tableView)
//
//        NSLayoutConstraint.activate([
//            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
//            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
//    }
//
//    private func setupViews() {
//        title = "Мои Дела"
//        view.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.9647058824, blue: 0.9490196078, alpha: 1)
//        view.addSubview(tableView)
//    }
//
//    private func setupConstraints() {
//
//        NSLayoutConstraint.activate([
//            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
//            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//        ])
//    }
//
//
//    func getItems() -> [TodoItem] {
//        return fileCache.getAll()
//    }
//
//    func cellTapped(withItem item: TodoItem) {
//        print("Cell tapped with item: \(item.text)")
//    }
//}
//
////protocol TableViewDelegate: AnyObject {
////    func getItems() -> [TodoItem]
////    func cellTapped(withItem item: TodoItem)
////}
//
//class TableView: UITableView, UITableViewDelegate, UITableViewDataSource {
//   // weak var ListViewControllerDelegate: TableViewDelegate?
//    var isExpanded = true
//
//    override init(frame: CGRect, style: UITableView.Style) {
//        super.init(frame: .zero, style: style)
//        setDelegated()
//        configure()
//        register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.idTableViewCell)
//
//    }
//
////    init() {
////        super.init(frame: .zero, style: .plain)
////
////        translatesAutoresizingMaskIntoConstraints = false
////        dataSource = self
////        delegate = self
////        register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.idTableViewCell)
////        tableFooterView = UIView()
////     //   tableView.ListViewController = self
////    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func setDelegated() {
//        dataSource = self
//        delegate = self
//    }
//
//    private func configure() {
//        backgroundColor = .none
//        separatorStyle = .singleLine
//        showsVerticalScrollIndicator = true
//        estimatedRowHeight = 100
//        rowHeight = UITableView.automaticDimension
//        self.translatesAutoresizingMaskIntoConstraints = false
//    }
//
//
////    lazy var setUpHeader = { [weak self] in
////        guard let self else {return}
////        let tableHeaderView = HeaderView(frame: CGRect(x: 0, y: 0,
////                                                       width: self.ListViewControllerDelegate?.view.frame.size.width ?? 0,
////                                                       height: (self.ListViewControllerDelegate?.view.frame.size.height ?? 0)/20))
////        tableHeaderView.tableViewDelegate = self
////        self.tableHeaderView = tableHeaderView
////    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return ListViewControllerDelegate?.getItems().count ?? 0
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = dequeueReusableCell(withIdentifier: TableViewCell.idTableViewCell, for: indexPath) as! TableViewCell
//
//        if let item = ListViewControllerDelegate?.getItems()[indexPath.row] {
//            cell.task.text = item.text
//        }
//
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let item = ListViewControllerDelegate?.getItems()[indexPath.row] {
//            ListViewControllerDelegate?.cellTapped(withItem: item)
//        }
//    }
//}
//
//class TableViewCell: UITableViewCell {
//    static let idTableViewCell = "idTableViewCell"
//
//    let task: UILabel = {
//        let label = UILabel()
//        label.numberOfLines = 3
//        label.tintColor = .black
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setUpViews()
//        setUpConstraints()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func setUpViews() {
//        backgroundColor = .clear
//        selectionStyle = .none
//        addSubview(task)
//    }
//
//    private func setUpConstraints() {
//        NSLayoutConstraint.activate([
//            task.topAnchor.constraint(equalTo: self.topAnchor, constant: 30),
//            task.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
//            task.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
//            task.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30),
//        ])
//    }
//}
//
////
////class TableViewCell: UITableViewCell {
////
////    static let idTableViewCell = "idTableViewCell"
////
////    let task: UILabel = {
////        let label = UILabel()
////        label.numberOfLines = 3
////        label.tintColor = .black
////        label.translatesAutoresizingMaskIntoConstraints = false
////        return label
////    }()
////
////    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
////        super.init(style: style, reuseIdentifier: reuseIdentifier)
////        setUpViews()
////        setUpConstraints()
////    }
////
////    required init?(coder: NSCoder) {
////        fatalError("init(coder:) has not been implemented")
////    }
////
////    private func setUpViews() {
////        backgroundColor = .clear
////        selectionStyle = .none
////        addSubview(task)
////    }
////
////    var viewModel: TableViewCellViewType? {
////        willSet(viewModel) {
////            task.text = viewModel?.task
////        }
////    }
////
////    private func setUpConstraints() {
////        NSLayoutConstraint.activate([
////
////            task.topAnchor.constraint(equalTo: self.topAnchor, constant: 30),
////            task.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
////            task.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
////            task.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30),
////        ])
////    }
////}
//
//
//
//
////  private var mainViewModel: TableViewViewModelType?
////
////    private let tableView = TableView()
////
////    convenience init(viewModel: TableViewViewModelType? = nil) {
////        self.init()
////        self.mainViewModel = viewModel
////    }
////
////    override func viewDidLoad() {
////        super.viewDidLoad()
////
////        setUpViews()
////        setUpConstraints()
////        setUpDelegates()
////        tableView.setUpHeader()
////    }
////
////    private func setUpViews() {
////        title = "Мои Дела"
////        view.backgroundColor = #colorLiteral(red: 0.969507277, green: 0.9645399451, blue: 0.9473810792, alpha: 1)
////        view.addSubview(tableView)
////    }
////
////    private func setUpDelegates() {
////        tableView.mainViewControllerDelegate = self
////    }
////
////    deinit {
////        print("Gone")
////    }
////
////}
////
//////extension ListViewController: TableViewMainProtocol {
//////
////////    func getViewModel() -> TableViewViewModelType? {
////////        return mainViewModel
////////    }
//////
////////    func cellTapped(withViewModel viewModel: DetailViewModelType?) {
////////        let vc = DetailViewController(viewModel: viewModel)
////////        present(vc, animated: true)
////////    }
//////}
////
////
////extension ListViewController {
////    private func setUpConstraints() {
////
////        NSLayoutConstraint.activate([
////            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
////            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
////            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
////            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
////        ])
////    }
////}
////
//// MARK: – TableView
////
////protocol TableViewMainProtocol: AnyObject {
////    func getViewModel() -> TableViewViewModelType?
////    func cellTapped(withViewModel viewModel: DetailViewModelType?)
////}
////
////class TableView: UITableView {
////
////    weak var mainViewControllerDelegate: ListViewController?
////    var tasks = [TodoItem]()
////
////    var isExpanded = true
////
////    override init(frame: CGRect, style: UITableView.Style) {
////        super.init(frame: .zero, style: style)
////        setDelegated()
////        configure()
////        register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.idTableViewCell)
////
////    }
////
////    required init?(coder: NSCoder) {
////        fatalError("init(coder:) has not been implemented")
////    }
////
////    private func setDelegated() {
////        dataSource = self
////        delegate = self
////    }
////
////    private func configure() {
////        backgroundColor = .none
////        separatorStyle = .singleLine
////        showsVerticalScrollIndicator = true
////        estimatedRowHeight = 100
////        rowHeight = UITableView.automaticDimension
////        self.translatesAutoresizingMaskIntoConstraints = false
////    }
////
////
////    lazy var setUpHeader = { [weak self] in
////        guard let self else {return}
////        let tableHeaderView = HeaderView(frame: CGRect(x: 0, y: 0,
////                                                       width: self.mainViewControllerDelegate?.view.frame.size.width ?? 0,
////                                                       height: (self.mainViewControllerDelegate?.view.frame.size.height ?? 0)/20))
////        tableHeaderView.tableViewDelegate = self
////        self.tableHeaderView = tableHeaderView
////    }
////}
////
////extension TableView: UITableViewDataSource {
////    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//////        guard let mainViewControllerDelegate,
//////              let viewModel = mainViewControllerDelegate.getViewModel() else { return 0 }
//////
//////        return isExpanded ?  viewModel.numberOfRows() : 0
////        return 10
////    }
////
////    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
////let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.idTableViewCell, for: indexPath) as? TableViewCell
////                let viewModel = mainViewControllerDelegate?.getViewModel() else {return UITableViewCell()}
////
////        let cellViewModel = viewModel.cellViewModel(forIndexPath: indexPath)
////
////        cell.viewModel = cellViewModel
////
////        return cell ?? TableViewCell
////        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
////                cell.textLabel?.text = tasks[indexPath.row].text
////
////                return cell
////    }
////}
////
////extension TableView: UITableViewDelegate {
////    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
////        guard let viewModel = mainViewControllerDelegate?.getViewModel() else {return}
////
////        let detailViewModel = viewModel.viewModelForSelectedRow(forIndexPath: indexPath)
////
////        mainViewControllerDelegate?.cellTapped(withViewModel: detailViewModel)
////    }
////}
////
////// MARK: – TableViewCell
////
////class TableViewCell: UITableViewCell {
////
////    static let idTableViewCell = "idTableViewCell"
////
////    let task: UILabel = {
////        let label = UILabel()
////        label.numberOfLines = 3
////        label.tintColor = .black
////        label.translatesAutoresizingMaskIntoConstraints = false
////        return label
////    }()
////
////    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
////        super.init(style: style, reuseIdentifier: reuseIdentifier)
////        setUpViews()
////        setUpConstraints()
////    }
////
////    required init?(coder: NSCoder) {
////        fatalError("init(coder:) has not been implemented")
////    }
////
////    private func setUpViews() {
////        backgroundColor = .clear
////        selectionStyle = .none
////        addSubview(task)
////    }
////
////    var viewModel: TableViewCellViewType? {
////        willSet(viewModel) {
////            task.text = viewModel?.task
////        }
////    }
////
////
////
////extension TableViewCell {
////    private func setUpConstraints() {
////        NSLayoutConstraint.activate([
////
////            task.topAnchor.constraint(equalTo: self.topAnchor, constant: 30),
////            task.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
////            task.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
////            task.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30),
////        ])
////    }
////}
////
////// MARK: – Header View
////
////class HeaderView: UIView {
////
////    weak var tableViewDelegate: TableView?
////
////    lazy var button: UIButton = {
////        let button = UIButton(type: .system)
////        button.setTitle("Свернуть", for: .normal)
////        button.translatesAutoresizingMaskIntoConstraints = false
////        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
////        return button
////    }()
////
////    let label: UILabel = {
////        let label = UILabel()
////        label.text = "Выполнено - 5"
////        label.textColor = .lightGray
////        label.translatesAutoresizingMaskIntoConstraints = false
////        return label
////    }()
////
////    override init(frame: CGRect) {
////        super.init(frame: frame)
////        setUpViews()
////        setupConstraints()
////    }
////
////    required init?(coder aDecoder: NSCoder) {
////        super.init(coder: aDecoder)
////        setUpViews()
////        setupConstraints()
////    }
////
////    private func setUpViews() {
////        addSubview(button)
////        addSubview(label)
////    }
////
////    private func setupConstraints() {
////        NSLayoutConstraint.activate([
////            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
////            label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
////            label.widthAnchor.constraint(equalToConstant: 200),
////            label.heightAnchor.constraint(equalToConstant: 30),
////
////            button.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
////            button.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
////            button.widthAnchor.constraint(equalToConstant: 100),
////            button.heightAnchor.constraint(equalToConstant: 30)
////        ])
////    }
////
////    @objc private func buttonTapped() {
////        guard let tableViewDelegate else { return }
////        tableViewDelegate.isExpanded ? button.setTitle("Развернуть", for: .normal) : button.setTitle("Свернуть", for: .normal)
////        tableViewDelegate.isExpanded = !tableViewDelegate.isExpanded
////        UIView.animate(withDuration: 0.4) {
////            tableViewDelegate.reloadData()
////        }
////    }
////
////}
////
//
