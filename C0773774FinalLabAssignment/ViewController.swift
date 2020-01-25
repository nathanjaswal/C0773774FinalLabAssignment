//
//  ViewController.swift
//  C0773774FinalLabAssignment
//
//  Created by Nitin on 24/01/20.
//  Copyright © 2020 Apple. All rights reserved.
// //

import UIKit
import CoreData

class ViewController: UIViewController {
    
    // MARK: - Properties
    let persistent = PersistenceManager.shared
    var tasksListOrignal: [Tasks]!
    var tasksList: [Tasks]!
    var task: Tasks?
    var checkIdBool = Bool()

    @IBOutlet var tableView: UITableView!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initViews()
    }
    
    // MARK: - Action
    @IBAction func addBtnClicked(_ sender: Any) {
        // navigate...
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        vc.editBool = false
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    // MARK: - Helper
    func addfirstTen() {
        
        for i in 1..<11 {
            let taskN = Tasks(context: persistent.context)

            taskN.productPrice = String(format: "%d", i*33)
            taskN.productDes = String(format: "description of product %d", i)
            taskN.productName = String(format: "Product %d", i)
            taskN.productId = String(format: "Id_%d", i)
            do{
                try persistent.context.save()

            } catch {
                print(error.localizedDescription)
            }
        }

        persistent.fetch(type: Tasks.self) { (tasks) in

            self.tasksListOrignal = tasks

            self.tasksList = tasks
            self.tableView.reloadData()
            
            
        }
        
        
    }
    
    func initViews() {
        //
        persistent.fetch(type: Tasks.self) { (tasks) in
            
            self.tasksListOrignal = tasks
            
            self.tasksList = tasks
            self.tableView.reloadData()
            
            for task in tasks {
                if(task.productId == "Id_1") {
                    self.checkIdBool = true
                }
            }
            
            if(self.checkIdBool == false){
                self.addfirstTen()
            }
            
            if(self.tasksList.count > 0 && Singelton.sharedObj.firstNav == false) {
                // navigate...
                Singelton.sharedObj.firstNav = true
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
                vc.editBool = true
                
                vc.task = self.tasksList[0]
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
    }
    
    private var cellClass: VCTableViewCell.Type {
        return VCTableViewCell.self
    }

}

extension ViewController: UISearchBarDelegate {
      // MARK: - UISearchBar
      func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
           searchBar.setShowsCancelButton(true, animated: true)
      }
      
      func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
      }
      
      func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
          searchBar.text = ""
          searchBar.resignFirstResponder()
          searchBar.endEditing(true)
    
          self.tasksList =  self.tasksListOrignal
          self.tableView.reloadData()
      }
      
      func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
          if searchBar.text != ""{
              var filtered: [Tasks]!
              //print(wishListArr)
              filtered = tasksListOrignal.filter({ (task) -> Bool in
                  
                  let tmpStr = task.productName
                  
                let range1 = tmpStr?.range(of: searchBar.text!)
                let range2 = tmpStr?.range(of: searchBar.text!.lowercased())
                let range3 = tmpStr?.range(of: searchBar.text!.uppercased())
              
                  let tmpStr1 = task.productDes
                                 
                  let range4 = tmpStr1?.range(of: searchBar.text!)
                  let range5 = tmpStr1?.range(of: searchBar.text!.lowercased())
                  let range6 = tmpStr1?.range(of: searchBar.text!.uppercased())
                  
                  return range1 != nil || range2 != nil || range3 != nil || range4 != nil || range5 != nil || range6 != nil

                  
              }) as [Tasks]
              
              if(filtered.count > 0){
                  self.tasksList = filtered
              }else{
                  self.tasksList = [Tasks]()
              }
              
              self.tableView.reloadData()
          }
          
          searchBar.resignFirstResponder()
         
      }
      
      func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
          
      }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasksList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: cellClass.reuseId, for: indexPath) as? VCTableViewCell)!
        cell.task = tasksList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellClass.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // navigate...
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        vc.editBool = true
        
        vc.task = tasksList[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
  
}



