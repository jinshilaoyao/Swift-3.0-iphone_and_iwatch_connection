//
//  ViewController.swift
//  LocationContent
//
//  Created by yesway on 2017/1/23.
//  Copyright © 2017年 yesway. All rights reserved.
//

import UIKit
import CoreLocation
import WatchConnectivity
class ViewController: UIViewController {

    fileprivate var mapLocation: MapManager? {
        didSet {
            mapLocation?.mapDelegate = self
        }
    }
    
    @IBOutlet weak var sendSwitch: UISwitch! {
        didSet {
            sendSwitch.addTarget(self, action: #selector(changeSendLocationStatus), for: UIControlEvents.valueChanged)
        }
    }
    @IBOutlet weak var receiveSwitch: UISwitch! {
        didSet {
            receiveSwitch.addTarget(self, action: #selector(changeReceiveLocationStatus), for: UIControlEvents.valueChanged)
        }
    }
    

    fileprivate var session: WCSession? {
        didSet {
            session?.delegate = self
        }
    }
    
    @IBOutlet weak var deviceLabel: UILabel!
    @IBOutlet weak var latLabel: UILabel!
    @IBOutlet weak var lonLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapLocation = MapManager()
        
        session = WCSession.default()
        session?.activate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func changeSendLocationStatus(switch: UISwitch) {
        sendSwitch.isOn ? mapLocation?.start() : mapLocation?.stop()
    }
    
    func changeReceiveLocationStatus(switch: UISwitch) {
        receiveSwitch.isOn ? session?.activate() : session?.activate()
    }
}
extension ViewController: MapManagerLocationDelegate {
    
    func mapManager(manager: MapManager, didUpateAndGetLastCllocation location: CLLocation) {
        let dict = ["lat": location.coordinate.latitude, "lon": location.coordinate.longitude, "device": "iphone"] as [String : Any]
        session?.sendMessage(dict, replyHandler: nil, errorHandler: nil)
    }
    
    func mapManager(manager: MapManager, didFailed error: Error) {
        
    }
    
    func mapManagerServerClosed(manager: MapManager) {
        
    }
}
extension ViewController: WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        
        if !receiveSwitch.isOn {
            return
        }
        
        guard let decv = message["device"] as? String, let lat = message["lat"] as? Double, let lon = message["lon"] as? Double else {
            return
        }
        
        if decv == "watch" {
            deviceLabel.text = decv
            latLabel.text = String(lat)
            lonLabel.text = String(lon)
        }
    }
}

