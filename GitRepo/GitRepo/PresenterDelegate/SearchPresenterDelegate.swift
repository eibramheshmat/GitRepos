//
//  SearchPresenterDelegate.swift
//  GitRepo
//
//  Created by Ibram on 12/14/19.
//  Copyright © 2019 Ibram. All rights reserved.
//

import UIKit
protocol SearchPresenterDelegate {
    func LoadAfterSearch(Repos:[RepoModel])
}
