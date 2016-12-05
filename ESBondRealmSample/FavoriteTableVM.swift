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

// お気に入りのQiitaItemTableViewCellVMを保持するcollection
class FavoriteTableVM {
    var qiitaItemTavleViewCellVMs = ObservableArray<ObservableArray<QiitaItemTableViewCellVM>>()
    var notificationToken: NotificationToken?
    
    init(){
        let favorites = Favorite.getAll()
        
        // Realmからの変更通知を受け取って、qiitaItemTableViewCellViewVMsを変更することでViewの表示を変える
        // Model => View
        notificationToken = favorites.addNotificationBlock( { [weak self] (changes: RealmCollectionChange) in
            switch changes {
            case .Initial(_):
                let tmpArray = ObservableArray<QiitaItemTableViewCellVM>()
                favorites.forEach { (favorite) -> Void in
                    let qiitaItemCellViewModel = QiitaItemTableViewCellVM.init(qiitaItem: favorite.qiitaItem)
                    tmpArray.append(qiitaItemCellViewModel)
                }
                self?.qiitaItemTavleViewCellVMs.append(tmpArray)
                break
                
            case .Update(let elements, let deletions, let insertions, let modifications):
                deletions.reverse().forEach { deleteIndex in
                    if let arr = self?.qiitaItemTavleViewCellVMs.first {
                        arr.removeAtIndex(deleteIndex)
                    }
                }
                
                insertions.forEach { insertIndex in
                    if let arr = self?.qiitaItemTavleViewCellVMs.first {
                        let favorite = elements[insertIndex]
                        arr.insert(QiitaItemTableViewCellVM.init(qiitaItem: favorite.qiitaItem), atIndex: insertIndex)
                    }
                }
                
                modifications.forEach { modifiedIndex in
                    if let arr = self?.qiitaItemTavleViewCellVMs.first {
                        if elements.indices.contains(modifiedIndex) && arr.indices.contains(modifiedIndex) {
                            let favorite = elements[modifiedIndex]
                            arr[modifiedIndex] = QiitaItemTableViewCellVM.init(qiitaItem: favorite.qiitaItem)
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
    
    // ViewControllerでユーザーのイベントを受け取って下記の関数が叩かれることで、Modelにデータ変更を依頼する
    // View => Model
    func removeFavorite(item : QiitaItemTableViewCellVM){
        Favorite.deleteByQiitaItemId(item.itemId.value)
    }
}

