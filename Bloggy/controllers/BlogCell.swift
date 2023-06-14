//
//  BlogCell.swift
//  Bloggy
//
//  Created by Student28 on 13/06/2023.
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
    
    
    var position: Int?
    
     func configure(with blog: Blog) {
         blogTitleLabel.text = blog.title
         blogViewersLabel.text = String(blog.viewers ?? 0)
         blogReadTimeLabel.text = "\(blog.readTime ?? 0) min read"
     }
    
}
