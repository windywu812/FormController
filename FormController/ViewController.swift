//
//  ViewController.swift
//  FormController
//
//  Created by Windy on 18/07/21.
//

import UIKit

class ViewController: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Form Controller"
        
        (0..<5).forEach({
            let tf = FormTextField(label: "Label \($0)", placeholder: "Enter some text here")
            tf.didChange = { [weak self] value in
                print(value)
            }
            addForms(views: tf)
        })
        
        let picker = FormPicker(label: "Picker", placeholder: "Enter some text here")
        picker.addDataSource(data: ["1", "2", "3", "4"])
        picker.didChange = { [weak self] value in
            print(value)
        }
        addForms(views: picker)
    
        let datePicker = FormDatePicker(label: "Date Picker", placeholder: "Enter a date")
        datePicker.didChange = { [weak self] value in
            print(value)
        }
        addForms(views: datePicker)
    }
    
}
