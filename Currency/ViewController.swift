//
//  ViewController.swift
//  Currency
//
//  Created by Jiraporn Praneet on 7/24/2560 BE.
//  Copyright © 2560 Jiraporn Praneet. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AAPickerView
class ViewController: UIViewController {
    @IBOutlet weak var currencyFieldPicker: AAPickerView!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyField: UITextField!
    @IBOutlet weak var convertCurrencyFieldPicker: AAPickerView!
    var selectDataCurrencies = ""
    var selectConvertCurrencies = ""
    var currencyRates = Dictionary<String, AnyObject>()
    var json = [String: String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        configCurrencyFieldPickerPicker()
        configConvertCurrencyFieldPickerPicker()
    }
    func configCurrencyFieldPickerPicker() {
        currencyFieldPicker.pickerType = .StringPicker
        let pathDataCurrencies = Bundle.main.path(forResource: "currencies", ofType: "plist")!
        let dataCurrencies = (NSArray(contentsOfFile: pathDataCurrencies) as? [String])!
        currencyFieldPicker.stringPickerData = dataCurrencies
        currencyFieldPicker.pickerRow.font = UIFont(name: "American Typewriter", size: 30)
        currencyFieldPicker.toolbar.barTintColor = UIColor(red:0.90, green:0.37, blue:0.37, alpha:1.0)
        currencyFieldPicker.toolbar.tintColor = UIColor(red:0.90, green:0.37, blue:0.37, alpha:1.0)
        currencyFieldPicker.stringDidChange = { index in
             self.selectDataCurrencies = dataCurrencies[index]
            print("selectedString1 :  ", self.selectDataCurrencies, dataCurrencies[index])
            self.selectDataCurrenciesAPI(base:self.selectDataCurrencies)
            self.currencyLabel.text = self.selectDataCurrencies

        }
    }
       func configConvertCurrencyFieldPickerPicker() {
        convertCurrencyFieldPicker.pickerType = .StringPicker
        let pathDataCurrencies = Bundle.main.path(forResource: "currencies", ofType: "plist")!
        let dataCurrencies = (NSArray(contentsOfFile: pathDataCurrencies) as? [String])!
        convertCurrencyFieldPicker.stringPickerData = dataCurrencies
        convertCurrencyFieldPicker.pickerRow.font = UIFont(name: "American Typewriter", size: 30)
        convertCurrencyFieldPicker.toolbar.barTintColor = UIColor(red:0.90, green:0.37, blue:0.37, alpha:1.0)
        convertCurrencyFieldPicker.toolbar.tintColor = UIColor(red:0.90, green:0.37, blue:0.37, alpha:1.0)
        convertCurrencyFieldPicker.stringDidChange = { index in
            self.selectConvertCurrencies = dataCurrencies[index]
            print("selectedString2 :  ", self.selectConvertCurrencies, dataCurrencies[index])
            self.selectDataConvertCurrenciesAPI(base:self.selectConvertCurrencies)
            self.currencyLabel2.text = self.selectConvertCurrencies
        }
    }
    func selectDataCurrenciesAPI(base:String) {
        let url = String(format:"http://api.fixer.io/latest?base=%@", base)
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
            case .failure(let error):
                print(error)
            }
        }
    }
    func selectDataConvertCurrenciesAPI(base:String) {
        let url = String(format:"http://api.fixer.io/latest?base=%@", base)
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let show = self.selectDataCurrencies
                print("\(show)")
                let currencyRates = json["rates"]["\(show)"].doubleValue
                print("CurrencyRates: \(currencyRates)")
                if let currencyAmount  = Double(self.currencyField.text!) {
                    let resultCurrencyRatesConvert = currencyAmount * currencyRates
                    self.currencyLabel.text = String(format: "%.02f", (resultCurrencyRatesConvert))
                } else {
                    let resultCurrencyRatesConvert = 0 * currencyRates
                    self.currencyLabel.text = String(format: "%.02f", (resultCurrencyRatesConvert))
                }
            case .failure(let error):
                print(error)
            }
        }
    }
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
