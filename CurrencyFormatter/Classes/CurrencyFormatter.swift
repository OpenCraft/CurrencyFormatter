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
    
    public let doubleValue: Double
    public var decimalSeparator = Separator.dot
    public var thousandSeparator = Separator.comma
    public var prefix = Prefix.none
    public var prefixAttributes: [String : Any]?
    public var integersAttributes: [String : Any]?
    public var decimalsAttributes: [String : Any]?
    
    public init(value: Double) {
        doubleValue = value
    }
    
    public convenience init(textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) {
        let oldText = (textField.text ?? "0") as NSString
        let editedText = oldText.replacingCharacters(in: range, with: string)
        self.init(textValue: editedText)
    }
    
    public convenience init(textValue: String) {
        let cleannedText = textValue.cleanned
        let doubleValue = (Double(cleannedText) ?? 0)/100
        self.init(value: doubleValue)
    }
    
    // MARK: Methods
    
    public var toString: String {
        return toAttributedString.string
    }
    
    public var toAttributedString: NSAttributedString {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = thousandSeparator.rawValue
        formatter.usesGroupingSeparator = true
        formatter.maximumFractionDigits = 0
       
        let integerText = formatter.string(from: NSNumber(value: integerRepresentation)) ?? "0"
        var decimalText = String(format: "%03d", decimalRepresentation)
        decimalText.remove(at: decimalText.index(before: decimalText.endIndex))
        
        let attrText = NSMutableAttributedString()
        attrText.append(NSAttributedString(string: prefix.rawValue, attributes: prefixAttributes))
        attrText.append(NSAttributedString(string: integerText, attributes: integersAttributes))
        attrText.append(NSAttributedString(string: decimalSeparator.rawValue, attributes: decimalsAttributes))
        attrText.append(NSAttributedString(string: decimalText, attributes: decimalsAttributes))
        
        return attrText
    }
    
    fileprivate final var integerRepresentation: Int {
        let numberOfPlaces = 2.0
        let multiplier = pow(10.0, numberOfPlaces)
        let rounded = round(doubleValue * multiplier) / multiplier
        
        return Int(rounded)
    }
    
    fileprivate final var decimalRepresentation: Int {
        let numberOfPlace1s = 3.0
        let multiplier1 = pow(10.0, numberOfPlace1s)
        let rounded1 = round(doubleValue * multiplier1) / multiplier1
        
        return Int(rounded1 * multiplier1) - (integerRepresentation * Int(multiplier1))
    }
}

fileprivate extension String {
    var cleanned: String {
        return self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }
}
