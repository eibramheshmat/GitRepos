//
//  HomePresenterDelegate.swift
//  GitRepo
//
//  Created by Ibram on 12/13/19.
//  Copyright © 2019 Ibram. All rights reserved.
//

import UIKit
protocol HomePresenterDelegate {
    func LoadRepoSuccessfully(Repos:[RepoModel])
    func FailedLoading(Error:ServiceError)
}
