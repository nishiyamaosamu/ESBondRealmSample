//
//  News.swift
//  ESBondRealmSample
//
//  Created by 江上真人 on 2016/10/12.
//  Copyright © 2016年 ever sense. All rights reserved.
//

import Foundation
import RealmSwift
import Alamofire
import SwiftyJSON

class News: NSObject {
    static let QIITA_ITEMS_URL = "https://qiita.com/api/v2/items"
    
    static func initializeObject(id: String, item: QiitaItemRealm, user: QiitaUserRealm) -> NewsRealm {
        let news = NewsRealm()
        item.user = user
        news.id = id
        news.qiitaItem = item
        return news
    }
    
    static func getAll() -> Results<NewsRealm>{
        let realm = try! Realm()
        return realm.objects(NewsRealm.self).sorted("id", ascending: false)
    }

    static func fetch() {
        Alamofire.request(.GET, QIITA_ITEMS_URL)
            .responseJSON { response in
                guard let res = response.result.value else {
                    return
                }
                
                let realm = try! Realm()
                let jsonResponse = JSON(res)
                
                realm.beginWrite()
                    // 削除
                    let news = realm.objects(NewsRealm.self)
                    realm.delete(news)

                    // 作成
                    jsonResponse.forEach { (_, json) in
                        let item = QiitaItem.initializeObject(
                            json["id"].stringValue,
                            title: json["title"].stringValue,
                            url: json["url"].stringValue
                        )
                        
                        let user = QiitaUser.initializeObject(
                            json["user"]["id"].stringValue,
                            profile_image_url: json["user"]["profile_image_url"].stringValue
                        )
                        
                        
                        let news = self.initializeObject(item.id, item: item, user: user)
                        
                        realm.add(news, update: true)
                    }
                try! realm.commitWrite()
        }
    }
    
    static func updateTitle(qiitaItem: QiitaItemRealm, title: String){
        let realm = try! Realm()
        try! realm.write {
            qiitaItem.title = title
        }
    }
}