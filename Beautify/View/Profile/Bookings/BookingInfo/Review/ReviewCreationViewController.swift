//
//  ReviewCreationViewController.swift
//  Beautify
//
//  Created by Артем Маков on 05.06.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import UIKit
import Cosmos

class ReviewCreationViewController: UIViewController {
    
    var masterID: String?
    
    @IBOutlet weak var imagePicker: UIButton!
    @IBOutlet var tapGesture: UITapGestureRecognizer!

    private var image = UIImage() { didSet {
    imagePicker.setImage(image, for: .normal) } }
    
    
    
    private let vm = ReviewCreationViewModel()


    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var ratingView: CosmosView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupVM()
        


        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func setupVM() {
        vm.showAlertClosure = { [unowned self] in
            self.navigationController?.popViewController(animated: true)
            Alert.showAlert(at: self, title: "", message: self.vm.messageAlert!)
        }
    }
    
    @IBAction func createButtonPressed(_ sender: Any) {
        vm.createPressed(masterID: masterID!, userID: currentUser.id!, description: descriptionTextField.text ?? "", grade: Int(ratingView.rating), reviewImage: image)
    }
    
    
    @IBAction func photoPicker(_ sender: Any) {
        SystemAuthorization.shared.photoAuthorization { [weak self] (isAuth, message) in
            guard let self = self else { return }
            if isAuth {
                self.imagePressed()
            } else {
                DispatchQueue.main.async {
                    Alert.showAlert(at: self, title: "Photo Library", message: message!)
                }
            }
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

extension ReviewCreationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private func imagePressed() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            image = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            image = originalImage
        }
        dismiss(animated: true, completion: nil)
    }
    
}
