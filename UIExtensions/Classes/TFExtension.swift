//
//  TFExtension.swift
//  UIExtensions
//
//  Created by Hardik Bangoria on 06/03/18.
//

import Foundation

public enum UITextFieldSide : Int {
    case rightSide
    case leftSide
    case both
}

extension UITextField {
    
    public func registerForKeyboardNotifications() {
        let selector = #selector(keyboardShown(notification:))
        let name = NSNotification.Name.UIKeyboardWillShow
        let notifCenter = NotificationCenter.default
        
        notifCenter.addObserver(self, selector: selector, name: name, object: nil)
    }
    
    @objc private func keyboardShown(notification: NSNotification) {
        let info  = notification.userInfo!
        let value: CGRect = info[UIKeyboardFrameEndUserInfoKey]! as! CGRect
        optionsDelegate.updateView(inputViewHeight: value.size.height)
    }
    
    /**
     'Void' type method for setting padding for plain 'UITextField'.
     
     - parameters:
     - padding: padding width as much you want to set
     
     - side: At which side you want to set padding. Default is .both.
     */
    public func sidePaddings(_ padding: CGFloat, at side: UITextFieldSide? = .both) -> Void {
        
        let frame = CGRect(x: 0.0, y: 0.0, width: padding, height: self.frame.size.height)
        let sideView = UIView.init(frame: frame)
        
        switch side! {
            
        case .leftSide:
            self.textFieldLeftView(sideView)
            break
            
        case .rightSide:
            self.textFieldRightView(sideView)
            break
            
        default:
            self.textFieldLeftView(sideView)
            self.textFieldRightView(sideView)
            break
        }
    }
    
    private func textFieldLeftView (_ sideView: UIView) -> Void {
        self.leftViewMode = .always
        self.leftView = sideView
    }
    
    private func textFieldRightView (_ sideView: UIView) -> Void {
        self.rightViewMode = .always
        self.rightView = sideView
    }
    
    /**
     
     For to set 'Left' or 'Right' side icons to any type of 'UITextField'
     
     - parameters:
     - iconImg: pass 'png','jpg' or 'jpeg' image or '.xcassets'
     - imgSize: No matter which size of image you're using. This will resize view to square as per applied size.
     - side: At which side you want to set padding. Default is .both.
     - alpha: transperancy of image. Default is 1.0(No transparent).
     */
    public func sideIcon(_ iconImg: UIImage, size imgSize: CGFloat, at side: UITextFieldSide, alpha: CGFloat? = 1.0) -> Void {
        
        let fieldHeight = self.frame.size.height
        let sideViewFrame = CGRect(x: 0.0, y: 0.0, width: imgSize + 10.0, height: fieldHeight)
        let sideView = UIView(frame: sideViewFrame)
        
        var imgFrame = CGRect.init()
        imgFrame.size.width = imgSize
        imgFrame.size.height = imgSize
        imgFrame.origin.x = 5.0 //(viewSize - imgSize) / 2.0
        imgFrame.origin.y = (fieldHeight - imgSize) / 2.0
        
        let imgSideView = UIImageView(frame: imgFrame)
        imgSideView.image = iconImg
        imgSideView.alpha = alpha!
        sideView.addSubview(imgSideView)
        
        switch side {
            
        case .leftSide:
            self.textFieldLeftView(sideView)
            break
            
        case .rightSide:
            self.textFieldRightView(sideView)
            break
            
        case .both:
            break
        }
    }
    
    /**
     
     This is textfield method to set UIPickerView as 'inputView'.
     
     - parameters:
     - options[Any]: You can pass array of 'String' or 'NSDictionary' as arguments
     - key: If 'NSDIctionary' passed as argumnet you have to pass key to read value for row title.
     */
    public func pickerWithOptions (_ options: [Any], key: String? = nil) -> Void {
        
        self.fieldOptions = options as NSArray
        if key != nil {
            self.KeyForValue = key!
        }
        
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        
        self.inputView = picker
        self.addActionBarToInputView()
    }
    
