//
//  ConfigViews.swift
//  PXTestProject
//
//  Created by AUGUSTO COLLERONE ALFONSO on 10/10/2019.
//  Copyright © 2019 Mercado Pago. All rights reserved.
//

import UIKit

class StringConfigView: UIView, UITextFieldDelegate {
    let title: String
    let initialValue: String
    let callback: (String) -> Void

    init(title: String, initialValue: String, callback: @escaping (String) -> Void) {
        self.title = title
        self.initialValue = initialValue
        self.callback = callback
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        render()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func render() {
        self.isUserInteractionEnabled = true
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = title
        addSubview(label)

        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = UITextField.BorderStyle.line
        textField.placeholder = "Enter text here"
        textField.text = initialValue
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.clearButtonMode = UITextField.ViewMode.whileEditing;
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        textField.delegate = self
        addSubview(textField)

        // Auto layout constraints
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            textField.centerYAnchor.constraint(equalTo: centerYAnchor),
            textField.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            textField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6),
            heightAnchor.constraint(equalToConstant: 80)
        ])
    }


    // MARK: Textfield delegate methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case textField:
            textField.resignFirstResponder()
        default:
            break
        }
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if let text = textField.text {
            callback(text)
        }
    }
}

class BoolConfigView: UIView, UITextFieldDelegate {
    let title: String
    let initialValue: Bool
    let callback: (Bool) -> Void

    init(title: String, initialValue: Bool, callback: @escaping (Bool) -> Void) {
        self.title = title
        self.initialValue = initialValue
        self.callback = callback
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        render()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func render() {
        self.isUserInteractionEnabled = true
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = title
        addSubview(label)

        let toggleSwitch = UISwitch()
        toggleSwitch.translatesAutoresizingMaskIntoConstraints = false
        toggleSwitch.setOn(initialValue, animated: false)
        toggleSwitch.addTarget(self, action: #selector(self.switchValueDidChange), for: .valueChanged)
        addSubview(toggleSwitch)

        // Auto layout constraints
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            toggleSwitch.centerYAnchor.constraint(equalTo: centerYAnchor),
            toggleSwitch.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 20),
            toggleSwitch.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc func switchValueDidChange(sender: UISwitch) {
        callback(sender.isOn)
    }
}
