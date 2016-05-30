//
//  NearbyDelegate.swift
//  BTEPairing
//
//  Created by Yang, May on 2/12/16.
//  Copyright © 2016 Yang, May. All rights reserved.
//

import UIKit
import Foundation

@objc protocol NearbyDelegate {
    
    func selectedNearbyContact(peerDisplayName:String)
    
    func paymentRecieved(amount:String, peerName:String)
    
    func connectedWithPeer(peerName: String)
    
    func lostPeer(peerName: String)
}

