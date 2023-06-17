//
//  NewBlogViewController.swift
//  Bloggy
//
//  Created by Student28 on 16/06/2023.
//

import UIKit
import FirebaseStorage
class NewBlogViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var blogTextTv: UITextView!
    @IBOutlet weak var blogImageView: UIImageView!
    @IBOutlet weak var blogTitleEditText: UITextField!
    
    var selectedImage: UIImage?
    
    var progressHUD: UIAlertController?
    
    var userLocation: (latitude: Double, longitude: Double)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Add tap gesture recognizer to the image view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        blogImageView.isUserInteractionEnabled = true
        blogImageView.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view.
    }
    
    
    @objc func imageViewTapped() {
        // Open gallery to select a photo
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    // Handle image selection from the gallery
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            selectedImage = image
            blogImageView.contentMode = .scaleAspectFill
            blogImageView.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postClicked(_ sender: Any) {
        if validateFields(){
            showProgressHUD()
            guard let image = selectedImage else {
                // No image selected, proceed without uploading
                performBlogSave(imageUrl: nil)
                return
            }
            
            
            
            uploadImageToFirebase(image) { [weak self] imageUrl in
                
                self?.performBlogSave(imageUrl: imageUrl)
            }
            
        }

    }
    
    
    private func showProgressHUD() {
        progressHUD = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()
        
        let message = "Uploading blog..."
        let attributedString = NSAttributedString(string: message, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .medium)])
        progressHUD?.setValue(attributedString, forKey: "attributedMessage")
        
        let stackView = UIStackView(arrangedSubviews: [indicator])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        
        progressHUD?.view.addSubview(stackView)
        
        let constraints = [
            stackView.centerXAnchor.constraint(equalTo: progressHUD!.view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: progressHUD!.view.centerYAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        
        present(progressHUD!, animated: true, completion: nil)
    }
    
    private func hideProgressHUD() {
        progressHUD?.dismiss(animated: true, completion: nil)
        progressHUD = nil
    }
    
    
    private func uploadImageToFirebase(_ image: UIImage, completion: @escaping (URL?) -> Void) {
            guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                completion(nil)
                return
            }
            
            let storageRef = Storage.storage().reference().child("blog_images").child("\(UUID().uuidString).jpg")
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            storageRef.putData(imageData, metadata: metadata) { (metadata, error) in
                if let error = error {
                    print("Error uploading image to Firebase Storage: \(error.localizedDescription)")
                    completion(nil)
                } else {
                    storageRef.downloadURL { (url, error) in
                        if let error = error {
                            print("Error retrieving image URL from Firebase Storage: \(error.localizedDescription)")
                            completion(nil)
                        } else {
                            completion(url)
                        }
                    }
                }
            }
        }
    
    
    private func performBlogSave(imageUrl: URL?) {
        let blog = Blog()
        blog.title = blogTitleEditText.text
        blog.text = blogTextTv.text
        blog.readTime = (blog.text!.count / 700) + 1
        blog.viewers = 0
        blog.location = userLocation
        blog.imageURL = imageUrl?.absoluteString
        print("post Latitude: \(blog.location!.latitude), post Longitude: \(blog.location!.longitude)")
        FirebaseManager.shared.saveBlog(blog: blog) { error in
            self.hideProgressHUD()
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
    
    
    
    private func validateFields() -> Bool{
//        if blogTextTv.text.count < 200{
//            let alert = UIAlertController(title: "Error", message: "Must enter at least 200 characters in the blog text", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//            return false
//        }
        
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
