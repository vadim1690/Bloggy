//
//  ViewController.swift
//  Bloggy
//
//  Created by Student28 on 13/06/2023.
//

import UIKit

class ViewController: UIViewController ,UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tableVIewBlogs:UITableView!
    
    var blogs: [Blog] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableVIewBlogs.dataSource = self
        tableVIewBlogs.delegate = self
        
//
//        let blog = Blog(
//            title: "Example Blog",
//            imageURL: "https://example.com/image.jpg",
//            text: "Lorem ipsum dolor sit amet...",
//            viewers: 100,
//            creationDate: Date(),
//            location: (latitude: 37.123, longitude: -122.456),
//            readTime: 5
//        )
//        FirebaseManager.shared.saveBlog(blog:blog)
    
    
        
        FirebaseManager.shared.readBlogs { blogs in
            self.blogs = blogs
            self.tableVIewBlogs.reloadData()
//            for blog in blogs {
//                print("Blog ID: \(blog.id ?? "")")
//                print("Title: \(blog.title ?? "")")
//                // Access other properties of the Blog object as needed
//            }
        }
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let blog = blogs[indexPath.row]
//        let cell = tableVIewBlogs.dequeueReusableCell(withIdentifier: "blogCell") as! BlogCell
//        cell.blogTitleLabel.text = blog.title
//        cell.blogViewersLabel.text = String(blog.viewers!)
//        cell.blogReadTimeLabel.text = "\(blog.readTime ?? 0) min read"
//        return cell
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "blogCell", for: indexPath) as! BlogCell
        let blog = blogs[indexPath.row]
        cell.configure(with: blog)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBlog = blogs[indexPath.row]
        // Perform any action you want with the selected blog
        print("Selected blog: \(selectedBlog.title ?? "")")
        let blogViewController = storyboard?.instantiateViewController(withIdentifier: "BlogViewController") as? BlogViewController
        blogViewController?.blog = selectedBlog
        navigationController?.pushViewController(blogViewController!, animated:true)
    }


}

