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
        let blogRef = Database.database().reference().child("blogs").childByAutoId()
        
        blogs = Blog().mockData()
        tableVIewBlogs.dataSource = self
        
        
        let blog = Blog(
            title: "Example Blog",
            imageURL: "https://example.com/image.jpg",
            text: "Lorem ipsum dolor sit amet...",
            viewers: 100,
            creationDate: Date(),
            location: (latitude: 37.123, longitude: -122.456),
            readTime: 5
        )
        blogRef.setValue(blog.toDictionary())
        
        
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

