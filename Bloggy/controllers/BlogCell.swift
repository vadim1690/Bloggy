//
//  BlogCell.swift
//  Bloggy
//
//  Created by Student28 on 13/06/2023.
//

import Foundation
import UIKit
import Kingfisher

 class BlogCell: UITableViewCell {
    @IBOutlet weak var blogTitleLabel: UILabel!
    @IBOutlet weak var blogReadTimeLabel: UILabel!
    @IBOutlet weak var blogViewersLabel: UILabel!
    
     @IBOutlet weak var blogImage: UIImageView!
     
    
    var position: Int?
    
     func configure(with blog: Blog) {
         blogTitleLabel.text = blog.title
         blogViewersLabel.text = String(blog.viewers ?? 0)
         blogReadTimeLabel.text = "\(blog.readTime ?? 0) min read"
         
         
         
         let url = URL(string: blog.imageURL ?? "")
         blogImage.kf.setImage(with: url, placeholder: UIImage(named: "ImagePlaceholder"))
         
     }
    
}
