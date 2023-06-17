//
//  ViewController.swift
//  Bloggy
//
//  Created by Student28 on 13/06/2023.
//

import UIKit
import CoreLocation

class ViewController: UIViewController ,UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate{
    
    @IBOutlet weak var sortTypePicker: UISegmentedControl!
    @IBOutlet weak var tableVIewBlogs:UITableView!
    private let locationManager = CLLocationManager()
    var userLocation: (latitude: Double, longitude: Double)?
    
    let sortTypeKey = "SortTypeKey"
    
    var sortType : Int = 0
    
    var blogs: [Blog] = []
    
    @IBOutlet weak var progressCircle: UIActivityIndicatorView!
    @IBOutlet weak var addButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        tableVIewBlogs.dataSource = self
        tableVIewBlogs.delegate = self
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        if (UserDefaults.standard.integer(forKey: sortTypeKey) != 0){
            
            sortType = UserDefaults.standard.integer(forKey: sortTypeKey)
            
        }
        
        sortTypePicker.selectedSegmentIndex = sortType
        
        
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
            self.sortBlogList()
        }
        
        
        
    }
    
    @IBAction func sortTypeValueChanged(_ sender: UISegmentedControl) {
        
        sortType = sender.selectedSegmentIndex
        UserDefaults.standard.set(sortType, forKey: sortTypeKey)
        sortBlogList()
        
    }
    
    func sortBlogList(){
        
        switch(sortType){
            
        case 0:
            blogs = sortBlogsByCreationDate(blogs: blogs)
            break
        case 1:
            blogs = sortBlogsByReadTime(blogs: blogs)
            break
        case 2:
            blogs = sortBlogsByViewers(blogs: blogs)
            break
        case 3:
           blogs = sortBlogsByLocation(blogs: blogs)
            break
            
        default:
            blogs = sortBlogsByCreationDate(blogs: blogs)
            break
        
        }
        
        self.tableVIewBlogs.reloadData()
        
    }
    
    
    func sortBlogsByCreationDate(blogs: [Blog]) -> [Blog] {
        return blogs.sorted { $0.creationDate ?? Date() > $1.creationDate ?? Date() }
    }
    
    func sortBlogsByReadTime(blogs: [Blog]) -> [Blog] {
        return blogs.sorted { $0.readTime ?? 0 > $1.readTime ?? 0 }
    }
    
    func sortBlogsByViewers(blogs: [Blog]) -> [Blog] {
        return blogs.sorted { $0.viewers ?? 0 > $1.viewers ?? 0 }
    }
    
    func sortBlogsByLocation(blogs: [Blog]) -> [Blog] {
        return blogs.sorted { (blog1, blog2) in
            guard let location1 = blog1.location, let location2 = blog2.location else {
                // Handle case where one or both blogs don't have location data
                return false
            }
            
            // Compare based on latitude and longitude
            if location1.latitude == location2.latitude {
                return location1.longitude > location2.longitude
            } else {
                return location1.latitude > location2.latitude
            }
        }
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
            print("authorizedWhenInUse")
        case .denied, .restricted:
            print("denied or restricted")
            // Handle denied or restricted authorization
            // You can show an alert or take appropriate action
            break
        default:
            print("default")
            locationManager.stopUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            print("Location is null")
            return
        }
        
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        // Use the latitude and longitude values as needed
        print("Latitude: \(latitude), Longitude: \(longitude)")
        
        
        userLocation = (latitude: latitude, longitude: longitude)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Handle location update errors
        print("Location update error: \(error.localizedDescription)")
    }
    
    
    @IBAction func addPostClicked(_ sender: Any) {
        let newBlogViewController = storyboard?.instantiateViewController(withIdentifier: "NewBlogViewController") as? NewBlogViewController
        newBlogViewController?.userLocation = userLocation
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

