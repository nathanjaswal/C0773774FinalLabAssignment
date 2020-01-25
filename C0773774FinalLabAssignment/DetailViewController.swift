//
//  DetailViewController.swift
//  C0773774Assignment2
//
//  Created by Nitin on 19/01/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {
    
    // MARK: - Properties
    let persistent = PersistenceManager.shared
    var editBool = Bool()
    var task: Tasks?
    var checkIdBool = Bool()

    
    @IBOutlet var idTextField: UITextField!
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var priceTextField: UITextField!
    @IBOutlet var descTextView: UITextView!
    
    @IBOutlet var saveBtn: UIButton!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViews()
    }
    
    // MARK: - Action
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveBtnClicked(_ sender: Any) {
        //
        if checkValidation() {
           
            saveToCoreData()
            
        }else{
            self.showAlert(title: "C0773774", message: "Not proper data!")
        }
    }
    
    // MARK: - Helper
    func showCustAlert(msg: String) {
        let alert = UIAlertController(title: "C0773774", message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            action in
            
            //
            self.navigationController?.popViewController(animated: true)
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func initViews() {
       
        if(editBool == true){
            
            saveBtn.isHidden = true
            idTextField.text = task?.productId ?? ""
            priceTextField.text = task?.productPrice ?? ""
            titleTextField.text = task?.productName ?? ""
            descTextView.textColor = UIColor.black
            descTextView.text = task?.productDes ?? ""
            
        }else{
            saveBtn.isHidden = false
            descTextView.text = "Tap here to add your description..."
            descTextView.textColor = UIColor.darkGray
           
        }
    }
    
    func currentDate() -> String{
        let date = Date()
        // date
        let dformatter = DateFormatter()
        dformatter.dateFormat = "d MMM"
        let stDate = dformatter.string(from: date)
        
        // day
        let eformatter = DateFormatter()
        eformatter.dateFormat = "EEEE"
        let stDay = eformatter.string(from: date)
        
        return String(format: "%@, %@", stDay, stDate)
        
    }
    
    func checkValidation() -> Bool {
        if(idTextField.text != "" || descTextView.text != "" || descTextView.text != "Tap here to add your description..."  || titleTextField.text != "" || priceTextField.text != "" || Int(priceTextField.text ?? "0")! > 0){
            checkId()
            if checkIdBool {
            
                return false
            }else{
                return true
            }
            return true
        }else{
            return false
        }
    }
    
    func checkId() {
        persistent.fetch(type: Tasks.self) { (tasks) in
            for task in tasks {
                if(self.idTextField.text == task.productId) {
                    self.checkIdBool = true
                }
            }
            
        }
    }
    
    func saveToCoreData() {
        //
        let taskN = Tasks(context: persistent.context)

        taskN.productPrice = priceTextField.text
        taskN.productDes = descTextView.text
        taskN.productName = titleTextField.text
        taskN.productId = idTextField.text
        do{
            try persistent.context.save()
            
            showCustAlert(msg: "Data Saved to List.")
        } catch {
            print(error.localizedDescription)
        }
        
    }

    
}

// MARK: - UITextViewDelegate
extension DetailViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.darkGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if (textView.text == ""){
            textView.text = "Tap here to add your description..."
            textView.textColor = UIColor.darkGray
        }
    }
}
