//
//  ViewController.swift
//  ToDoProject
//
//  Created by MacBookAir on 10.06.2023.
//

import UIKit

class TaskViewController: UIViewController, UITextViewDelegate {
    
 
    // - MARK: UIScrollView + main
    
    private lazy var stackViewMain: UIView = {
        let stackView = UIView()
        //stackView.axis = .vertical
        //stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        //    scrollView.isScrollEnabled = true
        //        scrollView.showsVerticalScrollIndicator = false
        //        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackViewMain.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor).priority = .defaultLow
        return scrollView
    }()
    
    // - MARK: TextUIView
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 17)
        
        textView.textContainerInset = UIEdgeInsets(top: 17, left: 16, bottom: 12, right: 16)
        // textView.attributedText = NSAttributedString("Что нужно сделать?")
        textView.textAlignment = .left
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.cornerRadius = 16
        textView.isScrollEnabled = false
       // textView.text = "Что нужно сделать?"
      //  textView.textColor = .lightGray
        textView.delegate = self
        textView.becomeFirstResponder()
        //  let textFieldOnKeyboard = view.keyboardLayoutGuide.topAnchor.constraint(equalTo: deleteButton.bottomAnchor) // Mark 2
        //  view.keyboardLayoutGuide.setConstraints([textFieldOnKeyboard], activeWhenAwayFrom: .top)
        
        return textView
    }()
    
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        if textView.textColor == UIColor.lightGray {
//            textView.text = nil
//            textView.textColor = UIColor.black
//        }
//    }
//
//    func textViewDidEndEditing(_ textView: UITextView) {
//        if textView.text.isEmpty {
//            textView.text = "Что надо сделать?"
//            textView.textColor = UIColor.lightGray
//        }
//    }
    
    //
    //    func textViewDidBeginEditing(_ textView: UITextView) {
    //        if textView.text == "Что нужно сделать?" {
    //         //   textView.text =
    //            textView.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2039010762)
    //            textView.font = .systemFont(ofSize: 16)
    //        }
    //    }
    //
    //    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    //        if text == "\n" {
    //            textView.resignFirstResponder()
    //        }
    //        return true
    //    }
    // - MARK: 2) StackView – Importance and Deadline
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        //stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.backgroundColor = .white
        stackView.spacing = 16
        stackView.layer.cornerRadius = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        //  stackView.setContentHuggingPriority(.required, for: .horizontal)
        return stackView
    }()
    
    private lazy var row1StackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var separator: UIView = {
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = true
        separator.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2039010762)
        separator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        return separator
    }()
    
    
    private lazy var importanceLabel: UILabel = {
        let label = UILabel()
        label.text = "Важность"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var segmentedControl: UISegmentedControl = {
        
        let segmentedControl = UISegmentedControl(items: [Importance.low.rawValue, Importance.normal.rawValue, Importance.high.rawValue])
        
        segmentedControl.setTitle("нет", forSegmentAt: 1)
        segmentedControl.selectedSegmentIndex = 2
        
        if let lowSegmentImage = UIImage(systemName: "arrow.down") {
            segmentedControl.setImage(lowSegmentImage, forSegmentAt: 0)
            segmentedControl.largeContentImage?.withRenderingMode(.alwaysOriginal)
        }
        
        if let highSegmentImage = UIImage(systemName: "exclamationmark.2") {
            segmentedControl.setImage(highSegmentImage, forSegmentAt: 2)
            segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.red], for: .selected)
        }
        
        let selectedSegmentIndex = segmentedControl.selectedSegmentIndex
        
        var selectedImportance: Importance?
        if selectedSegmentIndex == 1 {
            selectedImportance = Importance.normal
        } else if selectedSegmentIndex == 0 {
            selectedImportance = Importance.low
        } else if selectedSegmentIndex == 2 {
            selectedImportance = Importance.high
        } else {
            selectedImportance = nil
        }
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        segmentedControl.heightAnchor.constraint(equalToConstant: 36).isActive = true
        segmentedControl.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        return segmentedControl
    }()
    
    
    
    private lazy var row2StackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    @objc private func datePickerValueChanged() {
        updateDateButtonText()
    }
    
    private func updateDateButtonText() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        // dateFormatter.defaultDate = .
        let selectedDate = datePicker.date
        let dateString = dateFormatter.string(from: selectedDate)
        // dateButton.setTitle(dateString, for: .normal)
    }
    
    // тут дата вместо сеттайтл
    //
    //    private var dateButton: UIButton = {
    //        let button = UIButton()
    //       // button.isUserInteractionEnabled = true
    //        button.isEnabled = false
    //      //  button.addTarget(self, action: #selector(showDatePicker), for: .touchUpInside)
    //        button.translatesAutoresizingMaskIntoConstraints = false
    //        return button
    //    }()
    //
    /// сделай календарь
    
    //private let dateButton = UIButton(type: .system)
    
    private var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.alpha = 0.0
        return datePicker
    }()
    
    
    
