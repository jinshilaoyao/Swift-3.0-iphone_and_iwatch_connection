//
//  InterfaceController.swift
//  LocationContent WatchKit Extension
//
//  Created by yesway on 2017/1/23.
//  Copyright © 2017年 yesway. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController {

    
    @IBOutlet var deviceLabel: WKInterfaceLabel!
    @IBOutlet var latLabel: WKInterfaceLabel!
    @IBOutlet var lonLabel: WKInterfaceLabel!
    
    fileprivate var mapLocation: MapManager? {
        didSet {
            mapLocation?.mapDelegate = self
        }
    }
    
    fileprivate var session: WCSession? {
        didSet {
            session?.delegate = self
        }
    }
    
    @IBOutlet var sendSwitch: WKInterfaceSwitch!
    @IBOutlet var receiveSwitch: WKInterfaceSwitch!
    
    
    @IBAction func changeSendLocationStatus(_ value: Bool) {
        value ? mapLocation?.start() : mapLocation?.stop()
    }
    
    @IBAction func changeReceiveLocationStatus(_ value: Bool) {
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        mapLocation = MapManager()
        mapLocation?.start()
        
        session = WCSession.default()
        session?.activate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}

extension InterfaceController: MapManagerLocationDelegate {
    
    func mapManager(manager: MapManager, didUpateAndGetLastCllocation location: CLLocation) {
//        let dict = ["lat": location.coordinate.latitude, "lon": location.coordinate.longitude, "device": "watch"] as [String : Any]
//        session?.sendMessage(dict, replyHandler: nil, errorHandler: nil)
    }
    
    func mapManager(manager: MapManager, didFailed error: Error) {
        
    }
    
    func mapManagerServerClosed(manager: MapManager) {
        
    }
}

extension InterfaceController: WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        
        guard let device = message["device"] as? String, let lat = message["lat"] as? Double, let lon = message["lon"] as? Double else {
            return
        }
        
        if device == "iphone" {
            deviceLabel.setText("device: \(device)")
            latLabel.setText("lat: \(lat)")
            lonLabel.setText("lon: \(lon)")
        }
    }
}
