//
//  MasterViewController.swift
//  NewsApi
//
//  Created by conga phucanh on 10/28/17.
//  Copyright © 2017 conga phucanh. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import MBProgressHUD
import RealmSwift

class MasterViewController: UITableViewController {
    var detailViewController: DetailViewController? = nil
    var articles = [Article]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //navigationItem.leftBarButtonItem = editButtonItem

        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }

        addRefreshController()

        ApiService.setup()
        requestData()
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let article = articles[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.article = article
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
        let article = articles[indexPath.row]

        let title = cell.viewWithTag(101) as! UILabel
        title.text = article.title

        let description = cell.viewWithTag(102) as! UILabel
        description.text = article.des

        let time = cell.viewWithTag(103) as! UILabel
        time.text = article.publishedAt

        let thumb = cell.viewWithTag(100) as! UIImageView
        if article.urlToImage != nil {
            thumb.sd_setImage(with: URL(string: article.urlToImage!), placeholderImage: UIImage(named: "Thumb"))
        }else{
            thumb.image = UIImage(named: "Thumb")
        }

        return cell
    }

    //MARK: AppFlow
    func requestData(){
        Utils.showLoader()
        MBProgressHUD.showAdded(to: self.view, animated: true)

        loadDataFromNetwork()
    }

    func checkNetworking(){
        let manager = NetworkReachabilityManager(host: Consts.NewsApi.BaseUrl)
        manager?.listener = { status in
            print("Network Status Changed: \(status)")
        }
        manager?.startListening()
    }

    func loadDataFromCache(){
        articles = ApiService.loadCachedNews(Consts.NewsApi.SourceBBC)
        self.tableView.reloadData()
    }

    func loadDataFromNetwork(){
        ApiService.requestNews(Consts.NewsApi.SourceBBC, { (data) in
            MBProgressHUD.hide(for: self.view, animated: true)

            self.articles = data!
            self.tableView.reloadData()
        }) { (error) in
            MBProgressHUD.hide(for: self.view, animated: true)

//            let alert = Utils.showMessage(self, "Whoop", "Something went wrong. Please try again later")
//            alert.addAction(UIAlertAction(title: "Use Cache", style: UIAlertActionStyle.destructive, handler: { (action) in
//                self.loadDataFromCache()
//            }))
//            alert.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.destructive, handler: { (action) in
//                self.requestData()
//            }))

            self.loadDataFromCache()
        }
    }

    func addRefreshController(){
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
    }

    @objc func refresh(_ sender: Any) {
        loadDataFromNetwork()

        self.refreshControl?.endRefreshing()
    }
}

