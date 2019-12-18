//
//  HomePresenter.swift
//  GitRepo
//
//  Created by Ibram on 12/13/19.
//  Copyright © 2019 Ibram. All rights reserved.
//

import UIKit
class HomePreenter{
    var delegateObj:HomePresenterDelegate!
    func GetReposData(Count:Int){
        Loading.shared.show()
        Network.shared.makeHttpRequest(model: [RepoModel](), method: .get, APIName: "", parameters: ["per_page":"\(Count)"]) { (result) in
            DispatchQueue.main.async {
                Loading.shared.hide() // stop loading indicator
            }
            switch result {
            case .success(let response):
                self.delegateObj.LoadRepoSuccessfully(Repos: response)
            case .failure(let error):
                self.delegateObj.FailedLoading(Error : error)
            }
        }
    }
}
