//
//  FormDatePicker.swift
//  FormController
//
//  Created by Windy on 17/01/22.
//

import UIKit

class FormDatePicker: UIView, UITextFieldDelegate {
    
    var didChange: ((String) -> ())?
    
    private var labelTextField: UILabel!
    private var textField: UITextField!
    private var datePicker: UIDatePicker!
    private var dateFormatStyle: DateFormatter.Style!
    
    convenience init(
        label: String,
        placeholder: String,
        dateFormatStyle: DateFormatter.Style = .medium
    ) {
        self.init()
        self.dateFormatStyle = dateFormatStyle
        
        translatesAutoresizingMaskIntoConstraints = false
        
        labelTextField = UILabel()
        labelTextField.text = label
        
        datePicker = UIDatePicker()
        datePicker.addTarget(self, action: #selector(datePickerDidValueChanged(sender:)), for: .valueChanged)
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.isUserInteractionEnabled = true
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(toolbarDoneClicked))
        toolBar.setItems([spacer, doneButton], animated: true)
        
        textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.delegate = self
        textField.placeholder = placeholder
        textField.inputAccessoryView = toolBar
        textField.inputView = datePicker
        
        let stack = UIStackView(arrangedSubviews: [labelTextField, textField])
        stack.spacing = 8
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    @objc
    private func toolbarDoneClicked() {
        textField.resignFirstResponder()
    }
    
    @objc
    private func datePickerDidValueChanged(sender: UIDatePicker) {
        let dateFormater = DateFormatter()
        dateFormater.dateStyle = dateFormatStyle
        textField.text = dateFormater.string(from: sender.date)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        didChange?(textField.text ?? "")
    }
    
}
