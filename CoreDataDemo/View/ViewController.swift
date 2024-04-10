//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by PTMACPRO005 on 09/04/24.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var userstable:UITableView!
    var users:[NSManagedObject] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.registerTableView()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func didTapCreateData(_ sender: Any) {
        if let createdUsers = createData() {
            users = createdUsers
            DispatchQueue.main.async {
                self.userstable.reloadData()
            }
        }
    }
    
    
    
    
    @IBAction func didTapRetriveData(_ sender: Any) {
        if let fetchResults = fetchData(){
            users = fetchResults
            DispatchQueue.main.async {
                self.userstable.reloadData()
            }
        }
    }
    
    
    func registerTableView(){
        self.userstable.register(UINib(nibName: "TableCell", bundle: .main), forCellReuseIdentifier: "TableCell")
        self.userstable.delegate = self
        self.userstable.dataSource = self
    }
    
    func createData()-> [NSManagedObject]?{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return nil}
        let managedContext  = appDelegate.persistentContainer.viewContext
        let userEntity  = NSEntityDescription.entity(forEntityName: "User", in: managedContext)!
        
         var createdUsers: [NSManagedObject] = []
        for _ in 1...5{
            let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
            let randomNumber = Int.random(in: 0...99)
            user.setValue("SuryaPavan\(randomNumber)", forKey: "name")
            createdUsers.append(user)
        }
        do{
            try managedContext.save()
            users.append(contentsOf: createdUsers)
            return users
        }catch let error as NSError{
            print("Could not save. \(error), \(error.localizedDescription)")
            return nil
        }
    }
    
    func fetchData() -> [NSManagedObject]?{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return nil}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        do {
            let result = try managedContext.fetch(fetchRequest)
            return result as? [NSManagedObject]
        }catch let err as NSError {
            print(err.localizedDescription)
            return nil
        }
    }
}


extension ViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as? TableCell else{return UITableViewCell()}
        guard indexPath.row < users.count else {
            return UITableViewCell()
        }
        let user = users[indexPath.row]
        cell.configure(with: user, at: indexPath)
        
        cell.onUpdate = { [weak self] in
            self?.userstable.reloadData()
               }
        cell.onDelete = { [weak self] in
            self?.users.remove(at: indexPath.row)
            self?.userstable.reloadData()
        }
        return cell
    }
}
