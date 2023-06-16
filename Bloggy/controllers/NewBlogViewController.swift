//
//  NewBlogViewController.swift
//  Bloggy
//
//  Created by Student28 on 16/06/2023.
//

import UIKit

class NewBlogViewController: UIViewController {
    
    @IBOutlet weak var blogTextTv: UITextView!
    @IBOutlet weak var blogImageView: UIImageView!
    @IBOutlet weak var blogTitleEditText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func postClicked(_ sender: Any) {
        if validateFields(){
            let blog = Blog()
            blog.title = blogTitleEditText.text
            blog.text = blogTextTv.text
            blog.readTime = (blog.text!.count / 700) + 1
            blog.viewers = 0
            FirebaseManager.shared.saveBlog(blog: blog) { error in
                if let error = error {
                    // Handle error
                    print("Error saving blog: \(error.localizedDescription)")
                    
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Error", message: "Failed to save blog", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                } else {
                    // Blog saved successfully
                    print("Blog saved successfully!")
                    
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Success", message: "Blog saved successfully", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true) {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                self.navigationController?.popToRootViewController(animated: true)
                            }
                        }
                    }
                }
            }
        }

    }
    
    
    private func validateFields() -> Bool{
        if blogTextTv.text.count < 200{
            let alert = UIAlertController(title: "Error", message: "Must enter at least 200 characters in the blog text", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        
        if (blogTitleEditText.text!.isEmpty) {
            let alert = UIAlertController(title: "Error", message: "Must enter a title", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        return true
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
