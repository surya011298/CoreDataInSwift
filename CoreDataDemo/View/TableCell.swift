//
//  TableCell.swift
//  CoreDataDemo
//
//  Created by PTMACPRO005 on 09/04/24.
//

import UIKit
import CoreData

class TableCell: UITableViewCell,UITextFieldDelegate {
    
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    
    var user: NSManagedObject?
    var onUpdate: (()->Void)?
    var onDelete: (()->Void)?
    //var seletedRow = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        nameTF.delegate = self
        nameTF.isUserInteractionEnabled = false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)  {
        updateData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTF.resignFirstResponder()
        return true
    }
    
    
    
    @IBAction func didTapUpdate(_ sender: UIButton) {
        nameTF.isUserInteractionEnabled = true
        nameTF.becomeFirstResponder()
        
        
    }
    
    
    func configure(with user: NSManagedObject, at indexPath: IndexPath) {
         self.user = user
         nameTF.text = user.value(forKey: "name") as? String
         nameTF.isUserInteractionEnabled = false
     }
    
    
    func updateData(){
        
        guard let user = user, let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        
        user.setValue(self.nameTF.text, forKey: "name")
        do {
            try managedContext.save()
            nameTF.isUserInteractionEnabled = false
            onUpdate?()
        } catch {
            print(error)
        }
        //let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "User")
        //        do {
        //            let users = try managedContext.fetch(fetchRequest)
        //            let userToUpdate = users[seletedRow] as! NSManagedObject
        //
        //            userToUpdate.setValue(self.nameTF.text, forKey: "name")
        //            try managedContext.save()
        //
        //            DispatchQueue.main.async {
        //                self.nameTF.isUserInteractionEnabled = false
        //                self.onUpdate?()
        //            }
        //
        //
        //        } catch {
        //            print(error)
        //        }
    }
    
    @IBAction func didTapDelete(_ sender: UIButton) {
        
        guard let user = user, let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        
        managedContext.delete(user)
        do {
            try managedContext.save()
            onDelete?()
        } catch {
            print(error)
        }
        // let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "User")
        //        do {
        //            let users = try managedContext.fetch(fetchRequest)
        //
        //            let userToDelete = users[seletedRow] as! NSManagedObject
        //            managedContext.delete(userToDelete)
        //            do{
        //                try managedContext.save()
        //                DispatchQueue.main.async {
        //                    self.onDelete?()
        //                }
        //            }catch{
        //                print(error)
        //            }
        //        }catch {
        //            print(error)
        //        }
        
    }
    
    
    
}
