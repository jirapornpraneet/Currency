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

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyField: UITextField!
    @IBOutlet weak var currencyPickerView: UIPickerView!
    @IBOutlet weak var convertCurrencyPickerView: UIPickerView!
    var selectDataCurrencies = ""
    var selectConvertCurrencies = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyField.text = ""
        currencyField.delegate = self
        currencyPickerView.delegate = self
        currencyPickerView.dataSource = self
        convertCurrencyPickerView.delegate = self
        convertCurrencyPickerView.dataSource = self
        currencyPickerView.layer.cornerRadius = 8
        currencyPickerView.layer.masksToBounds = true
        convertCurrencyPickerView.layer.cornerRadius = 8
        convertCurrencyPickerView.layer.masksToBounds = true
        currencyField.layer.cornerRadius = 8
        currencyField.layer.masksToBounds = true
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == currencyPickerView {
            let pathShowDataCurrencies = Bundle.main.path(forResource: "currenciesShow", ofType: "plist")!
            let showDataCurrencies = (NSArray(contentsOfFile: pathShowDataCurrencies) as? [String])!
            return showDataCurrencies.count
        } else {
            let pathShowDataCurrencies = Bundle.main.path(forResource: "currenciesShow", ofType: "plist")!
            let showDataCurrencies = (NSArray(contentsOfFile: pathShowDataCurrencies) as? [String])!
            return showDataCurrencies.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            let pathShowDataCurrencies = Bundle.main.path(forResource: "currenciesShow", ofType: "plist")!
            let showDataCurrencies = (NSArray(contentsOfFile: pathShowDataCurrencies) as? [String])!
            return showDataCurrencies[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == currencyPickerView {
            let pathDataCurrencies = Bundle.main.path(forResource: "currencies", ofType: "plist")!
            let dataCurrencies = (NSArray(contentsOfFile: pathDataCurrencies) as? [String])!
            selectDataCurrencies = dataCurrencies[row]
            self.selectDataCurrenciesAPI(base:self.selectDataCurrencies)
            print(dataCurrencies[row])
        } else {
            let pathDataCurrencies = Bundle.main.path(forResource: "currencies", ofType: "plist")!
            let dataCurrencies = (NSArray(contentsOfFile: pathDataCurrencies) as? [String])!
            selectConvertCurrencies = dataCurrencies[row]
            self.selectDataConvertCurrenciesAPI(base:self.selectConvertCurrencies)
            print(dataCurrencies[row])
        }
    }
    func selectDataCurrenciesAPI(base:String) {
        let url = String(format:"http://api.fixer.io/latest?base=%@", base)
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                let show = self.selectConvertCurrencies
                print("\(show)")
                let currencyRates = json["rates"]["\(show)"].doubleValue
                print("CurrencyRates: \(currencyRates)")
                if let currencyAmount  = Double(self.currencyField.text!) {
                    let resultCurrencyRatesConvert = currencyAmount * currencyRates
                    self.currencyLabel.text = String(format: "%.04f", (resultCurrencyRatesConvert))
                } else {
                    let resultCurrencyRatesConvert = 0 * currencyRates
                    self.currencyLabel.text = String(format: "%.03f", (resultCurrencyRatesConvert))
                }

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
                    self.currencyLabel.text = String(format: "%.04f", (resultCurrencyRatesConvert))
                } else {
                    let resultCurrencyRatesConvert = 0 * currencyRates
                    self.currencyLabel.text = String(format: "%.03f", (resultCurrencyRatesConvert))
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
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        currencyField.resignFirstResponder()
        return true
    }
}
