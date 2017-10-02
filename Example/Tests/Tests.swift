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
        
        verifyFormattedStringFromDouble(value: 4.01, expectedString: "R$ 4,01")
        verifyFormattedStringFromDouble(value: 4.02, expectedString: "R$ 4,02")
        verifyFormattedStringFromDouble(value: 4.03, expectedString: "R$ 4,03")
        verifyFormattedStringFromDouble(value: 4.04, expectedString: "R$ 4,04")
        verifyFormattedStringFromDouble(value: 4.05, expectedString: "R$ 4,05")
        verifyFormattedStringFromDouble(value: 4.16, expectedString: "R$ 4,16")
        verifyFormattedStringFromDouble(value: 4.06, expectedString: "R$ 4,06")
        verifyFormattedStringFromDouble(value: 6.67, expectedString: "R$ 6,67")
        verifyFormattedStringFromDouble(value: 9.87, expectedString: "R$ 9,87")
        
        verifyFormattedStringFromDouble(value: 12.67, expectedString: "R$ 12,67")
        verifyFormattedStringFromDouble(value: 65.69, expectedString: "R$ 65,69")
        verifyFormattedStringFromDouble(value: 70.07, expectedString: "R$ 70,07")
        verifyFormattedStringFromDouble(value: 75.08, expectedString: "R$ 75,08")
        verifyFormattedStringFromDouble(value: 100.86, expectedString: "R$ 100,86")
        
        verifyFormattedStringFromDouble(value: 1000.69, expectedString: "R$ 1.000,69")
        verifyFormattedStringFromDouble(value: 1000.98, expectedString: "R$ 1.000,98")
        verifyFormattedStringFromDouble(value: 1000.54, expectedString: "R$ 1.000,54")
    }
    
    func test_AttributedString_ToDouble() {
        verifyDoubleFromFormattedString(formattedString: "R$ -1.850,98", expectedValue: -1850.98)
        verifyDoubleFromFormattedString(formattedString: "R$ -0,01", expectedValue: -0.01)
        verifyDoubleFromFormattedString(formattedString: "R$ -1.850,01", expectedValue: -1850.01)
        verifyDoubleFromFormattedString(formattedString: "R$ 1.850,01", expectedValue: 1850.01)
        verifyDoubleFromFormattedString(formattedString: "R$ 4,06", expectedValue: 4.06)
        verifyDoubleFromFormattedString(formattedString: "4,06", expectedValue: 4.06)
        verifyDoubleFromFormattedString(formattedString: "4.06", expectedValue: 4.06)
        verifyDoubleFromFormattedString(formattedString: String(4.02), expectedValue: 4.02)
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
