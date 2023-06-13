//
//  Blog.swift
//  Bloggy
//
//  Created by Student29 on 13/06/2023.
//

import Foundation
class Blog{
    
    var title: String?
    var imageURL: String?
    var text: String?
    var viewers: Int?
    var creationDate: Date?
    var location: (latitude: Double, longitude: Double)?
    var readTime: Int?
    
    init(title: String? = nil, imageURL: String? = nil, text: String? = nil, viewers: Int? = nil, creationDate: Date? = nil, location: (latitude: Double, longitude: Double)? = nil, readTime: Int? = nil) {
        self.title = title
        self.imageURL = imageURL
        self.text = text
        self.viewers = viewers
        self.creationDate = creationDate
        self.location = location
        self.readTime = readTime
    }
    

    
    init() {
        
    }
    

    
    func mockData() -> [Blog] {
        var blogs: [Blog] = []
        let blog1 = Blog(title: "First Blog Title", imageURL: "https://example.com/image1.jpg", text: "Lorem ipsum dolor sit amet.", viewers: 100, creationDate: Date(), location: (latitude: 37.7749, longitude: -122.4194), readTime: 10)
        
        let blog2 = Blog(title: "Second Blog Title", imageURL: "https://example.com/image2.jpg", text: "Lorem ipsum dolor sit amet.", viewers: 200, creationDate: Date(), location: (latitude: 40.7128, longitude: -74.0060), readTime: 15)

        
        let blog3 = Blog(title: "Third Blog Title", imageURL: "https://example.com/image3.jpg", text: "Lorem ipsum dolor sit amet.", viewers: 300, creationDate: Date(), location: (latitude: 51.5074, longitude: -0.1278), readTime: 20)
        
        let blog4 = Blog(title: "Fourth Blog Title", imageURL: "https://example.com/image4.jpg", text: "Lorem ipsum dolor sit amet.", viewers: 400, creationDate: Date(), location: (latitude: 48.8566, longitude: 2.3522), readTime: 25)
        
        let blog5 = Blog(title: "Fifth Blog Title", imageURL: "https://example.com/image5.jpg", text: "Lorem ipsum dolor sit amet.", viewers: 500, creationDate: Date(), location: (latitude: 35.6895, longitude: 139.6917), readTime: 30)





        blogs.append(blog1)
        blogs.append(blog2)
        blogs.append(blog3)
        blogs.append(blog4)
        blogs.append(blog5)

        return blogs
    }
    
}
