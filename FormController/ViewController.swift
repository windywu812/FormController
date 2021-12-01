//
//  ViewController.swift
//  FormController
//
//  Created by Windy on 18/07/21.
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
        placeholder: String)
    {
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

class FormDatePicker: UIView {
    
    var didChange: ((String) -> ())?
    
    private var labelTextField: UILabel!
    private var textField: UIDatePicker!
    
    convenience init(
        label: String,
        datePickerStyle: UIDatePickerStyle = .automatic)
    {
        self.init()
        
        translatesAutoresizingMaskIntoConstraints = false
        
        labelTextField = UILabel()
        labelTextField.text = label
        
        textField = UIDatePicker()
        textField.preferredDatePickerStyle = datePickerStyle
        
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
    
}

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

class ViewController: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Form Controller"
        
        (0..<10).forEach { i in
            let tf = FormTextField(label: "Label \(i)", placeholder: "Enter some text here")
            if i == 5 {
                tf.heightAnchor.constraint(equalToConstant: 250).isActive = true
            }
            addForms(views: tf)
        }
        
        let picker = FormPicker(label: "Picker", placeholder: "Enter some text here")
        picker.addDataSource(data: ["1", "2", "3", "4"])
        addForms(views: picker)
    
        let datePicker = FormDatePicker(label: "Date Picker" )
        addForms(views: datePicker)
    }
    
}

class FormViewController: UIViewController {

    var verticalPadding: CGFloat = 16
    var horizontalPadding: CGFloat = 16
    var marginTopKeyboard: CGFloat = 16
    
    private var scrollViewStack: UIStackView!
    private var scrollView: UIScrollView!
    private var scrollViewBottomConstraint: NSLayoutConstraint!

    func addForms(views: UIView...) {
        views.forEach { view in
            scrollViewStack.addArrangedSubview(view)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScrollViewStack()
        setupKeyboardObserver()
    }
    
    private func setupScrollViewStack() {
        
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        scrollViewBottomConstraint = scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        scrollViewBottomConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
        
        scrollViewStack = UIStackView()
        scrollViewStack.spacing = 16
        scrollViewStack.axis = .vertical
        scrollViewStack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(scrollViewStack)
        
        NSLayoutConstraint.activate([
            scrollViewStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: horizontalPadding),
            scrollViewStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -horizontalPadding),
            scrollViewStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: verticalPadding),
            scrollViewStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -verticalPadding)
        ])
    }
    
    override func viewDidLayoutSubviews() {
        scrollViewStack.widthAnchor.constraint(equalToConstant: scrollView.bounds.width - 2 * horizontalPadding).isActive = true
    }
    
    private func setupKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification: )), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification: )), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

// MARK: Handling Keyboard and View's Frame
extension FormViewController {
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        scrollViewBottomConstraint.constant = -keyboardSize.height - marginTopKeyboard
        view.layoutIfNeeded()
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        scrollViewBottomConstraint.constant = 0
        view.layoutIfNeeded()
    }

}

import SwiftUI

struct UIKit: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return ViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        UIKit()
    }
}

