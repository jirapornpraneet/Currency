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
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = String(format:"http://api.fixer.io/latest?base=%@", "USD")
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                print(response)
                print("rates")
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
