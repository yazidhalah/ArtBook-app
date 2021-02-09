//
//  CreateVC.swift
//  ArtBook 2
//
//  Created by Maverick on 1/16/21.
//  Copyright © 2020 Maverick. All rights reserved.
//

import UIKit
import CoreData

class CreateVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate {

    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var YearTxt: UITextField!
    @IBOutlet weak var NameTxt: UITextField!
    @IBOutlet weak var ArtisttTxt: UITextField!
    
    var SelectedName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.YearTxt.delegate = self
        self.NameTxt.delegate = self
        self.ArtisttTxt.delegate = self
        
        if SelectedName != "" {
            
            Predicate()
            
        }else {
            
            ImageView.image = UIImage(named: "59060c8b0cbeef0acff9a65b.png")
            NameTxt.text = ""
            YearTxt.text = ""
            ArtisttTxt.text = ""
        }
        
        ImageView.isUserInteractionEnabled = true
        let ImageViewReco = UITapGestureRecognizer(target: self, action: #selector (CreateVC.ImagePicker))
            ImageView.addGestureRecognizer(ImageViewReco)
    }
    @objc func ImagePicker() {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        ImageView.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
    }

    @IBAction func SaveBtn(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newArt = NSEntityDescription.insertNewObject(forEntityName: "Paintings", into: context)
        
        newArt.setValue(NameTxt.text, forKey: "name")
        newArt.setValue(ArtisttTxt.text, forKey: "artist")
        
        if let year = Int(YearTxt.text!){
            
            newArt.setValue(year, forKey: "year")
        }
        
        let image = ImageView.image?.jpegData(compressionQuality: 0.5)
        newArt.setValue(image, forKey: "image")
        
        
        do{
            try context.save()
            print("awesome")
        }catch{
            print("Error!!")
        }
        
    
        NotificationCenter.default.post(name: NSNotification.Name("Paint"), object: nil)
        self.navigationController?.popViewController(animated: true)
    }
    @objc func Predicate(){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Paintings")
        
        fetchRequest.predicate = NSPredicate(format: "name = %@", self.SelectedName)
        fetchRequest.returnsObjectsAsFaults = false
        
        do{
            
            let Results = try context.fetch(fetchRequest)
            
            if Results.count > 0 {
                
                for result in Results as! [NSManagedObject]{
                    
                    if let name = result.value(forKey: "name") as? String {
                        self.NameTxt.text = name
                    }
                    if let artist = result.value(forKey: "artist") as? String {
                        self.ArtisttTxt.text = artist
                    }
                    if let year = result.value(forKey: "year") as? Int {
                        self.YearTxt.text = String(year)
                    }
                    if let image = result.value(forKey: "image") as? Data{
                        let newImage = UIImage(data: image)
                        self.ImageView.image = newImage
                    }
                    print(0123456)
                }
            }
            
        }catch{
            print("Errorrr!!")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        YearTxt.resignFirstResponder()
        NameTxt.resignFirstResponder()
        ArtisttTxt.resignFirstResponder()
        return (true)
    }

}
