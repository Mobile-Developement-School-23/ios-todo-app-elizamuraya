import UIKit

class TaskViewController: UIViewController, UITextViewDelegate {
    weak var delegate: ListViewControllerDelegate?
    
    // MARK: – Private Properties
    
    private lazy var stackViewMain: UIView = {
        let stackView = UIView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let placeholder = "Что надо сделать?"
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackViewMain.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor).priority = .defaultLow
        return scrollView
    }()
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 17)
        textView.textContainerInset = UIEdgeInsets(top: 34, left: 16, bottom: 12, right: 16)
        textView.textAlignment = .left
        textView.isScrollEnabled = false
        textView.layer.cornerRadius = 16
        textView.delegate = self
        textView.text = placeholder
        textView.becomeFirstResponder()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.backgroundColor = .white
        stackView.spacing = 16
        stackView.layer.cornerRadius = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var row1StackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 16
     //   stackView.heightAnchor.constraint(equalToConstant: 56)
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
    
    private lazy var separator2: UIView = {
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = true
        separator.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2039010762)
        separator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        separator.isHidden = true
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
        
        segmentedControl.setTitle("нет", forSegmentAt: 1)
        segmentedControl.selectedSegmentIndex = 2
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
        //  stackView.heightAnchor.constraint(equalToConstant: 120)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.alpha = 0.0
        datePicker.isHidden = true
        return datePicker
    }()
    
    private func updateDateButtonText() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        let selectedDate = datePicker.date
        let dateString = UIButton()
        dateString.setTitle(dateFormatter.string(from: selectedDate), for: .normal)
    }
    
    private lazy var toggleSwitch: UISwitch = {
        let toggleSwitch = UISwitch()
        toggleSwitch.translatesAutoresizingMaskIntoConstraints = false
        toggleSwitch.addTarget(self, action: #selector(toggleSwitchValueChanged), for: .valueChanged)
        return toggleSwitch
    }()
    
    
//    private lazy var newStack: UIStackView = {
//
//        let newStack = UIStackView(arrangedSubviews: [separator2, datePicker])
//        newStack.axis = .vertical
//        newStack.spacing = 10
//        newStack.translatesAutoresizingMaskIntoConstraints = false
//
//        return newStack
//    }()
    
    
    private lazy var leftStack: UIStackView = {
        let makeBefore = UILabel()
        makeBefore.text = "Сделать до"
        makeBefore.translatesAutoresizingMaskIntoConstraints = false
        
        let leftStack = UIStackView(arrangedSubviews: [makeBefore, datePicker])
        leftStack.axis = .vertical
        leftStack.distribution = .fill
        leftStack.alignment = .leading
        
        makeBefore.leadingAnchor.constraint(equalTo: leftStack.leadingAnchor).isActive = true
        makeBefore.topAnchor.constraint(equalTo: leftStack.topAnchor).isActive = true
        return leftStack
    }()
    
    
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
        navigationController?.navigationBar.isHidden = true
        
        setupViews()
        setupConstraints()
        setupAppearance()
        textView.text = currentTodoItem?.text
        view.keyboardLayoutGuide.followsUndockedKeyboard = true
        initializeHideKeyboard()
    }

    private lazy var navigationBar: UINavigationBar = {
        let navigationBar = UINavigationBar()
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        let cancelItem = UIBarButtonItem(primaryAction: UIAction(title: "Отменить") { [weak self] _ in
            self?.dismiss(animated: true)
        })
        let titleItem = UINavigationItem(title: "Дело")
        let saveItem = UIBarButtonItem(primaryAction: UIAction(title: "Сохранить") { [weak self] _ in
            self?.saveTask()
            self?.dismiss(animated: true)
        })
        
        if textView.text.isEmpty {
            saveItem.tintColor = UIColor.lightGray
            deleteButton.setTitleColor(.lightGray, for: .normal)
        } else {
            saveItem.tintColor = UIColor.systemBlue
            deleteButton.setTitleColor(.red, for: .normal)
        }
        
        saveItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)], for: .normal)
        saveItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)], for: .disabled)
        
        titleItem.rightBarButtonItem = saveItem
        titleItem.leftBarButtonItem = cancelItem
        titleItem.rightBarButtonItem?.isEnabled = false
        navigationBar.setItems([titleItem], animated: false)
        navigationBar.shadowImage = UIImage()
        return navigationBar
    }()
    
    private func enabledButtons() {
          guard let saveButton = navigationBar.items?.first?.rightBarButtonItem else { return }
          if !textView.text.isEmpty, textView.text != placeholder, !saveButton.isEnabled {
              saveButton.isEnabled = true
              deleteButton.isEnabled = true
          }
      }
    
    @objc private func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Methods
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setupAppearance()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
           if textView.text == placeholder {
               textView.text = ""
               textView.textColor = UIColor(named: "text")
           }
       }

       func textViewDidEndEditing(_ textView: UITextView) {
           if textView.text.isEmpty {
               textView.text = placeholder
               textView.textColor = .lightGray
               navigationBar.items?.first?.rightBarButtonItem?.isEnabled = false
               deleteButton.isEnabled = false
           }
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
            stackViewMain.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.9647058824, blue: 0.9490196078, alpha: 1)
            textView.backgroundColor = .white
            textView.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            stackView.backgroundColor = .white
            deleteButton.backgroundColor = .white
            segmentedControl.backgroundColor = .white
        }
    }
    
    private func updateButtonColor() {
        if !textView.text.isEmpty {
            navigationItem.rightBarButtonItem?.tintColor = UIColor.systemBlue
            deleteButton.setTitleColor(.red, for: .normal)
            
        } else {
            
            navigationItem.rightBarButtonItem?.tintColor = UIColor.lightGray
            deleteButton.setTitleColor(.lightGray, for: .normal)
        }
    }
    
    func textViewDidChange(_: UITextView) {
            enabledButtons()
        }

    func initializeHideKeyboard(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissMyKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissMyKeyboard(){
        view.endEditing(true)
    }
    
    @objc private func datePickerValueChanged() {
        updateDateButtonText()
    }
    
    @objc func toggleSwitchValueChanged() {
        datePicker.isHidden = !toggleSwitch.isOn
        let isPickerVisible = toggleSwitch.isOn
        
        UIView.animate(withDuration: 0.3) {
            self.datePicker.alpha = isPickerVisible ? 1.0 : 0.0
        }
    }
    
    // MARK: – JSON
    
    var currentTodoItem: TodoItem?
    
    @objc func saveTask() {
        guard let taskText = textView.text, !taskText.isEmpty else { return }

        let todoItem = TodoItem(text: taskText, importance: .normal, dateCreated: Date(), dateChanged: nil)
        delegate?.saveItem(todoItem)
        dismissSelf()
    }
    
    @objc private func deleteTask() {
        self.dismiss(animated: true)
        dismissSelf()
    }
 
    // MARK: - setupViews
    
    func setupViews() {
        
        view.addSubview(stackViewMain)
        view.addSubview(scrollView)
        view.addSubview(navigationBar)
        
        stackViewMain.addSubview(scrollView)
        stackViewMain.addSubview(textView)
        stackViewMain.addSubview(stackView)
        stackViewMain.addSubview(deleteButton)
        
        stackView.addArrangedSubview(row1StackView)
        stackView.addArrangedSubview(separator)
        stackView.addArrangedSubview(row2StackView)
      //  stackView.addArrangedSubview(newStack)
        
        row1StackView.addArrangedSubview(importanceLabel)
        row1StackView.addArrangedSubview(segmentedControl)
        
        row2StackView.addArrangedSubview(leftStack)
        row2StackView.addArrangedSubview(toggleSwitch)
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
            
            navigationBar.heightAnchor.constraint(equalToConstant: 56),
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            textView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 16),
            textView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 120),
            
            stackView.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            
            importanceLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 16),
            leftStack.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 16),
            
            row1StackView.bottomAnchor.constraint(equalTo: separator.bottomAnchor, constant: -5),
            row2StackView.topAnchor.constraint(equalTo: separator.bottomAnchor),
            row2StackView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: -16),
            
            
            separator.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 16),
            separator.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -16),
            segmentedControl.topAnchor.constraint(equalTo: row1StackView.topAnchor, constant: 10),
            segmentedControl.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -12),
            
            toggleSwitch.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -12),
            toggleSwitch.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 13),
            
            leftStack.topAnchor.constraint(equalTo: row2StackView.topAnchor),
            leftStack.bottomAnchor.constraint(equalTo: row2StackView.bottomAnchor),
            
            deleteButton.heightAnchor.constraint(equalToConstant: 50),
            deleteButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16),
            deleteButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            deleteButton.trailingAnchor.constraint(equalTo: stackViewMain.trailingAnchor, constant: -16),
        ])
    }
}
