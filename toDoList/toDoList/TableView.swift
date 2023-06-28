////
////  TableView.swift
////  toDoList
////
////  Created by MacBookAir on 27.06.2023.
////
//
//import Foundation
//import UIKit
//
//protocol TableViewMainProtocol: AnyObject {
////    func getViewModel() -> TableViewViewModelType?
////    func cellTapped(withViewModel viewModel: DetailViewModelType?)
//}
//
//class TableView: UITableView {
//    
//    weak var mainViewControllerDelegate: ListViewController?
//    
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
//        backgroundColor = .specialBackground
//        separatorStyle = .singleLine
//        showsVerticalScrollIndicator = true
//        estimatedRowHeight = 100
//        rowHeight = UITableView.automaticDimension
//        self.translatesAutoresizingMaskIntoConstraints = false
//    }
//    
//    
//    lazy var setUpHeader = { [weak self] in
//        guard let self else {return}
//        let tableHeaderView = HeaderView(frame: CGRect(x: 0, y: 0,
//                                                       width: self.mainViewControllerDelegate?.view.frame.size.width ?? 0,
//                                                       height: (self.mainViewControllerDelegate?.view.frame.size.height ?? 0)/20))
//        tableHeaderView.tableViewDelegate = self
//        self.tableHeaderView = tableHeaderView
//    }
//}
//
//extension TableView: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        guard let mainViewControllerDelegate,
//              let viewModel = mainViewControllerDelegate.getViewModel() else { return 0 }
//
//        return isExpanded ?  viewModel.numberOfRows() + 1 : 1
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.idTableViewCell, for: indexPath) as? TableViewCell,
//              let viewModel = mainViewControllerDelegate?.getViewModel() else {return UITableViewCell()}
//        
//        let lastRow = tableView.numberOfRows(inSection: 0) - 1
//        if indexPath.row != lastRow {
//            let cellViewModel = viewModel.cellViewModel(forIndexPath: indexPath)
//            cell.viewModel = cellViewModel
//            return cell
//        }
//
//        cell.textLabel?.text = "Новое"
//        cell.textLabel?.textColor = .lightGray
//        return cell
//    }
//}
//
//extension TableView: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let lastRow = tableView.numberOfRows(inSection: 0) - 1
//        if indexPath.row != lastRow {
//            guard let viewModel = mainViewControllerDelegate?.getViewModel() else {return}
//            let detailViewModel = viewModel.viewModelForSelectedRow(forIndexPath: indexPath)
//            mainViewControllerDelegate?.cellTapped(withViewModel: detailViewModel)
//        } else {
//            print("Новое")
//        }
//    }
//}