//    private lazy var dateButton: UIButton = {
//        var configuration = UIButton.Configuration.plain()
//        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
//        configuration.attributedTitle = AttributedString(dateFormatter.string(from: tomorrow), attributes: AttributeContainer)
//
//        let dateButton = UIButton(configuration: configuration)
//        dateButton.addAction(UIAction(handler: {[weak self] action in
//            self?.hideCalendar(action.sender)
//        }), for: .touchUpInside)
//        dateButton.isHidden = true
//        dateButton.translatesAutoresizingMaskIntoConstraints = false
//        return dateButton
//
//    }()
//
//    private let attributeContainer: AttributeContainer = {
//        var container = AttributeContainer()
//        container.font = .systemFont(ofSize: 13, weight: .medium)
//        return container
//    }()
//
//        private var calendar: UICalendarView = {
//            let calendar = UICalendarView()
//            calendar.isHidden = true
//            calendar.translatesAutoresizingMaskIntoConstraints = false
//            calendar.availableDateRange = DateInterval(start: tomorrow, end: .distantFuture)
//            let dateSelection = UICalendarSelectionSingleDate(delegate: self)
//            calendar.selectionBehavior = dateSelection
//            return calendar
//        }()
//
//        func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
//            guard let date = dateComponents?.date else { return }
//            dateButton.configuration?.attributedTitle = AttributedString(dateFormatter.string(from: date), attributes: attributeContainer)
//        }
    
    // Отмена
    @objc private func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
    
    private lazy var toggleSwitch: UISwitch = {
        let toggleSwitch = UISwitch()
        toggleSwitch.translatesAutoresizingMaskIntoConstraints = false
        toggleSwitch.addTarget(self, action: #selector(toggleSwitchValueChanged), for: .valueChanged)
        return toggleSwitch
    }()
    
    // Calendar Toggle
    @objc func toggleSwitchValueChanged() {
        datePicker.isHidden = !toggleSwitch.isOn
        let isPickerVisible = toggleSwitch.isOn
        
        // Calendar Animation
        UIView.animate(withDuration: 0.3) {
            self.datePicker.alpha = isPickerVisible ? 1.0 : 0.0
        }
        //  dateButton.isHidden = !toggleSwitch.isOn
        // row3StackView.isHidden = !toggleSwitch.isOn
    }
    
    //
    private lazy var leftStack: UIStackView = {
        let makeBefore = UILabel()
        makeBefore.text = "Сделать до"
        
        let leftStack = UIStackView(arrangedSubviews: [makeBefore, datePicker])
        leftStack.axis = .vertical
        leftStack.distribution = .fillEqually
        leftStack.alignment = .leading
        return leftStack
    }()
    
    private lazy var rightStack: UIStackView = {
        let rightStack = UIStackView(arrangedSubviews: [toggleSwitch])
        rightStack.axis = .vertical
        rightStack.distribution = .fill
        rightStack.alignment = .trailing
        return rightStack
    }()
    
    
    // - MARK: 3) DeleteButton
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Удалить", for: .normal)
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(deleteTask), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        setupAppearance()

        
        title = "Дело"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Отменить", style: .plain, target: self, action: #selector(dismissSelf))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .done, target: self, action: #selector(saveTask))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.lightGray
        
        view.keyboardLayoutGuide.followsUndockedKeyboard = true
        initializeHideKeyboard()
        
    }
    
    // MARK: - Methods
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setupAppearance()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    private func setupAppearance() {
        updateButtonColor()
        
        if traitCollection.userInterfaceStyle == .dark {
            stackViewMain.backgroundColor = #colorLiteral(red: 0.1129594222, green: 0.1133299991, blue: 0.1243038848, alpha: 1)
            textView.backgroundColor = #colorLiteral(red: 0.1930471361, green: 0.19353351, blue: 0.2080074847, alpha: 1)
            textView.textColor = .white
            stackView.backgroundColor = #colorLiteral(red: 0.1930471361, green: 0.19353351, blue: 0.2080074847, alpha: 1)
            deleteButton.backgroundColor = #colorLiteral(red: 0.1930471361, green: 0.19353351, blue: 0.2080074847, alpha: 1)
            segmentedControl.backgroundColor = .black
        } else {
            stackViewMain.backgroundColor = #colorLiteral(red: 0.969507277, green: 0.9645399451, blue: 0.9473810792, alpha: 1)
            textView.backgroundColor = .white
            textView.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            stackView.backgroundColor = .white
            deleteButton.backgroundColor = .white
            segmentedControl.backgroundColor = .white
        }
    }
    
    
    private func updateButtonColor() {
        if textView.text.isEmpty {
            navigationItem.rightBarButtonItem?.tintColor = UIColor.lightGray
            deleteButton.setTitleColor(.lightGray, for: .normal)
        } else {
            navigationItem.rightBarButtonItem?.tintColor = UIColor.systemBlue
            deleteButton.setTitleColor(.red, for: .normal)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        updateButtonColor()
    }
    

    func initializeHideKeyboard(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissMyKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissMyKeyboard(){
        view.endEditing(true)
    }
    

    
    var fileCache = FileCache()
    var currentTodoItem: TodoItem?
    
    @objc private func deleteTask() {
        guard let taskText = textView.text, !taskText.isEmpty else { return }
        print("deleteTask")
        var allItems = fileCache.getAll()
        allItems.popLast()
        
        do {
            try fileCache.saveTaskJSON(toFile: "todoItems")
            
        } catch {
            print("Error saving task to JSON: \(error)")
        }
        print(allItems)
        dismissSelf()
    }
    
    
    // Сохранить
    @objc func saveTask() {
        guard let taskText = textView.text, !taskText.isEmpty else { return }
        let todoItem = TodoItem(text: taskText, importance: .normal, dateCreated: Date(), dateChanged: nil)
        self.currentTodoItem = todoItem
        fileCache.add(todoItem)
        do {
            try fileCache.saveTaskJSON(toFile: "todoItems")
            
        } catch {
            print("Error saving task to JSON: \(error)")
        }
        dismissSelf()
    }
    
    
    // MARK: - setupViews
    
    func setupViews() {
        
        view.addSubview(stackViewMain)
        view.addSubview(scrollView)
        
        stackViewMain.addSubview(scrollView)
        stackViewMain.addSubview(textView)
        stackViewMain.addSubview(stackView)
        stackViewMain.addSubview(deleteButton)
        
        stackView.addArrangedSubview(row1StackView)
        stackView.addArrangedSubview(separator)
        stackView.addArrangedSubview(row2StackView)
        
        row1StackView.addArrangedSubview(importanceLabel)
        row1StackView.addArrangedSubview(segmentedControl)
        
        row2StackView.addArrangedSubview(leftStack)
        row2StackView.addArrangedSubview(rightStack)
        
    }
}

// MARK: - setupConstraints

extension TaskViewController {
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stackViewMain.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            stackViewMain.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            stackViewMain.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stackViewMain.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            stackViewMain.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor),
            stackViewMain.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            
            textView.topAnchor.constraint(equalTo: stackViewMain.topAnchor, constant: 72),
            textView.leadingAnchor.constraint(equalTo: stackViewMain.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: stackViewMain.trailingAnchor, constant: -16),
            textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 120),
            
            
            // textView.heightAnchor.constraint(greaterThanOrEqualToConstant: UIScreen.main.bounds.height * 0.5),
            
            stackView.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: stackViewMain.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: stackViewMain.trailingAnchor, constant: -16),
            //stackView.bottomAnchor.constraint(equalTo: deleteButton.topAnchor),
            
            importanceLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 16),
            leftStack.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 16),
            
            segmentedControl.topAnchor.constraint(equalTo: row1StackView.topAnchor, constant: 10),
            segmentedControl.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -12),
            rightStack.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -12),
          //  dateButton.heightAnchor.constraint(equalToConstant: 18),
            
            deleteButton.heightAnchor.constraint(equalToConstant: 50),
            // deleteButton.widthAnchor.constraint(equalTo: stackViewMain.widthAnchor),
            deleteButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16),
            deleteButton.leadingAnchor.constraint(equalTo: stackViewMain.leadingAnchor, constant: 16),
            deleteButton.trailingAnchor.constraint(equalTo: stackViewMain.trailingAnchor, constant: -16),
         //   deleteButton.bottomAnchor.constraint(equalTo: stackViewMain.bottomAnchor, constant: -16)
        ])
    }
}

