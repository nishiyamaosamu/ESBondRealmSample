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
    let title = Observable<String?>("")
    let userId = Observable<String?>("")
    let userImage : Observable<UIImage?>
    let isNotFavorited : Observable<Bool>

    let userImageURL : NSURL?
    let url : NSURL?
    let qiitaItem : QiitaItem?
    let favoriteResults : Results<Favorite>
    var token : NotificationToken?

    init(qiitaItem : QiitaItem?){
        self.title.value = qiitaItem?.title
        self.userId.value = qiitaItem?.user?.id
        self.userImage = Observable<UIImage?>(nil) // initially no image

        if qiitaItem?.user?.profile_image_url != nil {
            self.userImageURL = NSURL(string: qiitaItem!.user!.profile_image_url)!
        }else{
            self.userImageURL = nil
        }
        
        if qiitaItem?.url != nil {
            self.url = NSURL(string: qiitaItem!.url)
        }else{
            self.url = nil
        }
        self.qiitaItem = qiitaItem
        
        self.isNotFavorited = Observable<Bool>(true)
        let realm = try! Realm()
        self.favoriteResults = realm.objects(Favorite.self).filter("id = %@", self.qiitaItem!.id)
        
        token = favoriteResults.addNotificationBlock({ [weak self] (changes: RealmCollectionChange) in
            func updateIsNotBookmarked(){
                self?.isNotFavorited.value = !(self?.favoriteResults.count > 0)
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
    
    func fetchImageIfNeeded(){
        if self.userImage.value != nil {
            // already have photo
            return
        }
        if let userImageURL = self.userImageURL {
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
    
    
}