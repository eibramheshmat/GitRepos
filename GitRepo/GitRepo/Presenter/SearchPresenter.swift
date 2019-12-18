//
//  SearchPresenter.swift
//  GitRepo
//
//  Created by Ibram on 12/14/19.
//  Copyright © 2019 Ibram. All rights reserved.
//

import UIKit
class SearchPresenter{
 var delegateObj:SearchPresenterDelegate!
    func GetReposDataAfterSearch(Count:Int){
        Loading.shared.show()
        Network.shared.makeHttpRequest(model: [RepoModel](), method: .get, APIName: "", parameters: ["per_page":"\(Count)"]) { (result) in
            DispatchQueue.main.async {
                Loading.shared.hide() // stop loading indicator
            }
            switch result {
            case .success(let response):
                self.delegateObj.LoadAfterSearch(Repos: response)
            case .failure(let error):
                print(error)
            }
        }
    }
}

