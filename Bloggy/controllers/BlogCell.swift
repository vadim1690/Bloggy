//
//  BlogCell.swift
//  Bloggy
//
//  Created by Student29 on 13/06/2023.
//

import Foundation
import UIKit

protocol CallBack_BlogCell {
    func blogClicked(position: Int)
}

 class BlogCell: UITableViewCell {
    @IBOutlet weak var blogTitleLabel: UILabel!
    @IBOutlet weak var blogReadTimeLabel: UILabel!
    @IBOutlet weak var blogViewersLabel: UILabel!
    
    
    var delegate: CallBack_BlogCell?
    var position: Int?
    
    @IBAction func likedClicked(_ sender: Any) {
        print("likedClicked")
        delegate?.blogClicked(position: position ?? 0)
    }
    
}
