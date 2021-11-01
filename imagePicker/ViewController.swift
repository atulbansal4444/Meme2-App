//
//  ViewController.swift
//  imagePicker
//
//  Created by Atul Bansal on 08/03/18.
//  Copyright © 2018 Atul Bansal. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate {
    @IBOutlet weak var imagePickerVIew: UIImageView!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeTextField(textField: topTextField, defaultText: "TOP")
        customizeTextField(textField: bottomTextField, defaultText: "BOTTOM")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        imagePickerVIew.contentMode = .scaleAspectFit   //set image size
      
        shareButton.isEnabled = false    //share disabled as image is not selected
        subscribeToKeyboardNotification()
        if imagePickerVIew.image != nil { //checking for imageViewer then apply share Action else not
            shareButton.isEnabled = true
        }
        else {
            shareButton.isEnabled = false
        }
    }
    
    func customizeTextField(textField: UITextField, defaultText: String) {
        textField.defaultTextAttributes = memeTextAttribute
        textField.text = defaultText
        textField.textAlignment = .center
        textField.delegate = self;
    }
    
    let memeTextAttribute:[String : Any] = [  //constaint for fonts settings
        NSAttributedStringKey.strokeColor.rawValue : UIColor.black,
        NSAttributedStringKey.foregroundColor.rawValue : UIColor.white, //colour
        NSAttributedStringKey.font.rawValue : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!, //font style, size
        NSAttributedStringKey.strokeWidth.rawValue : -4.0,
        ]
   
        override var prefersStatusBarHidden: Bool {
            return true
        }
    
        func subscribeToKeyboardNotification() {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow(_:)), name: .UIKeyboardWillShow, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide(_:)), name: .UIKeyboardWillHide, object: nil)
        }
    
        func unsubscribeFromKeyboardNotification() {
            NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
            NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
        }
    
    @objc  func keyboardShow(_ notification:Notification) {
        if bottomTextField.isFirstResponder {
            self.view.frame.origin.y =  getKeyboardHeight(notification) * -1
        }
    }
    
    @objc  func keyboardHide(_ notification:Notification) {
        if bottomTextField.isFirstResponder {
            self.view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == topTextField {  //empty top field
            textField.text = nil
        }
        else if textField == bottomTextField { //empty bottom field
            textField.text = nil
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func cancelFunc(_ sender: Any) {
        imagePickerVIew.image=nil
        topTextField.text="TOP"
        bottomTextField.text="BOTTOM"
        shareButton.isEnabled = false
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pickImageFromAlbum(_ sender: Any) {
        pickAnImage(from: .photoLibrary)
    } // albums
    
    @IBAction func pickImageFromCamera(_ sender: Any) {
       pickAnImage(from: .camera) 
    }
    
    func pickAnImage(from source: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.sourceType = source
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            imagePickerVIew.image = image
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func shareAction(_ sender: Any) {
        let memedImage = generateMemedImage()
        let shareActivityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        shareActivityViewController.completionWithItemsHandler = { activity, completed, items, error in
            
            if completed {
                self.save(image: memedImage)
                self.dismiss(animated: true, completion: nil)
            }
        }
        present(shareActivityViewController, animated: true, completion: nil)
    }
    
    func hideNavToolBar(choice: Bool) {
        toolBar.isHidden = choice
        navBar.isHidden = choice
    }
    
    func generateMemedImage() -> UIImage {
        
        hideNavToolBar(choice: true)
        
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        hideNavToolBar(choice: false)
        
        return memedImage
    }
    
        func save(image: UIImage) {
            let meme =  Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerVIew.image!, memedImage: generateMemedImage())
            
            let object = UIApplication.shared.delegate
            let appDelegate = object as! AppDelegate
            appDelegate.memes.append(meme)
            
        }
    }