//            let isTaskSaved = savedItems.contains { $0.text == taskText }
//                    if isTaskSaved {
//                        print("Task saved to JSON.")
//                    } else {
//                        print("Failed to save task to JSON.")
//                    }

//    private var row3StackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.axis = .horizontal
//        stackView.alignment = .fill
//        stackView.distribution = .fillProportionally
//        stackView.spacing = 16
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.isHidden = true
//        return stackView
//    }()
//



//        view.addSubview(row3StackView)
//        row3StackView.addArrangedSubview(datePicker)

// row2StackView.addArrangedSubview(doBeforeLabel)
// row2StackView.addArrangedSubview(dateButton)
//  row2StackView.addArrangedSubview(toggleSwitch)
//  row2StackView.setContentHuggingPriority(.required, for: .horizontal)

//тут внизу


//        label1.setContentHuggingPriority(.required, for: .vertical)
//        label2.setContentHuggingPriority(.required, for: .vertical)
//        segmentedControl.setContentHuggingPriority(.required, for: .vertical)
//        toggleSwitch.setContentHuggingPriority(.required, for: .vertical)

//            row3StackView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16),
//            row3StackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
//            row3StackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
//            row3StackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),


//            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
//            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
//            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
//            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
// stackView.heightAnchor.constraint(equalToConstant: 117),
//   stackView.bottomAnchor.constraint(equalTo: deleteButton.topAnchor),

