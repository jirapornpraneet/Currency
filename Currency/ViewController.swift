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
    var currencyAmount = 0.0
    var currencyRates  = 0.0
//    var show = JSON(String)
    var showJson = JSON([String: Any]())
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyField.text = ""
        currencyField.delegate = self
        currencyPickerView.delegate = self
        currencyPickerView.dataSource = self
        convertCurrencyPickerView.delegate = self
        convertCurrencyPickerView.dataSource = self
        currencyPickerView.layer.masksToBounds = true
        currencyPickerView.layer.cornerRadius = 8
        convertCurrencyPickerView.layer.masksToBounds = true
        convertCurrencyPickerView.layer.cornerRadius = 8
        currencyField.layer.masksToBounds = true
        currencyField.layer.cornerRadius = 8
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let pathShowDataCurrenciesPickerView = Bundle.main.path(forResource: "currenciesShow", ofType: "plist")!
        let showDataCurrenciesPickerView = (NSArray(contentsOfFile: pathShowDataCurrenciesPickerView) as? [String])!
        if pickerView == currencyPickerView {
            return showDataCurrenciesPickerView.count
        } else {
            return showDataCurrenciesPickerView.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            let pathShowDataCurrenciesPickerView = Bundle.main.path(forResource: "currenciesShow", ofType: "plist")!
            let showDataCurrenciesPickerView = (NSArray(contentsOfFile: pathShowDataCurrenciesPickerView) as? [String])!
            return showDataCurrenciesPickerView[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            let pathDataCurrencies = Bundle.main.path(forResource: "currencies", ofType: "plist")!
            let dataCurrencies = (NSArray(contentsOfFile: pathDataCurrencies) as? [String])!
        if pickerView == currencyPickerView {
            selectDataCurrencies = dataCurrencies[row]
            selectDataCurrenciesAPI(base: selectDataCurrencies)
            print(dataCurrencies[row])
        } else {
            selectConvertCurrencies = dataCurrencies[row]
             selectDataCurrenciesAPI(base: selectDataCurrencies)
            print(dataCurrencies[row])
        }
    }
    func selectDataCurrenciesAPI(base: String) {
        let url = String(format:"http://api.fixer.io/latest?base=%@", base)
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                self.showJson = JSON(value)
                print("%@", self.showJson["rates"]["RON"])
                print("%@", self.showJson["rates"]["EUR"])
                let show = self.selectConvertCurrencies
                print("\(self.show)")
                let currencyRates = self.showJson["rates"]["\(self.show)"]
                 print(self.currencyRates)
                print("CurrencyRates: \(self.currencyRates)")
                 self.convert(rates:self.currencyRates)
            case .failure(let error):
                print(error)
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func convert(rates: Double) {
        if let currencyAmount  = Double(self.currencyField.text!) {
            print(rates)
            if rates == 0.0 {
                let resultCurrencyRatesConvert = currencyAmount * currencyAmount
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
