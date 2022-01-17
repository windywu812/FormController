//
//  FormViewController.swift
//  FormController
//
//  Created by Windy on 17/01/22.
//

import UIKit

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
