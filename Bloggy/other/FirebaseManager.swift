//
//  FirebaseManager.swift
//  Bloggy
//
//  Created by Student28 on 14/06/2023.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage
class FirebaseManager {
    static let shared = FirebaseManager() // Singleton instance

    private let blogRef = Database.database().reference().child("blogs")

    private init() {} // Private initializer for singleton
    
    func saveBlog(blog: Blog) {
        if let blogId = blog.id {
            blogRef.child(blogId).setValue(blog.toDictionary()) { error, _ in
                if let error = error {
                    print("Error saving blog to Firebase: \(error)")
                } else {
                    print("Blog saved successfully!")
                }
            }
        } else {
            print("Error: Unable to get the blog's id.")
        }
    }
    
    func readBlogs(completion: @escaping ([Blog]) -> Void) {
        blogRef.observe(.value) { snapshot in
            var blogs: [Blog] = []

            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let blogDict = childSnapshot.value as? [String: Any] {
                    // Convert the blog dictionary to a Blog object
                    if let blog = self.blogFromDictionary(blogDict: blogDict) {
                        blogs.append(blog)
                    }
                }
            }

            completion(blogs)
        }
    }
       
    private func blogFromDictionary(blogDict: [String: Any]) -> Blog? {
           // Convert the dictionary to a Blog object
           do {
               let jsonData = try JSONSerialization.data(withJSONObject: blogDict, options: [])
               let decoder = JSONDecoder()
               let blog = try decoder.decode(Blog.self, from: jsonData)
               return blog
           } catch {
               print("Error decoding blog: \(error)")
               return nil
           }
       }
    
    
    func updateBlog(blog: Blog) {
        guard let blogId = blog.id else {
            return
        }

        let blogDict = blog.toDictionary()

        blogRef.child(blogId).updateChildValues(blogDict) { (error, _) in
            if let error = error {
                print("Failed to update blog: \(error.localizedDescription)")
            } else {
                print("Blog updated successfully")
            }
        }
    }

}
