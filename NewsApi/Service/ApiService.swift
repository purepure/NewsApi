//
//  ApiService.swift
//  NewsApi
//
//  Created by conga phucanh on 10/28/17.
//  Copyright © 2017 conga phucanh. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

class ApiService: NSObject {
    static let realm = try! Realm()

    static func setup(){
        Realm.Configuration.defaultConfiguration.deleteRealmIfMigrationNeeded = true
    }

    static func getSource(_ source : String)->String{
        return Consts.NewsApi.BaseUrl + source + Consts.NewsApi.Order + "&apiKey=" + Consts.NewsApi.ApiKey
    }

    static func requestNews(_ source : String, _ callback:@escaping ([Article]?)->Void, _ error:@escaping (Error?)->Void){
        var articles = [Article]()
        let url = getSource(source)

        let req = Alamofire.request(url)
        req.responseJSON { (response) in
            if response.error == nil {
                if let data = response.result.value as? [String : Any]{
                    let source = data["source"] as! String
                    let articleData = data["articles"] as! [[String : Any]]
                    for item in articleData {
                        let article = Article(item)
                        article.source = source
                        articles.append(article)

                        try! realm.write() {
                            self.realm.add(article, update: true)
                        }
                    }
                    callback(articles)
                }
            }else{
                error(response.error)
            }
        }
    }

    //only support a source: BBC for now.
    static func loadCachedNews(_ source : String) -> [Article]{
        let data = realm.objects(Article.self).filter("source = '\(source)'")
        return data.map({$0})
//        var articles = [Article]()
//        for item in data{
//            articles.append(item)
//        }
//
//        return articles
    }

    static func clearCache(){
        try! realm.write({
            realm.deleteAll()
        })
    }
}
