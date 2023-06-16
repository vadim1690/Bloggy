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
    
    @IBOutlet weak var progressCircle: UIActivityIndicatorView!
    @IBOutlet weak var addButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        tableVIewBlogs.dataSource = self
        tableVIewBlogs.delegate = self
        addButton.layer.cornerRadius = 15
        addButton.layer.shadowColor = UIColor.black.cgColor
        addButton.layer.shadowOpacity = 0.5
        addButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        addButton.layer.shadowRadius = 4
    

        tableVIewBlogs.isHidden = true
        progressCircle.isHidden = false
        FirebaseManager.shared.readBlogs { blogs in
            self.blogs = blogs
            self.tableVIewBlogs.isHidden = false
            self.progressCircle.isHidden = true
            self.tableVIewBlogs.reloadData()
//            for blog in blogs {
//                print("Blog ID: \(blog.id ?? "")")
//                print("Title: \(blog.title ?? "")")
//                // Access other properties of the Blog object as needed
//            }
        }
        
        
        
    }
    
    
    @IBAction func addPostClicked(_ sender: Any) {
        let newBlogViewController = storyboard?.instantiateViewController(withIdentifier: "NewBlogViewController") as? NewBlogViewController
        navigationController?.pushViewController(newBlogViewController!, animated:true)
        
    
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
        selectedBlog.viewers = selectedBlog.viewers! + 1
        FirebaseManager.shared.updateBlog(blog: selectedBlog)
        blogViewController?.blog = selectedBlog
        navigationController?.pushViewController(blogViewController!, animated:true)
    }


}

