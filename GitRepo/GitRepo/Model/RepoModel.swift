//
//  RepoModel.swift
//  GitRepo
//
//  Created by Ibram on 12/13/19.
//  Copyright © 2019 Ibram. All rights reserved.
//

import UIKit
struct RepoModel:Codable {
    var name : String?
    var description : String?
    var html_url : String? //repo URL
    var fork : Bool?
    var owner = ownerObj()
}
struct ownerObj:Codable {
    var login : String?
    var avatar_url : String? //avater img
    var html_url : String? //owner URL
}
