//
//  MasterCreationViewComntroller.swift
//  Beautify
//
//  Created by Артем Маков on 01.03.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import UIKit
import LocationPicker
import CoreLocation
import MapKit

class MasterCreationViewController: UIViewController {
    private var image = UIImage() { didSet {
    imagePicker.setImage(image, for: .normal) } }
    
    @IBOutlet weak var imagePicker: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationPickerButton: UIButton!
    
    @IBOutlet weak var fromDatePicker: UIDatePicker!
    @IBOutlet weak var toDatePicker: UIDatePicker!
    
    @IBOutlet weak var priceRangeSegment: UISegmentedControl!
    
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var location: Location? {
        didSet {
            locationLabel.text = location.flatMap({ $0.title }) ?? "No location"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI();
        location = nil
    }
    
    private func setupUI() {
        
        //Setup delegates
        nameTextField.addTopBorder()
        nameTextField.addBottomBorder()
        nameTextField.addPrefix(labelText: "Name")
        
        typeTextField.addBottomBorder()
        typeTextField.addPrefix(labelText: "Type")
        
        descriptionTextField.addBottomBorder()
        descriptionTextField.addPrefix(labelText: "Description")
        
        tapGesture.addTarget(self, action: #selector(dismissKeyboard))
        
        activityIndicator.stopAnimating()
        
        print("setup ui")
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    @IBAction func locationPickerTapped(_ sender: Any) {
        let locationPicker = LocationPickerViewController()

        // you can optionally set initial location
        let placemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 37.331686, longitude: -122.030656), addressDictionary: nil)
        let location = Location(name: "1 Infinite Loop, Cupertino", location: nil, placemark: placemark)
        locationPicker.location = location

        // button placed on right bottom corner
        locationPicker.showCurrentLocationButton = true // default: true

        // default: navigation bar's `barTintColor` or `UIColor.white`
        locationPicker.currentLocationButtonBackground = .blue

        // ignored if initial location is given, shows that location instead
        locationPicker.showCurrentLocationInitially = true // default: true

        locationPicker.mapType = .standard // default: .Hybrid

        // for searching, see `MKLocalSearchRequest`'s `region` property
        locationPicker.useCurrentLocationAsHint = true // default: false

        locationPicker.searchBarPlaceholder = "Search places" // default: "Search or enter an address"

        locationPicker.searchHistoryLabel = "Previously searched" // default: "Search History"

        // optional region distance to be used for creation region when user selects place from search results
        locationPicker.resultRegionDistance = 500 // default: 600

        locationPicker.completion = { pickedLocation in
            self.location = pickedLocation
        }

        navigationController?.pushViewController(locationPicker, animated: true)
    }
    
    @IBAction func completeButtonTapped(_ sender: Any) {
        print(nameTextField.text!)
        print(typeTextField.text!)
        print(descriptionTextField.text!)
        
        
        print(location?.address)
        print(location?.coordinate.latitude)
        print(location?.coordinate.longitude)

        let calendar = Calendar.current
        
        print(calendar.component(.hour, from: fromDatePicker.date))
        print(calendar.component(.minute, from: fromDatePicker.date))

        print(calendar.component(.hour, from: toDatePicker.date))
        print(calendar.component(.minute, from: toDatePicker.date))
        
        print(priceRangeSegment.selectedSegmentIndex)
    }
    @IBAction func imagePickerTapped(_ sender: Any) {
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
}

extension MasterCreationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
