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
        
        // イベントを受け取って、vmに通知する
        // ここでは、qiitaItemTableViewCellViewVMsの数が減ったり増えたりを検知できる
        self.vm.qiitaItemTableViewCellViewVMs.bindTo(tableView) { indexPath, dataSource, tableView in
            let cell = tableView.dequeueReusableCellWithIdentifier(self.cellReuseIdentifier, forIndexPath: indexPath) as! QiitaItemTableViewCell
            let item = dataSource[indexPath.section][indexPath.row]
            cell.setCell(item)
            return cell
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vm.qiitaItemTableViewCellViewVMs.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = self.vm.qiitaItemTableViewCellViewVMs[indexPath.section][indexPath.row]
        self.vm.toggleFavorite(item)
    }
    
    @IBAction func tappedReload(sender: UIBarButtonItem) {
        self.vm.fetch()
    }
    
    @IBAction func tappedChange(sender: UIBarButtonItem) {
        self.vm.updateTitle("タイトル書き換え")
    }
}
