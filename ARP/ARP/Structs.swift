//
//  Structs.swift
//  ARP
//
//  Created by MHspitta on 01/04/2019.
//  Copyright © 2019 Michael Hu. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

// Structs

struct User: Codable {
    var name: String!
    var password: String!
    var uid: String!
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String:AnyObject]
        
        name = snapshotValue["user_name"] as! String
        password = snapshotValue["password"] as! String
        uid = snapshotValue["uid"] as! String
    }
}

struct Plant: Codable {
    var id: String!
    var name: String!
    var location: String!
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String:AnyObject]
        
        id = (snapshotValue["plantID"] as! String)
        name = (snapshotValue["plantName"] as! String)
        location = (snapshotValue["location"] as! String)
    }
}

struct PH: Codable {
    var ph: String!
    var optimumPh: String!
    var time: String!
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String:AnyObject]
        
        ph = snapshotValue["PH"] as! String
        optimumPh = snapshotValue["optimumPH"] as! String
        time = snapshotValue["time"] as! String
    }
}

struct Growth: Codable {
    var growth: String!
    var normGrowth: String!
    var time: String!
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String:AnyObject]
        
        growth = (snapshotValue["growth"] as! String)
        normGrowth = (snapshotValue["normalGrowth"] as! String)
        time = (snapshotValue["time"] as! String)
    }
}

struct Yield: Codable {
    var yield: String!
    var expYield: String!
    var time: String!
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String:AnyObject]
        
        yield = (snapshotValue["yield"] as! String)
        expYield = (snapshotValue["expectedYield"] as! String)
        time = (snapshotValue["time"] as! String)
    }
}

struct Comment: Codable {
    var comment: String!
    var time: String!
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String:AnyObject]
        
        comment = (snapshotValue["comment"] as! String)
        time = (snapshotValue["time"] as! String)
    }
}

struct GLobalId {
    static var id = String()
}

//struct Id: Codable {
//    var id: String!
//
//    init(snapshot: DataSnapshot) {
//        let snapshotValue = snapshot.value as! [String:AnyObject]
//
//        id = (snapshotValue["id"] as! String)
//    }
//}

struct Uid: Codable {
    var id: String!
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String:AnyObject]
        
        id = (snapshotValue["uid"] as! String)
    }
}

