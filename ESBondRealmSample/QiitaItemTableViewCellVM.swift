//
//  QiitaItemTableViewCellVM.swift
//  ESBondRealmSample
//
//  Created by Osamu Nishiyama on 2016/09/23.
//  Copyright © 2016年 ever sense. All rights reserved.
//

import Foundation
import RealmSwift
import Bond
import Alamofire
import AlamofireImage

class QiitaItemTableViewCellVM {
    let itemId = Observable<String?>("")
    let title = Observable<String?>("")
    let userId = Observable<String?>("")
    let userImage = Observable<UIImage?>(nil)
    let isNotFavorited = Observable<Bool>(true)

    var userImageURL : NSURL? = nil
    var url : NSURL? = nil
    var qiitaItem : QiitaItemRealm? = nil

    init(qiitaItem : QiitaItemRealm?){
        self.qiitaItem = qiitaItem
        self.render()

        qiitaItem?.favorite.addNotificationBlock({ [weak self] (changes: RealmCollectionChange) in
            
            func updateIsNotBookmarked(){
                self?.isNotFavorited.value = !(self?.qiitaItem?.favorite.count > 0)
            }
            
            switch changes {
            case .Initial(_):
                updateIsNotBookmarked()
                break
                
            case .Update(_, _, _, _):
                updateIsNotBookmarked()
                break
                
            case .Error(let error):
                fatalError("\(error)")
                break
            }
            
        })
    }
    
    func render(){
        self.itemId.value = qiitaItem?.id
        self.title.value = qiitaItem?.title
        self.userId.value = qiitaItem?.user?.id
        
        if let profile_imag_url = qiitaItem?.user?.profile_image_url {
            self.userImageURL = NSURL(string: profile_imag_url)
        }else{
            self.userImageURL = nil
        }
        
        if let qiitaUrl = qiitaItem?.url {
            self.url = NSURL(string: qiitaUrl)
        }else{
            self.url = nil
        }

    }
    
    func fetchImageIfNeeded(){
        if self.userImage.value != nil {
            // already have photo
            return
        }
        guard let userImageURL = self.userImageURL else {
            return
        }
        
        let downloadTask = NSURLSession.sharedSession().downloadTaskWithURL(userImageURL) {
            [weak self] location, response, error in
            if let location = location {
                if let data = NSData(contentsOfURL: location) {
                    if let image = UIImage(data: data) {
                        dispatch_async(dispatch_get_main_queue()) {
                            // this will automatically update photo in bonded image view
                            self?.userImage.value = image
                            return
                        }
                    }
                }
            }
        }
        downloadTask.resume()
    }
}