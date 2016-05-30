

import Foundation
import UIKit
import MultipeerConnectivity

class NearbyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MCNearbyServiceBrowserDelegate
{
    private var nearbyServiceBrowser: MCNearbyServiceBrowser?
    private var nearbyDelegate: NearbyDelegate?
    private let NearbyTableViewCellName = "NearbyTableViewCell"
    var foundPeers = [MCPeerID?]()
    var nearbyManager:NearbyManager = NearbyManager()
    
    @IBOutlet weak var nearbyTableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.startBrowsingForNearby() // Browse for peers
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(true)
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var returnCell:UITableViewCell? = nil
        let cell = tableView.dequeueReusableCellWithIdentifier(self.NearbyTableViewCellName, forIndexPath: indexPath) as? NearbyTableViewCell
        cell?.selectionStyle = UITableViewCellSelectionStyle.None
        
        if let peer = self.foundPeers[indexPath.row]
        {
            cell?.setupNearbyPeer(peer.displayName)
            
        }
        returnCell = cell
        return returnCell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if self.foundPeers.count > 0
        {
            return self.foundPeers.count
        }
        else
        {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if let selectedPeer = self.foundPeers[indexPath.row]
        {
            self.nearbyServiceBrowser?.invitePeer(selectedPeer, toSession: NearbyManager.sharedInstance.session, withContext: nil, timeout: 100)
            self.dismissViewControllerAnimated(true, completion:
                { () -> Void in
                NearbyManager.sharedInstance.nearbyDelegate?.selectedNearbyContact(selectedPeer.displayName)
            })
        }
        
    }
    
    func browser(browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?)
    {
        if peerID.displayName != NearbyManager.sharedInstance.myPeerID.displayName
        {
            self.foundPeers.append(peerID)
            self.nearbyTableView.reloadData()
            
        }
    }
    
    // A nearby peer has stopped advertising.
    func browser(browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID)
    {
        NSLog("browser lost peer \(peerID)")
        
        for (index, aPeer) in self.foundPeers.enumerate()
        {
            
            if aPeer?.displayName == peerID.displayName {
                foundPeers.removeAtIndex(index)
                self.nearbyTableView.reloadData()
                break
            }
        }
    }
    
    // Browsing did not start due to an error
    func browser(browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: NSError)
    {
        print(error.localizedDescription)
    }
    
    
    func startBrowsingForNearby()
    {
        if (self.nearbyServiceBrowser == nil)
        {
            
            self.nearbyServiceBrowser = MCNearbyServiceBrowser(peer: NearbyManager.sharedInstance.myPeerID, serviceType: NearbyManager.sharedInstance.serviceType)
            
        }
        self.nearbyServiceBrowser?.delegate = self
        self.nearbyServiceBrowser?.startBrowsingForPeers()
    }
    
    func stopBrowsingForNearbyContacts()
    {
        self.foundPeers.removeAll(keepCapacity: true)
        NearbyManager.sharedInstance.nearbyDelegate = nil
        if (self.nearbyServiceBrowser != nil)
        {
            self.nearbyServiceBrowser?.delegate = nil
            self.nearbyServiceBrowser?.stopBrowsingForPeers()
            self.nearbyServiceBrowser = nil
        }
    }
    
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem)
    {
        self.stopBrowsingForNearbyContacts()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}