//
//  AddFoodViewController.swift
//  CalorieTracker
//
//  Created by Jason Zheng on 5/12/20.
//  Copyright © 2020 Jason Zheng. All rights reserved.
//

import UIKit

class AddFoodViewController: UIViewController {
    
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var foodNameTextField: UITextField!
    
    @IBOutlet weak var caloriesTextField: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
    var pickedImage:UIImage?
    @IBAction func addFood(_ sender: Any) {
        guard let _food = foodNameTextField.text, let _calories = caloriesTextField.text, !(foodNameTextField.text?.isEmpty ?? false), !(caloriesTextField.text?.isEmpty ?? false), let _image = pickedImage else { return }
        guard let data = _image.pngData() else { return }
        viewModel.addFood(name: _food, calories: Int(_calories) ?? 0, data: data)
        self.navigationController?.popViewController(animated: true)
    }
    
    var viewModel:MyFoodViewModel = MyFoodViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        cardView.layer.cornerRadius = 5
        imageView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true)
            }
            else{
                print("Camera is not available")
            }
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
}

extension AddFoodViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imageView.image = image
        pickedImage = image
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
