//
//  NextViewController.swift
//  Swift5MapAndProtocol01
//
//  Created by 中塚富士雄 on 2020/08/17.
//  Copyright © 2020 中塚富士雄. All rights reserved.
//

import UIKit

protocol SearchLocationDelegate {
    func searchLocation(latiValue:String,longiValue:String)

}


class NextViewController: UIViewController {

    @IBOutlet weak var latiTextField: UITextField!
    
    @IBOutlet weak var longiTextField: UITextField!
    
    //searchLocationDelegateを変数に置き換え,なぜ？が付くのか⭐️
    var delegate:SearchLocationDelegate?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func okAction(_ sender: Any) {
        //textFieldに入力された値を取得
        
        let latiValue = latiTextField.text!
        let longiValue = longiTextField.text!
       
        
        //デレゲートメソッドの引数に入れる
        delegate?.searchLocation(latiValue: latiValue, longiValue: longiValue)
       
        //両方のテクストフィールドが空でなければ戻る
        if latiTextField.text != nil && longiTextField.text != nil{
          dismiss(animated: true, completion: nil)
        }
        
    }
    
}
