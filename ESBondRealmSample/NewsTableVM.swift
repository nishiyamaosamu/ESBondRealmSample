//
//  NewsTableVM.swift
//  ESBondRealmSample
//
//  Created by Osamu Nishiyama on 2016/09/26.
//  Copyright © 2016年 ever sense. All rights reserved.
//

import Foundation
import RealmSwift
import Bond

class NewsTableVM {
    var qiitaItemTableViewCellViewVMs = ObservableArray<ObservableArray<QiitaItemTableViewCellVM>>()
    var notificationToken: NotificationToken?
    
    init(){
        let news = News.getAll()
        notificationToken = news.addNotificationBlock( { [weak self] (changes: RealmCollectionChange) in
            switch changes {
            case .Initial(_):
                let tmpArray = ObservableArray<QiitaItemTableViewCellVM>()
                news.forEach {(new) -> Void in
                    let qiitaItemCellViewModel = QiitaItemTableViewCellVM.init(qiitaItem: new.qiitaItem)
                    tmpArray.append(qiitaItemCellViewModel)
                }
                self?.qiitaItemTableViewCellViewVMs.append(tmpArray)
                break
                
            case .Update(let elements, let deletions, let insertions, let modifications):
                print(elements.count)
                print(deletions)
                print(insertions)
                print(modifications)
                
                
                deletions.reverse().forEach { deleteIndex in
                    if let arr = self?.qiitaItemTableViewCellViewVMs.first {
                        arr.removeAtIndex(deleteIndex)
                    }
                }
                insertions.forEach { insertIndex in
                    if let arr = self?.qiitaItemTableViewCellViewVMs.first {
                        let news = elements[insertIndex]
                        arr.insert(QiitaItemTableViewCellVM.init(qiitaItem: news.qiitaItem), atIndex: insertIndex)
                    }
                }
                modifications.forEach { modifiedIndex in
                    if let arr = self?.qiitaItemTableViewCellViewVMs.first {
                        if elements.indices.contains(modifiedIndex) && arr.indices.contains(modifiedIndex) {
                            let news = elements[modifiedIndex]
                            arr[modifiedIndex] = QiitaItemTableViewCellVM.init(qiitaItem: news.qiitaItem)
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
    
    func fetch(){
        News.fetch()
    }

    
    func toggleFavorite(item : QiitaItemTableViewCellVM){
        Favorite.toggleByItemId(item.itemId.value)
    }
    
}