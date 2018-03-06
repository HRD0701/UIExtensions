//
//  VCExtension.swift
//  UIExtensions
//
//  Created by Hardik Bangoria on 06/03/18.
//

import Foundation

extension UIViewController {
    
    public func calBottomSpace(textField: UITextField) -> Void {
        
        var view = textField as UIView
        var bottomSpace: CGFloat = textField.frame.origin.y + textField.frame.size.height;
        
        repeat {
            
            print("Frame: \(view.frame)")
            print("bottomSpace: \(bottomSpace)")
            view = view.superview!
            bottomSpace += view.frame.origin.y
            
        } while view != self.view
        
        bottomSpace = view.frame.size.height - bottomSpace
        print("Frame: \(view.frame)")
        print("bottomSpace: \(bottomSpace)")
    }
    
    // MARK: - Show Alert With Message
    /**
     This method is used for to show simple message with 'OK' button.
     */
    public func showAlertWithMSG(_ message: String!) -> Void {
        
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (okAction: UIAlertAction!) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Self View update animated
    /**
     Use this method for to scroll up the main view of controller.
     - parameters:
     - displacement: Pass float value as much you want to move up the main view
     */
    public func updateSelfView(displacement: CGFloat) -> Void {
        
        UIView.animate(withDuration: 0.23) {
            var frame = self.view.frame
            frame.origin.y = 0 - displacement
            self.view.frame = frame
        }
    }
    
    
    // MARK: - Back press event
    // ========================
    @IBAction open func backPressed(_ sender: Any) {
        
        if self.isModal() {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func isModal() -> Bool {
        if self.presentingViewController != nil {
            return true
        } else if self.navigationController?.presentingViewController?.presentedViewController == self.navigationController  {
            return true
        } else if self.tabBarController?.presentingViewController is UITabBarController {
            return true
        }
        
        return false
    }
}
