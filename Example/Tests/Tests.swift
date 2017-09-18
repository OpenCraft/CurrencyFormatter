import UIKit
import XCTest

@testable import CurrencyFormatter


class Tests: XCTestCase {
    
    var subject: CurrencyFormatter!
    
    override func setUp() {
        super.setUp()
        
        subject = CurrencyFormatter()
        subject.prefix = .real
        subject.decimalSeparator = .comma
        subject.thousandSeparator = .dot
    }
    
    func test_Double_ToFormattedString() {
        verifyFormattedStringFromDouble(value: -1850.98, expectedString: "R$ -1.850,98")
        verifyFormattedStringFromDouble(value: -0.01, expectedString: "R$ -0,01")
        verifyFormattedStringFromDouble(value: -1850.01, expectedString: "R$ -1.850,01")
        verifyFormattedStringFromDouble(value: 1850.01, expectedString: "R$ 1.850,01")
    }
    
    func test_AttributedString_ToDouble() {
        verifyDoubleFromFormattedString(formattedString: "R$ -1.850,98", expectedValue: -1850.98)
        verifyDoubleFromFormattedString(formattedString: "R$ -0,01", expectedValue: -0.01)
        verifyDoubleFromFormattedString(formattedString: "R$ -1.850,01", expectedValue: -1850.01)
        verifyDoubleFromFormattedString(formattedString: "R$ 1.850,01", expectedValue: 1850.01)
    }
    
    func test_NonNumbersString() {
        let actualResult = subject.attributedString(from: "-10,x1")
        let expectedResult = "R$ -1,01"
        
        XCTAssertEqual(actualResult.string, expectedResult)
    }
    
    func test_InvalidDoubleValueConversion() {
        let actualValue = subject.double(from: "-10,x1")
        let expectedValue = -1.01
            
        XCTAssertEqual(actualValue, expectedValue)
    }
    
    func verifyFormattedStringFromDouble(value: Double, expectedString string: String) {
        let formattedText = subject.attributedString(from: value)
        XCTAssertEqual(formattedText.string, string)
    }
    
    func verifyDoubleFromFormattedString(formattedString string: String, expectedValue value: Double) {
        let actualValue = subject.double(from: string)
        XCTAssertEqual(value, actualValue)
    }
    
}
