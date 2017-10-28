//
//  Articles.swift
//  NewsApi
//
//  Created by conga phucanh on 10/28/17.
//  Copyright © 2017 conga phucanh. All rights reserved.
//
import Realm
import RealmSwift

class Article: Object {
    @objc dynamic var source : String? = ""
    @objc dynamic var author : String? = ""
    @objc dynamic var title : String? = ""
    @objc dynamic var des : String? = ""
    @objc dynamic var url : String? = ""
    @objc dynamic var urlToImage : String? = ""
    @objc dynamic var publishedAt : String? = ""

    required init() {
        super.init()
    }

    public init(_ json : [String: Any]){
        super.init()

        author = json["author"] as? String
        title = json["title"] as? String
        des = json["description"] as? String
        url = json["url"] as? String
        urlToImage = json["urlToImage"] as? String
        publishedAt = json["publishedAt"] as? String
    }

    override class func primaryKey()->String?{
        return "url"
    }

    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        //fatalError("init(realm:schema:) has not been implemented")
        super.init(realm: realm, schema: schema)
    }

    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
        //fatalError("init(value:schema:) has not been implemented")
    }

}