    /**
     
     This is textfield method to set UIPickerView as 'inputView'.
     
     - parameters:
     - mode[UIDatePickerMode]: You can pass array of 'String' or 'NSDictionary' as arguments
     - dateFormat: If 'NSDIctionary' passed as argumnet you have to pass key to read value for row title.
     */
    public func datePickerWithMode(_ mode: UIDatePickerMode, dateFormat: String? = "dd,MMM-yyyy") -> Void {
        
        self.dpFormatter = dateFormat!
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = mode
        datePicker.addTarget(self, action: #selector(datePickerSelected(_:)), for: .valueChanged)
        self.inputView = datePicker
        self.addActionBarToInputView()
    }
    
    // Datpicker selection event
    @objc private func datePickerSelected(_ sender: UIDatePicker) -> Void {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = self.dpFormatter
        
        self.text = dateFormatter.string(from: sender.date)
    }
    
    /**
     
     This is textfield method to set action bar on textinputview.
     
     */
    public func addActionBarToInputView() -> Void {
        
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: 44.0))
        let bbDone = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.donePressed(button:)))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([flexibleSpace, bbDone], animated: true)
        toolBar.tintColor = UIColor.orange
        self.inputAccessoryView = toolBar
    }
    
    @objc private func donePressed(button:UIBarButtonItem) -> Void {
        self.resignFirstResponder()
    }
    
    public func setOptionsDelegate (optionsDelegate: UITextFieldOptionsDelegate) {
        self.optionsDelegate = optionsDelegate;
    }
}

private struct AssociatedKeys {
    static var fOptions: UInt8 = 0
    static var keyForVal: UInt8 = 1
    static var delegate: UInt8 = 2
    static var dateFormat: UInt8 = 3
}

// MARK: - ---> Extension Stored Properties
// ========================================
extension UITextField {
    
    // MARK: - Delegate for picker selection
    var optionsDelegate: UITextFieldOptionsDelegate {
        get {
            let value = objc_getAssociatedObject(self, &AssociatedKeys.delegate)
            return value as! UITextFieldOptionsDelegate
        }
        set(newValue) {
            let associationPolicy = objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
            objc_setAssociatedObject(self, &AssociatedKeys.delegate, newValue, associationPolicy)
        }
    }
    
    // MARK: - Array for inputView
    private(set) var fieldOptions: NSArray {
        get { guard let value = objc_getAssociatedObject(self, &AssociatedKeys.fOptions) as? NSArray else {
            return NSArray() }
            return value
        }
        set(newValue) {
            let associationPolicy = objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
            objc_setAssociatedObject(self, &AssociatedKeys.fOptions, newValue, associationPolicy)
        }
    }
    
    // MARK: - Key for inputView if input data is Array of Dictionary
    private(set) var KeyForValue: String {
        get { guard let value = objc_getAssociatedObject(self, &AssociatedKeys.keyForVal) as? String else {
            return String() }
            return value
        }
        set(newValue) {
            let associationPolicy = objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
            objc_setAssociatedObject(self, &AssociatedKeys.keyForVal, newValue, associationPolicy)
        }
    }
    
    // MARK: - Date Formatter for field DatePicker
    private(set) var dpFormatter: String {
        get { guard let value = objc_getAssociatedObject(self, &AssociatedKeys.dateFormat) as? String else {
            return String() }
            return value
        }
        set(newValue) {
            let associationPolicy = objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
            objc_setAssociatedObject(self, &AssociatedKeys.dateFormat, newValue, associationPolicy)
        }
    }
}

// MARK: - ---> UIPickerViewDelegate & DataSource
// ==============================================
extension UITextField: UIPickerViewDelegate, UIPickerViewDataSource {
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.fieldOptions.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let option = fieldOptions.object(at: row)
        let title = option is String ? option : (option as! NSDictionary)[KeyForValue]
        return (title as! String)
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let option = fieldOptions.object(at: row)
        let title = option is String ? option : (option as! NSDictionary)[KeyForValue]
        self.text = (title as! String)
        optionsDelegate.textField(didSelectOption: row, textField: self)
    }
}

// MARK: - ---> UITextFieldOptionsDelegate (Custom Protocol)
// =========================================================
public protocol UITextFieldOptionsDelegate: NSObjectProtocol {
    func textField(didSelectOption index: Int, textField:UITextField)
    func updateView(inputViewHeight: CGFloat) -> Void
}
