//
//  BlogViewController.swift
//  Bloggy
//
//  Created by Student28 on 16/06/2023.
//

import UIKit

class BlogViewController: UIViewController {
    
    var blog: Blog?
    @IBOutlet weak var blogTitle: UILabel!
    @IBOutlet weak var blogImage: UIImageView!
    @IBOutlet weak var blogText: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        blogTitle.text = blog?.title
        blogText.text = blog?.text
        blogText.isEditable = false
        
        if let imageUrl = blog!.imageURL{
           let url = URL(string: imageUrl)
           blogImage.kf.setImage(with: url)
           blogImage.contentMode = .scaleToFill
        }else{
            blogImage.image = UIImage(named: "ImagePlaceholder")
        }
        

        
        if let imageUrl = blog!.imageURL{
           let url = URL(string: imageUrl)
           blogImage.kf.setImage(with: url)
           blogImage.contentMode = .scaleToFill
        }
        
        // Add a tap gesture recognizer to the label
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
        blogTitle.isUserInteractionEnabled = true
        blogTitle.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    @objc func labelTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        if let blog = self.blog{
            // Create an alert controller
            let alertController = UIAlertController(title: blog.title, message: nil, preferredStyle: .alert)

            // Add the blog information as alert actions
            let viewersAction = UIAlertAction(title: "Viewers: \(blog.viewers ?? 0)", style: .default, handler: nil)
            alertController.addAction(viewersAction)

            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            if let creationDate = blog.creationDate {
                let creationDateAction = UIAlertAction(title: "Creation Date: \(dateFormatter.string(from: creationDate))", style: .default, handler: nil)
                alertController.addAction(creationDateAction)
            }

            let readTimeAction = UIAlertAction(title: "Read Time: \(blog.readTime ?? 0) minutes", style: .default, handler: nil)
            alertController.addAction(readTimeAction)

            // Add a cancel action
            let cancelAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)

            // Present the alert controller
            present(alertController, animated: true, completion: nil)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
