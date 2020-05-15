
import UIKit
import BLTNBoard

class TextFieldBulletinPage: FeedbackPageBLTNItem {
    
    @objc public var foodNameTextField: UITextField!
    
    @objc public var caloriesTextField: UITextField!
    @objc public  var cameraButton: BLTNHighlightButtonWrapper!
    @objc public  var photosButton: BLTNHighlightButtonWrapper!
    @objc public var textInputHandler: ((BLTNActionItem, String?) -> Void)? = nil
    
    var pickedImage:UIImage?
    weak var delegate:MyFoodViewController! //TODO: SHOULD USE DELEGATION
    var viewModel:MyFoodViewModel = MyFoodViewModel()
    var selectedImage:UIImageView!
    
    var prevNameText:String?
    var prevCaloriesText:String?

    
    func makeHorizontalGroupStack(spacing: CGFloat = 10) -> UIStackView {
        
        let buttonsStack = UIStackView()
        buttonsStack.axis = .horizontal
        buttonsStack.alignment = .fill
        buttonsStack.distribution = .fillEqually
        buttonsStack.spacing = spacing
        
        return buttonsStack
        
    }
    
    override func makeViewsUnderDescription(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
        foodNameTextField = interfaceBuilder.makeTextField(placeholder: "Name", returnKey: .done, delegate: self)
        caloriesTextField = interfaceBuilder.makeTextField(placeholder: "Calories", returnKey: .done, delegate: self)
        caloriesTextField.keyboardType = .numberPad
        
        let groupStack = makeHorizontalGroupStack()
        photosButton = interfaceBuilder.makeActionButton(title: "Camera")
        photosButton.button.addTarget(self, action: #selector(useCamera), for: .touchUpInside)
        cameraButton = interfaceBuilder.makeActionButton(title: "Photos")
        cameraButton.button.addTarget(self, action: #selector(usePhotoPicker), for: .touchUpInside)
        selectedImage = UIImageView(frame: CGRect(x: 100, y: 150, width: 75, height: 75)); // set as you want
        selectedImage.layer.cornerRadius = 8
        let image = UIImage(named: "icons8-kawaii-ice-cream");
        selectedImage.image = image
        selectedImage.contentMode = .scaleAspectFit
        
        groupStack.addArrangedSubview(photosButton)
        groupStack.addArrangedSubview(cameraButton)
        groupStack.addArrangedSubview(selectedImage)
        return [foodNameTextField, caloriesTextField, groupStack]
    }
    
    @objc func useCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let imagePickerController = UIImagePickerController()
            
            imagePickerController.sourceType = .camera
            self.delegate.present(imagePickerController, animated: true)
        }
        else{
            print("Camera is not available")
        }
    }
    
    func saveText(){
        prevNameText = foodNameTextField.text
        prevCaloriesText = caloriesTextField.text
    }
    
    
    @objc func usePhotoPicker(){
        saveText()
        delegate.bulletinManager.dismissBulletin()
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        self.delegate.present(imagePickerController, animated: true)
        
    }
    
    override func tearDown() {
        super.tearDown()
        foodNameTextField?.delegate = nil
    }
    
    override func actionButtonTapped(sender: UIButton) {
        foodNameTextField.resignFirstResponder()
        super.actionButtonTapped(sender: sender)
        print("actionButton")
    }
    
}

// MARK: - UITextFieldDelegate

extension TextFieldBulletinPage: UITextFieldDelegate {
    
    @objc open func isInputValid(text: String?) -> Bool {
        if text == nil || text!.isEmpty {
            return false
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if isInputValid(text: textField.text) {
            textInputHandler?(self, textField.text)
        } else {
            descriptionLabel!.textColor = .red
            descriptionLabel!.text = "You must enter some text to continue."
            textField.backgroundColor = UIColor.red.withAlphaComponent(0.3)
        }
    }
    
}



extension TextFieldBulletinPage:UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        picker.dismiss(animated: true, completion: nil)
        delegate.bulletinManager.showBulletin(above: delegate)
        delegate.bulletinManager.popItem()
        delegate.bulletinManager.push(item: self)
        selectedImage.image = image
        self.pickedImage = image
        self.foodNameTextField.text = prevNameText
        self.caloriesTextField.text = prevCaloriesText
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        delegate.bulletinManager.showBulletin(above: delegate, animated: true, completion: nil)
        
    }
}
