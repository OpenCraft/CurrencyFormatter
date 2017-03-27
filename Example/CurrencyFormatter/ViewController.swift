//
//  ViewController.swift
//  CurrencyFormatter
//
//  Created by henrique-morbin-ilegra on 03/27/2017.
//  Copyright (c) 2017 henrique-morbin-ilegra. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: Methods

    fileprivate final func attributes(forSize size: Double, isBold: Bool) -> [String : Any]? {
        let font = isBold ? UIFont.boldSystemFont(ofSize: CGFloat(size)) : UIFont.systemFont(ofSize: CGFloat(size))
        
        return [
            NSFontAttributeName: font,
            NSForegroundColorAttributeName: UIColor.red,
        ]
    }
}

extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let formatter = CurrencyFormatter(textField: textField, shouldChangeCharactersIn: range, replacementString: string)
        formatter.separator = .comma
        formatter.prefix = .real
        formatter.prefixAttributes = attributes(forSize: 16, isBold: false)
        formatter.integersAttributes = attributes(forSize: 24, isBold: true)
        formatter.decimalsAttributes = attributes(forSize: 16, isBold: true)
        
        textField.attributedText = formatter.toAttributedString
        
        return false
    }
}

class CurrencyFormatter {
 
    enum Separator: String {
        case dot = "."
        case comma = ","
    }
    
    enum Prefix: String {
        case none = ""
        case dollar = "U$ "
        case real = "R$ "
    }
    
    let doubleValue: Double
    var separator = Separator.dot
    var prefix = Prefix.none
    var prefixAttributes: [String : Any]?
    var integersAttributes: [String : Any]?
    var decimalsAttributes: [String : Any]?
    
    init(value: Double) {
        doubleValue = value
    }
    
    convenience init(textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) {
        let oldText = (textField.text ?? "0") as NSString
        let editedText = oldText.replacingCharacters(in: range, with: string)
        self.init(textValue: editedText)
    }
    
    convenience init(textValue: String) {
        let cleannedText = textValue.cleanned
        let doubleValue = (Double(cleannedText) ?? 0)/100
        self.init(value: doubleValue)
    }
    
    // MARK: Methods
    
    var toString: String {
        return String(format: "%@%.2f", prefix.rawValue, doubleValue).replacingOccurrences(of: ".", with: separator.rawValue)
    }
    
    var toAttributedString: NSAttributedString {
        let integer = Int(trunc(doubleValue))
        let decimal = Int((doubleValue - trunc(doubleValue)) * 100)
        
        let integerText = "\(integer)"
        let decimalText = String(format: "%02d", decimal)

        let attrText = NSMutableAttributedString()
        attrText.append(NSAttributedString(string: prefix.rawValue, attributes: prefixAttributes))
        attrText.append(NSAttributedString(string: integerText, attributes: integersAttributes))
        attrText.append(NSAttributedString(string: ",", attributes: decimalsAttributes))
        attrText.append(NSAttributedString(string: decimalText, attributes: decimalsAttributes))
        
        return attrText
    }
}

extension String {
    var cleanned: String {
        return self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }
}
