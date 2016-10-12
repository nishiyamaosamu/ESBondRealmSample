//
//  NewsTableViewController.swift
//  ESBondRealmSample
//
//  Created by Osamu Nishiyama on 2016/09/23.
//  Copyright © 2016年 ever sense. All rights reserved.
//

import UIKit
import Bond
import RealmSwift

class NewsTableViewController: UITableViewController {

    var vm = NewsTableVM()
    let cellNib = UINib.init(nibName: "QiitaItemTableViewCell", bundle: nil)
    let cellReuseIdentifier = "QiitaItemTableViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = true
        self.tableView.registerNib(cellNib, forCellReuseIdentifier: cellReuseIdentifier)
        self.tableView.delegate = self

        self.vm.fetch()
        self.vm.qiitaItemTableViewCellViewVMs.bindTo(tableView) { indexPath, dataSource, tableView in
            let cell = tableView.dequeueReusableCellWithIdentifier(self.cellReuseIdentifier, forIndexPath: indexPath) as! QiitaItemTableViewCell
            let item = dataSource[indexPath.section][indexPath.row]
            item.title
                .bindTo(cell.title!.bnd_text)
                .disposeIn(cell.bnd_bag)
            item.userId
                .bindTo(cell.userId!.bnd_text)
                .disposeIn(cell.bnd_bag)
            item.userImage
                .bindTo(cell.userImageView.bnd_image)
                .disposeIn(cell.bnd_bag)
            item.fetchImageIfNeeded()
            item.isNotFavorited
                .bindTo(cell.favoritedMark.bnd_hidden)
                .disposeIn(cell.bnd_bag)
            return cell
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.vm.qiitaItemTableViewCellViewVMs.count
    }

    @IBAction func tappedReload(sender: UIBarButtonItem) {
        self.vm.fetch()
    }
    
    @IBAction func tappedChange(sender: UIBarButtonItem) {
        if let items = self.vm.qiitaItemTableViewCellViewVMs.first {
            let realm = try! Realm()
            for item in items {
                try! realm.write({
                    item.qiitaItem?.title = "タイトル書き換え"
                })
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = self.vm.qiitaItemTableViewCellViewVMs[indexPath.section][indexPath.row]
        self.vm.toggleFavorite(item)
    }
}
