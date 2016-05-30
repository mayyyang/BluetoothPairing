//
//  NearbyTableViewCell.swift
//  BTEPairing
//
//  Created by Yang, May on 2/12/16.
//  Copyright © 2016 Yang, May. All rights reserved.
//

import UIKit
import Foundation

class NearbyTableViewCell: UITableViewCell {
    
    func setupNearbyPeer(peer:String)
    {
        self.textLabel!.text = peer
    }
}
