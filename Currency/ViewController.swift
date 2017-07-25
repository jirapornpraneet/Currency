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
    @IBOutlet weak var ratesLabel: UILabel!
    var selectDataCurrency = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        configCurrencyFieldPickerPicker()
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
             self.selectDataCurrency = dataCurrencies[index]
            print("selectedString1 :  ", self.selectDataCurrency, dataCurrencies[index])
            self.selectDataCurrenciesAPI(base:self.selectDataCurrency)
        }
    }
    func selectDataCurrenciesAPI(base:String) {
        let url = String(format:"http://api.fixer.io/latest?base=%@", base)
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                print(response)
               print("rates")
                let show = json["rates"]["THB"]
                print("JSON: \(show)")
                self.currencyLabel.text = "\(show)"
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
