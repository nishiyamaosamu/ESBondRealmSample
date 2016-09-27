//
//  FavoriteTableVM.swift
//  ESBondRealmSample
//
//  Created by Osamu Nishiyama on 2016/09/26.
//  Copyright © 2016年 ever sense. All rights reserved.
//

import Foundation
import RealmSwift
import Bond

class FavoriteTableVM {
    var articleItems = ObservableArray<ObservableArray<QiitaItemTableViewCellVM>>()
    var notificationToken: NotificationToken?
    
    init(){
        let realm = try! Realm()
        let newsResults = realm.objects(Favorite.self).sorted("createdAt")
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
                _ = deletions.reverse().map {
                    if let arr = self?.articleItems.first {
                        arr.removeAtIndex($0)
                    }
                }
                _ = insertions.map {
                    if let arr = self?.articleItems.first {
                        let favorite = elements[$0]
                        arr.insert(QiitaItemTableViewCellVM.init(qiitaItem: favorite.qiitaItem), atIndex: $0)
                    }
                }
                _ = modifications.map {
                    if let arr = self?.articleItems.first {
                        if elements.indices.contains($0) && arr.indices.contains($0) {
                            let favorite = elements[$0]
                            arr[$0] = QiitaItemTableViewCellVM.init(qiitaItem: favorite.qiitaItem)
                        }
                    }
                }
                break
            case .Error(let error):
                fatalError("\(error)")
                break
            }
        })
    }
    
    func removeFavorite(item : QiitaItemTableViewCellVM){
        let realm = try! Realm()
        if let favorite = item.favoriteResults.first {
            try! realm.write({
                realm.delete(favorite)
            })
        }    }
    
}

