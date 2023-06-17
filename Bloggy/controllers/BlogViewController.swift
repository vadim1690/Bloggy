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
