//
//  ViewController.swift
//  CurrencyFormatter
//
//  Created by henrique-morbin-ilegra on 03/27/2017.
//  Copyright (c) 2017 henrique-morbin-ilegra. All rights reserved.
//

import UIKit
import CurrencyFormatter

class ViewController: UIViewController {

    @IBOutlet weak var lblInteger: UILabel!
    @IBOutlet weak var lblDecimal: UILabel!
    @IBOutlet weak var lblString: UILabel!
    // MARK: Methods

    fileprivate final func attributes(forSize size: Double, isBold: Bool, color: UIColor) -> [String : Any]? {
        let font = isBold ? UIFont.boldSystemFont(ofSize: CGFloat(size)) : UIFont.systemFont(ofSize: CGFloat(size))
        
        return [
            NSFontAttributeName: font,
            NSForegroundColorAttributeName: color,
        ]
    }
}

extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let formatter = CurrencyFormatter()
        formatter.decimalSeparator = .comma
        formatter.thousandSeparator = .dot
        formatter.prefix = .real
        formatter.prefixAttributes = attributes(forSize: 16, isBold: false, color: .red)
        formatter.integersAttributes = attributes(forSize: 24, isBold: true, color: .blue)
        formatter.decimalsAttributes = attributes(forSize: 16, isBold: true, color: .green)
        
        lblString.text = "\(formatter.string(from: textField, shouldChangeCharactersIn: range, replacementString: string))"
        
        textField.attributedText = formatter.attributedString(from: textField, shouldChangeCharactersIn: range, replacementString: string)
        
        return false
    }
}
