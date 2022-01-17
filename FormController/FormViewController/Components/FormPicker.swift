//
//  FormPicker.swift
//  FormController
//
//  Created by Windy on 17/01/22.
//

import UIKit

class FormPicker: UIView {
    
    var didChange: ((String) -> ())?
    
    private var labelTextField: UILabel!
    private var textField: UITextField!
    private var picker: UIPickerView!
    private var toolBar: UIToolbar!
    private var data: [String] = []
    
    convenience init(
        label: String,
        placeholder: String
    ) {
        self.init()
        
        translatesAutoresizingMaskIntoConstraints = false
        
        labelTextField = UILabel()
        labelTextField.text = label
        
        picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(handleDoneButton(sender:)))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.setItems([flexible, doneButton], animated: true)
        
        textField = UITextField()
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.inputView = picker
        textField.inputAccessoryView = toolBar
        
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
    
    func addDataSource(data: [String]) {
        self.data = data
        picker.reloadAllComponents()
    }
    
    @objc private func handleDoneButton(sender: UIBarButtonItem) {
        textField.resignFirstResponder()
    }
    
}

extension FormPicker: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textField.text = data[row]
        didChange?(data[row])
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
