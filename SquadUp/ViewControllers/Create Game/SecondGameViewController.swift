//
//  SecondGameViewController.swift
//  SquadUp-v4
//
//  Created by Tommy Alpert on 11/5/20.
//

import UIKit

class SecondGameViewController: UIViewController {
    
    // MARK: - Outlets and Variables
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var textView: UITextView!
    
    var sport : String = ""
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeUI()
        setUpTextView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if #available(iOS 13.0, *) {
            navigationController?.navigationBar.setNeedsLayout()
        }
        setUpNavBar()
    }
    
    // MARK: - Actions
    
    @objc func cancelGame() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        
        let nextVC = ThirdGameViewController()
        self.navigationController?.pushViewController(nextVC, animated: true)
        nextVC.sport = sport
        nextVC.date = datePicker.date
        
        let descriptionHasText = textView.hasText && textView.text != "" && textView.text != "Describe your event to others..."
        nextVC.eventDescription = descriptionHasText ? textView.text : nil
        
        nextVC.delegate = GameMapViewController()
    }
    
    // MARK: - Helpers
    
    func setUpNavBar() {
        navigationController?.navigationBar.topItem?.title = "Select Time"
        navigationController?.navigationBar.topItem?.prompt = "2 of 3"
        
        // Right cancel button
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelGame))
        let textAttribute2 : [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white, .font: UIFont(name: "HelveticaNeue-Medium", size: 13)!, .underlineStyle: NSUnderlineStyle.single.rawValue ]
        let textAttribute3 : [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.lightGray, .font: UIFont(name: "HelveticaNeue-Medium", size: 13)!, .underlineStyle: NSUnderlineStyle.single.rawValue ]
        navigationController?.navigationBar.topItem?.rightBarButtonItem?.setTitleTextAttributes(textAttribute2, for: .normal)
        navigationController?.navigationBar.topItem?.rightBarButtonItem?.setTitleTextAttributes(textAttribute3, for: .selected)
    }
    
    func customizeUI() {
        
        nextButton.layer.borderWidth = 3
        nextButton.layer.borderColor = UIColor.black.cgColor
        nextButton.layer.cornerRadius = 10
        nextButton.backgroundColor = UIColor.green.darker(by: 5)
    }
    
    func setUpTextView() {
        
        textView.delegate = self
        textView.textColor = .darkGray
        textView.text = "Describe your event to others..."
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.darkGray.cgColor
        textView.autocapitalizationType = .sentences
        textView.isScrollEnabled = false
    }
}

// MARK: - Text View
extension SecondGameViewController : UITextViewDelegate {
    
    func textViewDidBeginEditing (_ textView: UITextView) {
        if textView.textColor == .darkGray && textView.isFirstResponder {
            textView.text = nil
            textView.textColor = .white
        }
    }
    func textViewDidEndEditing (_ textView: UITextView) {
        if textView.text.isEmpty || textView.text == "" {
            textView.textColor = .lightGray
            textView.text = "Type your thoughts here..."
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if(text == "\n") {
                textView.resignFirstResponder()
                return false
            }
            return true
        }

        /* Older versions of Swift */
        func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
            if(text == "\n") {
                textView.resignFirstResponder()
                return false
            }
            return true
        }
    
}

