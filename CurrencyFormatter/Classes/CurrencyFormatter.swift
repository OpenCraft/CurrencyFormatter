//
//  CurrencyFormatter.swift
//  Pods
//
//  Created by Henrique Morbin on 27/03/17.
//
//

import Foundation

public class CurrencyFormatter {
    
    public enum Separator: String {
        case none = ""
        case dot = "."
        case comma = ","
        case space = " "
    }
    
    public enum Prefix: String {
        case none = ""
        case dollar = "U$ "
        case real = "R$ "
    }
    
    //public let doubleValue: Double
    public var decimalSeparator = Separator.dot
    public var thousandSeparator = Separator.comma
    public var prefix = Prefix.none
    public var prefixAttributes: [String : Any]?
    public var integersAttributes: [String : Any]?
    public var decimalsAttributes: [String : Any]?
    
    public init() {}
    
    // MARK: Integer Representation
    
    fileprivate func integerPart(from doubleValue: Double) -> Int {
        let numberOfPlaces = 2.0
        let multiplier = pow(10.0, numberOfPlaces)
        let rounded = round(doubleValue * multiplier) / multiplier
        
        return Int(rounded)
    }
    
    // MARK: Decimal Representation
    
    fileprivate func decimalPart(from doubleValue: Double) -> Int {
        let numberOfPlace1s = 3.0
        let multiplier1 = pow(10.0, numberOfPlace1s)
        let rounded1 = round(doubleValue * multiplier1) / multiplier1
        
        return Int(rounded1 * multiplier1) - (integerPart(from: doubleValue) * Int(multiplier1))
    }
    
    // MARK: Attributed String
    
    public func attributedString(from doubleValue: Double) -> NSAttributedString {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = thousandSeparator.rawValue
        formatter.usesGroupingSeparator = true
        formatter.maximumFractionDigits = 0
        
        let integerText = formatter.string(from: NSNumber(value: integerPart(from: doubleValue))) ?? "0"
        let moduleDoubleValue = doubleValue < 0 ? doubleValue * -1 : doubleValue
        var decimalText = String(format: "%03d", decimalPart(from: moduleDoubleValue))
        decimalText.remove(at: decimalText.index(before: decimalText.endIndex))
        decimalText = decimalText.replacingOccurrences(of: "-", with: "")
        
        let attrText = NSMutableAttributedString()
        attrText.append(NSAttributedString(string: prefix.rawValue, attributes: prefixAttributes))
        attrText.append(NSAttributedString(string: integerText, attributes: integersAttributes))
        attrText.append(NSAttributedString(string: decimalSeparator.rawValue, attributes: decimalsAttributes))
        attrText.append(NSAttributedString(string: decimalText, attributes: decimalsAttributes))
        
        return attrText
    }
    
    public func attributedString(from textValue: String) -> NSAttributedString {
        let doubleValue = double(from: textValue)
        return attributedString(from: doubleValue)
    }
    
    public func attributedString(from textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> NSAttributedString {
        let doubleValue = double(from: textField, shouldChangeCharactersIn: range, replacementString: string)
        return attributedString(from: doubleValue)
    }
    
    // MARK: String
    
    public func string(from doubleValue: Double) -> String {
        return attributedString(from: doubleValue).string
    }
    
    public func string(from textValue: String) -> String {
        let doubleValue = double(from: textValue)
        return attributedString(from: doubleValue).string
    }
    
    public func string(from textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> String {
        let doubleValue = double(from: textField, shouldChangeCharactersIn: range, replacementString: string)
        return attributedString(from: doubleValue).string
    }
    
    // MARK: Double Representation
    
    public func double(from textValue: String) -> Double {
        let cleannedText = textValue.cleanned
        let doubleValue = (Double(cleannedText) ?? 0)/100
        return doubleValue
    }
    
    public func double(from textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Double {
        let oldText = (textField.text ?? "0") as NSString
        let editedText = oldText.replacingCharacters(in: range, with: string)
        return double(from: editedText)
    }
}

fileprivate extension String {
    var cleanned: String {
        let cleanned = components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        if contains("-") {
            return "-\(cleanned)"
        } else {
            return cleanned
        }
    }
}
