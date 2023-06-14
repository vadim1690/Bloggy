//
//  ViewController.swift
//  Bloggy
//
//  Created by Student29 on 13/06/2023.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
class ViewController: UIViewController ,UITableViewDataSource{
    
    @IBOutlet weak var tableVIewBlogs:UITableView!
    
    var blogs: [Blog] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        blogs = Blog().mockData()
        tableVIewBlogs.dataSource = self
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let blog = blogs[indexPath.row]
        let cell = tableVIewBlogs.dequeueReusableCell(withIdentifier: "blogCell") as! BlogCell
        cell.blogTitleLabel.text = blog.title
        cell.blogViewersLabel.text = String(blog.viewers!)
        cell.blogReadTimeLabel.text = "\(blog.readTime ?? 0) min read"
        return cell
    }


}
