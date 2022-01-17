//
//  FormTextField.swift
//  FormController
//
//  Created by Windy on 17/01/22.
//

import UIKit

class FormTextField: UIView, UITextFieldDelegate {
    
    var didChange: ((String) -> ())?
    
    private var labelTextField: UILabel!
    private var textField: UITextField!
    
    convenience init(label: String, placeholder: String) {
        self.init()
        
        translatesAutoresizingMaskIntoConstraints = false
        
        labelTextField = UILabel()
        labelTextField.text = label
        
        textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.delegate = self
        textField.placeholder = placeholder
        
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        didChange?(textField.text ?? "")
    }
    
}
