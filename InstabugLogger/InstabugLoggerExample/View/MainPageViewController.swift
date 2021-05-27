//
//  ViewController.swift
//  InstabugLoggerExample
//
//  Created by Mohamed Khalid on 26/05/2021.
//

import UIKit
import InstabugLogger

class MainPageViewController: UIViewController {
    // Properties
    //
    let instabugLogger = InstabugLogger.shared
    
    // IBOutlets
    //
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var levelTextField: UITextField!
    
    // Methods
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        messageTextField.delegate = self
        levelTextField.delegate = self
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // IBActions
    //
    @IBAction func addButtonPressed(_ sender: Any) {
        if (levelTextField.text == "") {
            let alert = UIAlertController(title: "Error", message: "Please insert level number", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            return
        }
        let message = messageTextField.text!
        let level = Int64(levelTextField.text!)!
        instabugLogger.log(level, message: message)
        messageTextField.text = ""
        levelTextField.text = ""
    }
    @IBAction func printAllButtonPressed(_ sender: Any) {
        //performSegue(withIdentifier: "GoToLogs", sender: self)
    }
}

// MARK:- UITectField delegate
//
extension MainPageViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension MainPageViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! LogsViewController
        vc.logs = instabugLogger.fetchAllLogs()
    }
}
