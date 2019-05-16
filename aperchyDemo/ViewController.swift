//
//  ViewController.swift
//  aperchyDemo
//
//  Created by saad on 5/15/19.
//  Copyright © 2019 saad. All rights reserved.
//

import UIKit
import Firebase

//appergy
class ViewController: UIViewController {
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var companyName: UITextField!
    @IBOutlet weak var myImageView: UIImageView!
    
    var docRef :  DocumentReference!
    
    let imagePicker  = UIImagePickerController()
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        FirebaseApp.configure()
        docRef = Firestore.firestore().document("Users/newusers")
    }
    
    @IBAction func imageupload(_ sender: Any) {
        self.setupImagePicker()

    }

    
    
    @IBAction func saveTapped(_ sender: Any) {
        print(nameField.text , companyName.text)
        guard let name = nameField.text  , !name.isEmpty else {return}
        
        guard let company = companyName.text , !company.isEmpty else {return}
        
        self.uploadImage(self.myImageView.image!){url in
            print("URLLLLLLLLLLL\(url)")
            self.saveData(name: name, companyname: company, imageUrl: url!){success in
                
                print("Upload Done")
                
            }
        }

    }
    
}

extension ViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func setupImagePicker ()  {
        
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.delegate = self
            imagePicker.isEditing = true
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image  = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
         myImageView.image = image
        self.dismiss(animated: true, completion: nil)
    }
}


extension ViewController{
    
    func uploadImage(_ image:UIImage , completion : @escaping ((_ url : URL?)->()))  {
        let storageRef = Storage.storage().reference().child("image1.png")
        let imgData = myImageView.image?.pngData()
        let metaData = StorageMetadata()
        metaData.contentType = "image/png"
        storageRef.putData(imgData!, metadata: metaData) { (metadata,error) in
            if error == nil {
                print("success")
                storageRef.downloadURL(completion:  {(url,error) in
                    completion(url!)
                })
            }
            else{
                print("Error Agaya Jani \(error)")
                completion(nil)
            }
        }
    }
    
    func saveData (name:String , companyname:String , imageUrl:URL , completion : @escaping ((_ url : URL?)->())) {
        
        let data :  [String : Any] = ["name" : name , "companyName":companyname , "imageUrl":imageUrl.absoluteString]
        
        docRef.setData(data){
            (error) in if let error = error {
                print("error:\(error.localizedDescription)")
            }else{
                print("Success")
            }
        }
        
    }
}

