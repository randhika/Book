//
//  UserViewController.swift
//  Book
//
//  Created by 金波 on 16/1/18.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit

class UserViewController: UITableViewController {
    @IBOutlet weak var imageViewAvatar: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelAddress: UILabel!

    @IBOutlet weak var labelID: UILabel!
    @IBOutlet weak var labelAlt: UILabel!
    @IBOutlet weak var labelCreated: UILabel!
    @IBOutlet weak var labelDesc: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageViewAvatar.setImageWith(User.sharedUser.avatar)
        labelName.text = User.sharedUser.name
        labelAddress.text = User.sharedUser.loc_name
        labelID.text = User.sharedUser.uid
        labelAlt.text = User.sharedUser.alt
        labelCreated.text = User.sharedUser.created
        labelDesc.text = User.sharedUser.desc
        
        tableView.tableFooterView = UIView()
    }

}
