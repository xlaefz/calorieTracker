
import UIKit
import BLTNBoard


class TextFieldBulletinPage: FeedbackPageBLTNItem {

    @objc public var textField: UITextField!

    @objc public var textField2: UITextField!

    @objc public  var actionButton3: BLTNHighlightButtonWrapper!
    
    @objc public var textInputHandler: ((BLTNActionItem, String?) -> Void)? = nil

    override func makeViewsUnderDescription(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
        textField = interfaceBuilder.makeTextField(placeholder: "Name", returnKey: .done, delegate: self)
        textField2 = interfaceBuilder.makeTextField(placeholder: "Calories", returnKey: .done, delegate: self)
        textField2.keyboardType = .numberPad
        
        actionButton3 = interfaceBuilder.makeActionButton(title: "Yeet")
        actionButton3.button.backgroundColor = .yellow
        actionButton3.button.addTarget(self, action: #selector(printPoop), for: .touchUpInside)
        return [textField, textField2, actionButton3]
    }
    
    @objc func printPoop(){
        print("POOP")
    }

    override func tearDown() {
        super.tearDown()
        textField?.delegate = nil
    }

    override func actionButtonTapped(sender: UIButton) {
        textField.resignFirstResponder()
        super.actionButtonTapped(sender: sender)
        //set image
        print("Set image")
        self.image = UIImage(named: "check_mark")
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
