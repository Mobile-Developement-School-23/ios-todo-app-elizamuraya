import UIKit

class ListViewController: UIViewController {
    let button = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        button.setTitle("Перейти к дз2", for: .normal)
        view.addSubview(button)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.frame = CGRect(x: 100, y: 100, width: 200, height: 52)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        button.layer.cornerRadius = 16
    }
    @objc private func didTapButton() {
        let rootVC = TaskViewController()
        let navVC = UINavigationController(rootViewController: rootVC)
        present(navVC, animated: true)
    }
}