//row1StackView.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 16),
//            row1StackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            row1StackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//            row1StackView.bottomAnchor.constraint(equalTo: row2StackView.topAnchor),
//            row1StackView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.5),
//
//            row2StackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            row2StackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//   row2StackView.bottomAnchor.constraint(equalTo: row2StackView.topAnchor),
// row2StackView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.5),
//   row2StackView.heightAnchor.constraint(equalToConstant: 40),

//       тут внизу


//            datePicker.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16),
//            datePicker.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
//            datePicker.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
//            datePicker.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

//            datePicker.leadingAnchor.constraint(equalTo: alertController.view.leadingAnchor, constant: 8),
//            datePicker.trailingAnchor.constraint(equalTo: alertController.view.trailingAnchor, constant: -8),
//            datePicker.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: 8),
//            datePicker.bottomAnchor.constraint(equalTo: alertController.view.bottomAnchor, constant: -8),
//
// importanceLabel.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 17),

//
//            // label1.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 248),
//
//            //doBeforeLabel.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 66.5),

//            doBeforeLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 248),
//            doBeforeLabel.bottomAnchor.constraint(equalTo: row2StackView.bottomAnchor, constant: 16),
//
////            dateButton.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 98),
////            dateButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 16),
////            dateButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 248),
//
//

//           segmentedControl.bottomAnchor.constraint(equalTo: row1StackView.bottomAnchor, constant: 10),
//            // segmentedControl.widthAnchor.constraint(equalToConstant: 150),
//            //  segmentedControl.heightAnchor.constraint(equalToConstant: 36),
//
// toggleSwitch.topAnchor.constraint(equalTo: row2StackView.topAnchor, constant: 10),
//            toggleSwitch.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 280),

//toggleSwitch.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10),
//
//  deleteButton.topAnchor.constraint(equalTo: stackView.bottomAnchor),
//   deleteButton.centerXAnchor.constraint(equalTo: stackViewMain.centerXAnchor),




