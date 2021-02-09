//
//  ViewController.swift
//  ArtBook 2
//
//  Created by Maverick on 1/15/21.
//  Copyright © 2020 Maverick. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var TableView: UITableView!
    
    var nameArray = [String]()
    var artistArray = [String]()
    var yearArray = [Int]()
    var imageArray = [UIImage]()
    
    var ChosenPaintings = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // Table Setup
        TableView.dataSource = self
        TableView.delegate = self
        
        RetriveData()
        
    
    }
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector (ViewController.RetriveData), name: NSNotification.Name(rawValue: "Paint"), object: nil)
    }
    
    @objc func RetriveData(){
        
        nameArray.removeAll(keepingCapacity: true)
        artistArray.removeAll(keepingCapacity: true)
        yearArray.removeAll()
        imageArray.removeAll()
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Paintings")
        fetchRequest.returnsObjectsAsFaults = false
        
        do{
            let Results = try context.fetch(fetchRequest)
            
            if Results.count > 0 {
                
                for result in (Results as? [NSManagedObject])!{
                    
                    if let name = result.value(forKey: "name") as? String{
                        self.nameArray.append(name)
                    }
                    if let artist = result.value(forKey: "artist") as? String{
                    self.artistArray.append(artist)
                }
                    if let year = result.value(forKey: "year") as? Int {
                        self.yearArray.append(year)
                    }
                    if let imageData = result.value(forKey: "image") as? Data{
                    let newdata = UIImage(data: imageData)
                        self.imageArray.append(newdata!)
                }
                    
                    self.TableView.reloadData()
            }
            }
            
            
            print(0012)
        }catch{
            print("error")
        }
        
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = nameArray[indexPath.row]
        return cell
    }
    
    @IBAction func AddBtn(_ sender: Any) {
        
        ChosenPaintings = ""
        performSegue(withIdentifier: "Go2Create", sender: nil)
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        ChosenPaintings = nameArray[indexPath.row]
        
        performSegue(withIdentifier: "Go2Create", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Go2Create" {
            
            let VCdes = segue.destination as! CreateVC
            VCdes.SelectedName = ChosenPaintings
            
        }
        
    }
    
}

