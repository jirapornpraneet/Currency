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
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyField.text = ""
        currencyField.delegate = self
        currencyField.layer.masksToBounds = true
        currencyField.layer.cornerRadius = 10
        currencyPickerView.delegate = self
        currencyPickerView.dataSource = self
        currencyPickerView.layer.masksToBounds = true
        currencyPickerView.layer.cornerRadius = 10
        convertCurrencyPickerView.delegate = self
        convertCurrencyPickerView.dataSource = self
        convertCurrencyPickerView.layer.masksToBounds = true
        convertCurrencyPickerView.layer.cornerRadius = 10
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let path = Bundle.main.path(forResource: "currenciesShow", ofType: "plist")!
        let dataCurrencies = (NSArray(contentsOfFile: path) as? [String])!
        if pickerView == currencyPickerView {
            return dataCurrencies.count
        } else {
            return dataCurrencies.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            let path = Bundle.main.path(forResource: "currenciesShow", ofType: "plist")!
            let dataCurrencies = (NSArray(contentsOfFile: path) as? [String])!
            return dataCurrencies[row]
    }
    var getJson = JSON([String: Any]())
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            let path = Bundle.main.path(forResource: "currencies", ofType: "plist")!
            let dataCurrencies = (NSArray(contentsOfFile: path) as? [String])!
        if pickerView == currencyPickerView {
            let getDataCurrencies = dataCurrencies[row]
            getDataCurrenciesAPI(base: getDataCurrencies)
            print(dataCurrencies[row])
        } else {
            let getDataConvertCurrencies = dataCurrencies[row]
            let currency = getDataConvertCurrencies
            let currencyRates = self.getJson["rates"]["\(currency)"].doubleValue
            print(dataCurrencies[row])
            print("CurrencyRates: \(currencyRates)")
            convert(rates: currencyRates)
        }
    }
    func getDataCurrenciesAPI(base: String) {
        let url = String(format:"http://api.fixer.io/latest?base=%@", base)
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                self.getJson = JSON(value)
                print("%@", self.getJson["rates"]["RON"])
            case .failure(let error):
                print(error)
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func convert(rates: Double) {
        if let currencyAmount  = Double(self.currencyField.text!) {
            if rates == 0.0 {
                let resultCurrencyRatesConvert = currencyAmount
                self.currencyLabel.text = String(format: "%.0f", (resultCurrencyRatesConvert))
            } else {
                let resultCurrencyRatesConvert = currencyAmount * rates
                self.currencyLabel.text = String(format: "%.06f", (resultCurrencyRatesConvert))
            }
        } else {
            let resultCurrencyRatesConvert = 0 * rates
            self.currencyLabel.text = String(format: "%.03f", (resultCurrencyRatesConvert))
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        currencyField.resignFirstResponder()
        return true
    }
}
