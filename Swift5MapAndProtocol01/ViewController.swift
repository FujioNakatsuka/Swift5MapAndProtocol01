//
//  ViewController.swift
//  Swift5MapAndProtocol01
//
//  Created by 中塚富士雄 on 2020/08/17.
//  Copyright © 2020 中塚富士雄. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController,CLLocationManagerDelegate,UIGestureRecognizerDelegate,SearchLocationDelegate {
    
    //住所のテキストを入れるstring型の変数を設定,メンバー変数
    var addressString = ""
    
    @IBOutlet var longPress: UILongPressGestureRecognizer!
    @IBOutlet weak var settingButton: UIButton!
    
    @IBOutlet weak var mapView: MKMapView!
    var locManager:CLLocationManager!
    
    @IBOutlet weak var addressLabel: UILabel!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingButton.backgroundColor = .white
        
        settingButton.layer.cornerRadius = 20.0
    
        
        
    }

    //senderにはアクション開始に関する情報が入る
    @IBAction func longPressTap(_ sender: UILongPressGestureRecognizer) {
        
        
        //senderはUILongPressGestureRecognizerのlongTapを示して、.beganに入る
        if sender.state == .began{
            //tap 開始
            
        }else if sender.state == .ended{
       
    //タップ終了、位置指定、MapView上の緯度・経度を取得する
            //緯度・経度から住所に変換するviewの中のロケーションをタップポイントにいれる
            let tapPoint = sender.location(in: view)
            // centerはタップした場所。タップした位置（CGPoint）を指定して、MKMap上の緯度経度に変換する（convertはmapViewの既定メソッド ）
            let center = mapView.convert(tapPoint, toCoordinateFrom: mapView)
     
            let lati = center.latitude
            let longi = center.longitude
            convert(lati: lati, longi: longi)
        }
        
        
    }
  //convwertメソッドを作成する
    func convert(lati:CLLocationDegrees,longi:CLLocationDegrees){
        
        //初期化する
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: lati, longitude: longi)
        
        
        //オプショナルバインディング（if 変数　!= nil{  code }）nilでないなら（判定）、code実行
        //普通は：if let 変数 = 変数1{ code }
        //クロージャー,placeMarkに値が入ると{   }内が呼ばれる、値が入るまでは{   }外が呼ばれる。エラーの時に中のメソッド が呼び出される？⭐️
        //「{(placeMark,」と「= placeMark{」は同じだが、if let placemarkは異なる値⭐️
        geocoder.reverseGeocodeLocation(location){(placeMark,error) in
            
            //pmは既定のメソッド、値が本当に入っているかをチェックするためにif文で分けてゆく。
               if let placeMark = placeMark{
                //placeMarkの一番最初の値があったら、{  }内の処理に進め↓
                if let pm = placeMark.first{
                    // ||は論理和演算子で、左右辺のどちらか（行政区か地区名）が空でなければgeocoderを実行せよ！||はorの意味
                    if pm.administrativeArea != nil ||
                        pm.locality != nil {
                        
                        //メンバー変数なのでself.が必要、アドレスを全部入れる
                            self.addressString = pm.name! + pm.administrativeArea! + pm.locality!
                    }else{
                        
                        self.addressString = pm.name!
                        
                    }
                    self.addressLabel.text = self.addressString
                }
                
            }
            
            
        }
      
    }
   
    
    @IBAction func goToSearchVC(_ sender: Any) {
        //画面遷移
        
        performSegue(withIdentifier: "next", sender: nil)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "next"{
            
            let nextVC = segue.destination as! NextViewController
            nextVC.delegate = self
            
        }
    }
 
    //任されたデリゲートメソッド
  func searchLocation(latiValue: String, longiValue: String) {
    if latiValue.isEmpty != true && longiValue.isEmpty != true{
        
        let latiString = latiValue
        let longiString = longiValue
        
        //緯度経度からコーディネートを作成する
        let coordinate = CLLocationCoordinate2DMake(Double(latiString)!, Double(longiString)!)
        
        //表示する範囲を指定
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        
        //領域を指定
        let region = MKCoordinateRegion(center:coordinate , span: span)
        
        //領域をmapViewに設定
        mapView.setRegion(region, animated: true)
        
        //緯度経度から住所へ変換する
        convert(lati: Double(latiString)!, longi: Double(longiString)!)
        
        //ラベルに表示する
        addressLabel.text = addressString
    }else{
        
        addressLabel.text = "表示できません"
    
        }
 
    
    }
    
    
}

