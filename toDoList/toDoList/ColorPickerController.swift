//
//  ColorPickerViewController.swift
//  ToDoProject
//
//  Created by MacBookAir on 23.06.2023.
//
import UIKit

public protocol ColorPickerDelegate: AnyObject {
    func didSelectColor(_ color: UIColor)
}

public class ColorPickerView: UIView {
    weak var delegate: ColorPickerDelegate?
    private let colors: [UIColor] = [.red, .blue, .green, .yellow, .orange, .purple]
    private let buttonSize: CGFloat = 40.0
    private let buttonSpacing: CGFloat = 8.0
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupColorButtons()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupColorButtons()
    }
    public  func setupColorButtons() {
        var xOffset: CGFloat = 0.0
        for color in colors {
            let colorButton = UIButton(type: .custom)
            colorButton.backgroundColor = color
            colorButton.layer.cornerRadius = buttonSize / 2.0
            colorButton.addTarget(self, action: #selector(colorButtonTapped(_:)), for: .touchUpInside)
            addSubview(colorButton)
            
            colorButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                colorButton.widthAnchor.constraint(equalToConstant: buttonSize),
                colorButton.heightAnchor.constraint(equalToConstant: buttonSize),
                colorButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: xOffset),
                colorButton.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
            
            xOffset += buttonSize + buttonSpacing
        }
    }
    
    @objc public func colorButtonTapped(_ sender: UIButton) {
        let selectedColor = sender.backgroundColor ?? .clear
        delegate?.didSelectColor(selectedColor)
    }
}
