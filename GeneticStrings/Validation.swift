//
//  Validation.swift
//  GeneticStrings
//
//  Created by Mateus Leichsenring on 03.09.18.
//  Copyright © 2018 Mateus Leichsenring. All rights reserved.
//

import Foundation
import UIKit

class Validation {
    var uiViews:[String:(uiView:UIView,validation:Any)]
    
    init() {
        self.uiViews = [String:(uiView:UIView,validation:Any)]()
    }
    
    func register(values: (key:String,uiView:UIView,validation:ValidationType)...) {
        for value in values {
            self.uiViews[value.key] = (value.uiView, value.validation)
        }
    }
    
    func register(values: (key:String,uiView:UIView,regex:String)...) {
        for value in values {
            self.uiViews[value.key] = (value.uiView, value.regex)
        }
    }
    
    func register(values: (key:String,uiView:UIView,range:Range<Int>)...) {
        for value in values {
            self.uiViews[value.key] = (value.uiView, value.range)
        }
    }
    
    func validateTextFields() -> [Valid] {
        var result = [Valid]()
        for view in uiViews {
            guard let textField = view.value.uiView as? UITextField else { continue }
            
            if textField.text == nil || (textField.text?.isEmpty)! {
                result.append(.failure(viewKey: view.key, .emptyValue, ""))
                continue
            }
            
            result.append(validateValues(view.value.validation, textField, view.key))
        }
        
        return result
    }
    
    private func validateValues(_ validation: Any,_ input: UITextField, _ inputKey:String) -> Valid {
        if let validationType = validation as? ValidationType {
            return validateValues(value: (validationType, input, inputKey))
        }
        
        if let regex = validation as? String, let inputString = input.text, !isValidRegEx(inputString, regex) {
            return .failure(viewKey:inputKey, .invalidRegex, "Invalid value")
        }
        
        if let rangeInt = validation as? Range<Int>, let inputInt = Int(input.text!), !rangeInt.contains(inputInt) {
            return .failure(viewKey: inputKey, .invalidRange, "Number is out of range")
        }
        
        return .success
    }
    
    private func validateValues(value: (type: ValidationType, input: UITextField,inputKey: String)) -> Valid {
        switch value.type {
        case .email:
            if let tempValue = isValidString((value.inputKey,value.input, .email, .invalidEmail)) {
                return tempValue
            }
        case .stringWithFirstLetterCaps:
            if let tempValue = isValidString((value.inputKey,value.input, .alphabeticStringFirstLetterCaps, .invalidFirstLetterCaps)) {
                return tempValue
            }
        case .phoneNo:
            if let tempValue = isValidString((value.inputKey,value.input, .phoneNo, .invalidPhone)) {
                return tempValue
            }
        case .alphabeticString:
            if let tempValue = isValidString((value.inputKey,value.input, .alphabeticStringWithSpace, .invalidAlphabeticString)) {
                return tempValue
            }
        case .password:
            if let tempValue = isValidString((value.inputKey,value.input, .password, .invalidPSW)) {
                return tempValue
            }
        case .onlyNumber:
            if let tempValue = isValidString((value.inputKey,value.input, .onlyNumbers, .invalidOnlyNumbers)) {
                return tempValue
            }
        }
    
        return .success
    }
    
    func isValidString(_ input: (inputKey:String,textField: UITextField, regex: RegEx, invalidAlert: AlertMessages)) -> Valid? {
        if isValidRegEx(input.textField.text!, input.regex) != true {
            return .failure(viewKey:input.inputKey, input.invalidAlert,"")
        }
        return nil
    }
    
    func isValidRegEx(_ testStr: String, _ regex: RegEx) -> Bool {
        let stringTest = NSPredicate(format:"SELF MATCHES %@", regex.rawValue)
        let result = stringTest.evaluate(with: testStr)
        return result
    }
    
    func isValidRegEx(_ testStr: String, _ regexString: String) -> Bool {
        let stringTest = NSPredicate(format:"SELF MATCHES %@", regexString)
        let result = stringTest.evaluate(with: testStr)
        return result
    }
}

enum AlertType {
    case emptyField
    case invalidField
}

enum AlertMessages: String {
    case invalidEmail = "Invalid Email"
    case invalidFirstLetterCaps = "First Letter should be capital"
    case invalidPhone = "Invalid Phone"
    case invalidAlphabeticString = "Invalid String"
    case invalidPSW = "Invalid Password"
    case invalidOnlyNumbers = "Must contain only Numbers"
    case invalidRegex = "Value does not match"
    case invalidRange = "Value out of range"
    
    case emptyValue = "Empty text field"
    
    func localized() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}

enum Valid {
    case success
    case failure(viewKey:String, AlertMessages, String)
}

enum ValidationType {
    case email
    case stringWithFirstLetterCaps
    case phoneNo
    case alphabeticString
    case password
    case onlyNumber
}

enum RegEx: String {
    case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
    case password = "^.{6,20}$"
    case alphabeticStringWithSpace = "^[a-zA-Z ]*$"
    case alphabeticStringFirstLetterCaps = "^[A-Z]+[a-zA-Z]*$"
    case phoneNo = "[0-9]{10,14}"
    case onlyNumbers = "[0-9]*$"
}
