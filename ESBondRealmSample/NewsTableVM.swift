//
//  NewsTableVM.swift
//  ESBondRealmSample
//
//  Created by Osamu Nishiyama on 2016/09/26.
//  Copyright © 2016年 ever sense. All rights reserved.
//

import Foundation
import RealmSwift
import Alamofire
import SwiftyJSON
import Bond

class NewsTableVM {
    var articleItems = ObservableArray<ObservableArray<QiitaItemTableViewCellVM>>()
    var notificationToken: NotificationToken?
    
    init(){
        let realm = try! Realm()
        let newsResults = realm.objects(News.self)
        try! realm.write({
            realm.delete(newsResults)
        })
        notificationToken = newsResults.addNotificationBlock( { [weak self] (changes: RealmCollectionChange) in
            
            switch changes {
            case .Initial(_):
                let tmpArray = ObservableArray<QiitaItemTableViewCellVM>()
                _ = newsResults.map {
                    let qiitaItemCellViewModel = QiitaItemTableViewCellVM.init(qiitaItem: $0.qiitaItem)
                    tmpArray.append(qiitaItemCellViewModel)
                }
                self?.articleItems.append(tmpArray)
                break
            case .Update(let elements, let deletions, let insertions, let modifications):
                print(elements.count)
                print(deletions)
                print(insertions)
                print(modifications)
                
                
                _ = deletions.reverse().map {
                    if let arr = self?.articleItems.first {
                        arr.removeAtIndex($0)
                    }
                }
                _ = insertions.map {
                    if let arr = self?.articleItems.first {
                        let news = elements[$0]
                        arr.insert(QiitaItemTableViewCellVM.init(qiitaItem: news.qiitaItem), atIndex: $0)
                    }
                }
                _ = modifications.map {
                    if let arr = self?.articleItems.first {
                        if elements.indices.contains($0) && arr.indices.contains($0) {
                            let news = elements[$0]
                            arr[$0] = QiitaItemTableViewCellVM.init(qiitaItem: news.qiitaItem)
                        }
                    }
                }
            case .Error(let error):
                fatalError("\(error)")
                break
            }
            })

    }
    
    func fetchNewsItems() {
        let requestUrl: String = "https://qiita.com/api/v2/items"
        Alamofire.request(.GET, requestUrl)
            .responseJSON { response in
                guard let res = response.result.value else {
                    return
                }
                let realm = try! Realm()
                let json = JSON(res)
                let newsResults = realm.objects(News.self)
                try! realm.write({
                    realm.delete(newsResults)
                })

                json.forEach { (_, json) in
                    let item = QiitaItem()
                    item.id = json["id"].stringValue
                    item.title = json["title"].stringValue
                    item.url = json["url"].stringValue
                    item.user = QiitaUser()
                    item.user?.id = json["user"]["id"].stringValue
                    item.user?.profile_image_url = json["user"]["profile_image_url"].stringValue
                    let news = News()
                    news.id = item.id
                    news.qiitaItem = item
                    try! realm.write {
                        realm.add(news, update: true)
                    }
                }
        }
    }
    
    func addOrRemoveFavorite(item : QiitaItemTableViewCellVM){
        let realm = try! Realm()
        if let favorite = item.favoriteResults.first {
            try! realm.write({
                realm.delete(favorite)
            })
        }else{
            let favorite = Favorite()
            favorite.id = item.qiitaItem!.id
            favorite.qiitaItem = item.qiitaItem
            favorite.createdAt = NSDate()
            try! realm.write({
                realm.add(favorite, update: true)
            })
        }
    }
    
}