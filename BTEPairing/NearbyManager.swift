//
//  NearbyManager.swift
//  BTEPairing
//
//  Created by Yang, May on 2/11/16.
//  Copyright © 2016 Yang, May. All rights reserved.
//

import MultipeerConnectivity

class NearbyManager: NSObject, MCSessionDelegate, MCNearbyServiceAdvertiserDelegate
{
    var session: MCSession!
    var myPeerID: MCPeerID!
    var advertiser: MCNearbyServiceAdvertiser!
    let serviceType = "visa-bte"
    weak var nearbyDelegate:NearbyDelegate?
    
    override init()
    {
        super.init()
        self.myPeerID = MCPeerID(displayName: UIDevice.currentDevice().name)
        self.session = MCSession(peer: self.myPeerID)
        self.session.delegate = self

    }
    
    class var sharedInstance:NearbyManager
    {
        struct Static
        {
            static var instance : NearbyManager? = nil
            static var onceToken : dispatch_once_t = 0
        }
        
        dispatch_once(&Static.onceToken)
            {
                Static.instance = NearbyManager()
        }
        return Static.instance!
    }
    
    func start()
    {
        if (self.advertiser == nil)
        {
            self.session.delegate = self
            self.advertiser = MCNearbyServiceAdvertiser(peer: self.myPeerID, discoveryInfo: nil, serviceType: serviceType)
        }
        self.advertiser.delegate = self
        self.advertiser.startAdvertisingPeer()
        
    }
    
    func advertiser(advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: NSData?, invitationHandler: (Bool, MCSession) -> Void)
    {
        invitationHandler(true, self.session)
        
    }
    
    func session(session: MCSession, peer peerID: MCPeerID, didChangeState state: MCSessionState)
    {
        if (state == MCSessionState.Connected)
        {
            NSLog("\(peerID.displayName) connected")
            NearbyManager.sharedInstance.nearbyDelegate?.connectedWithPeer(peerID.displayName)
        }
        else if (state == MCSessionState.NotConnected)
        {
            print("\(peerID.displayName) disconnected")
            NearbyManager.sharedInstance.nearbyDelegate?.lostPeer(peerID.displayName)
        }
    }
    
    // Received data from remote peer.
    func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID)
    {
        NSLog("%@", "didReceiveData: \(data.length) bytes")
        if let dataReceived = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? NSDictionary
        {
            NSLog("Recieved data from \(peerID.displayName)")
            NSLog("Recieved amount $\((dataReceived["amount"])!)")
            NearbyManager.sharedInstance.nearbyDelegate?.paymentRecieved((dataReceived["amount"] as? String)!, peerName: peerID.displayName)
        }
    }
    
    // Received a byte stream from remote peer.
    func session(session: MCSession, didReceiveStream stream: NSInputStream, withName streamName: String, fromPeer peerID: MCPeerID)
    {
        
    }
    
    // Start receiving a resource from remote peer.
    func session(session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, withProgress progress: NSProgress)
    {
        
    }
    
    // Finished receiving a resource from remote peer and saved the content
    // in a temporary location - the app is responsible for moving the file
    // to a permanent location within its sandbox.
    func session(session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, atURL localURL: NSURL, withError error: NSError?)
    {
        
    }
    
    func sendData (paymentData:NSDictionary)
    {
        
        do
        {
            let paymentData = NSKeyedArchiver.archivedDataWithRootObject(paymentData)
            try NearbyManager.sharedInstance.session.sendData(paymentData, toPeers: NearbyManager.sharedInstance.session.connectedPeers, withMode: MCSessionSendDataMode.Reliable)
            
        }
        catch
        {
            print("error")
        }

    }
    
    
    
}
