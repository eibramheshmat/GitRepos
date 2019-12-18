//
//  ViewController.swift
//  GitRepo
//
//  Created by Ibram on 12/13/19.
//  Copyright © 2019 Ibram. All rights reserved.
//

import UIKit
import CoreData
import Kingfisher
import SafariServices
import NotificationCenter
class ViewController: UIViewController , HomePresenterDelegate , SearchPresenterDelegate {
    
    //delegate method after search
    func LoadAfterSearch(Repos: [RepoModel]) {
        RepoList.removeAll()
        RepoList = Repos
    }
    //delegate method for get repos
    func LoadRepoSuccessfully(Repos: [RepoModel]) {
        RepoList.removeAll()
        RepoList = Repos
        DispatchQueue.main.async {
            //for cash data
            let counter = self.RepoList.count - 1
            if counter >= 0 {
                for n in 0 ... counter {
                    if #available(iOS 13.0, *) {
                        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                        let newHistory = NSEntityDescription.insertNewObject(forEntityName: "Repos", into: context)
                        newHistory.setValue("\(self.RepoList[n].name ?? "")", forKey: "name")
                        do {
                            try context.save()
                        }catch{
                            print(error)
                        }
                    }
                }
            }
            
            self.RepoTableView.reloadData()
        }
    }
    
    func FailedLoading(Error: ServiceError) {
        print("Failed")
    }
    
    var PageCounter = 10
    var refreshControl = UIRefreshControl()
    var hourTime : Timer?
    var RepoList = [RepoModel]()
    var searchedRepos : [RepoModel] = []
    var presenterObj = HomePreenter()
    var presenterSearchObj = SearchPresenter()
    var RepoCash:[Repos] = []
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var RepoTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenterSearchObj.delegateObj = self
        presenterObj.delegateObj = self
        presenterObj.GetReposData(Count: PageCounter)
        searchBar.backgroundImage = UIImage()
        //Refresh
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        self.RepoTableView.addSubview(self.refreshControl)
        //Notification Authorization
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
                if granted {
                    print("Authorization")
                } else {
                    print("No Authorization")
                }
            }
        } else {
            // Fallback on earlier versions
        }
        //Notification
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            let content = UNMutableNotificationContent()
            content.title = "Data Refreshed"
            content.body = "Cash data are refreshed."
            content.categoryIdentifier = "alarm"
            content.userInfo = ["customData": "fizzbuzz"]
            content.sound = UNNotificationSound.default
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3600, repeats: true)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
            self.hourTime = Timer.scheduledTimer(timeInterval: 3600, target: self, selector: #selector(self.HourAction), userInfo: nil, repeats: true)
        } else {
            // Fallback on earlier versions
        }
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    @objc func refresh(sender: Any) {
        // Code to refresh table view
        self.refreshControl.beginRefreshing()
        PageCounter = 10
        presenterObj.GetReposData(Count: PageCounter)
        self.refreshControl.endRefreshing()
    }
    @objc func HourAction() {
        PageCounter = 10
        self.presenterObj.GetReposData(Count: PageCounter)
    }
}

//MARK:- UISearchBar
extension ViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked( _ searchBar: UISearchBar)
    {
        self.dismissKeyboard()
        searchedRepos.removeAll()
        let counter = RepoList.count - 1
        if counter > 0 {
            for n in 0 ... counter{
                if (RepoList[n].name?.contains(searchBar.text ?? ""))!{
                    searchedRepos.append(RepoList[n])
                }
            }
            RepoList = searchedRepos
            DispatchQueue.main.async {
                self.RepoTableView.reloadData()
                self.presenterSearchObj.GetReposDataAfterSearch(Count: self.PageCounter)
            }
        }
        
    }
}

//MARK:- UITableView Data
extension ViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if RepoList.count > 0 {
            return RepoList.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        RepoTableView.register(UINib(nibName: "RepoTableViewCell", bundle: nil), forCellReuseIdentifier: "RepoTableViewCell")
        let cell = RepoTableView.dequeueReusableCell(withIdentifier: "RepoTableViewCell", for: indexPath) as! RepoTableViewCell
        if RepoList.count > 0{
            cell.repoName.text = RepoList[indexPath.row].name
            cell.repoDescrip.text = RepoList[indexPath.row].description
            cell.repoOwner.text = RepoList[indexPath.row].owner.login
            cell.repoImage.kf.setImage(with: URL(string: RepoList[indexPath.row].owner.avatar_url ?? ""))
            if RepoList[indexPath.row].fork == true{
                cell.mainView.layer.backgroundColor = UIColor.white.cgColor
            }else{
                cell.mainView.layer.backgroundColor = UIColor.systemGreen.cgColor
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let more = UITableViewRowAction(style: .normal, title: "SourceCode") { action, index in
            let alert = UIAlertController(title: "SourceCode", message: "Choose where to go", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Repository", style: .default, handler: {(action:UIAlertAction!) in
                if let url = URL(string:"\(self.RepoList[index.row].html_url ?? "")") {
                    if #available(iOS 11.0, *) {
                        let config = SFSafariViewController.Configuration()
                        config.entersReaderIfAvailable = true
                        let vc = SFSafariViewController(url: url, configuration: config)
                        self.present(vc, animated: true)
                    } else {
                        // Fallback on earlier versions
                    }
                }
            }))
            alert.addAction(UIAlertAction(title: "Owner", style: .default, handler: {(action:UIAlertAction!) in
                if let url = URL(string:"\(self.RepoList[index.row].owner.html_url ?? "")") {
                    if #available(iOS 11.0, *) {
                        let config = SFSafariViewController.Configuration()
                        config.entersReaderIfAvailable = true
                        let vc = SFSafariViewController(url: url, configuration: config)
                        self.present(vc, animated: true)
                    } else {
                        // Fallback on earlier versions
                    }
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        more.backgroundColor = .lightGray
        return [more]
    }
}

//MARK:- UITableView Design
extension ViewController {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // to know when reach the end of table to make Pagination
        if indexPath.row + 1 == PageCounter {
            //call more items
            PageCounter += 10
            presenterObj.GetReposData(Count: PageCounter)
        }
    }
}
