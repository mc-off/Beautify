//
//  Extensions.swift
//  Beautify
//
//  Created by Артем Маков on 14.02.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import UIKit
import Kingfisher

extension UITextField {
    func addTopBorder() {
        let topLine = CALayer()
        topLine.frame = CGRect(x: 0, y: 1, width: self.frame.size.width, height: 0.5)
        let backgroundColor = UIColor.black.lighter(by: 80)
        
        topLine.backgroundColor = backgroundColor?.cgColor
        borderStyle = .none
        layer.addSublayer(topLine)
    }
    
    func addBottomBorder() {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 0.5)
        let backgroundColor = UIColor.black.lighter(by: 80)

        bottomLine.backgroundColor = backgroundColor?.cgColor
        borderStyle = .none
        layer.addSublayer(bottomLine)
    }
    
    func addPrefix(labelText: String) {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 90, height: self.frame.height))
        
        let prefixLabel = UILabel()
        
        prefixLabel.text = labelText
        prefixLabel.textColor = .black
        prefixLabel.contentMode = .left
    
        prefixLabel.font = UIFont.boldSystemFont(ofSize: prefixLabel.font.pointSize)
        
        
        prefixLabel.frame = containerView.frame
        
        containerView.addSubview(prefixLabel)
        
        self.leftView = containerView
        self.leftViewMode = .always
    }
}

extension UIColor {

    func lighter(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }

    func darker(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }

    func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: min(red + percentage/100, 1.0),
                           green: min(green + percentage/100, 1.0),
                           blue: min(blue + percentage/100, 1.0),
                           alpha: alpha)
        } else {
            return nil
        }
    }
}

extension UIImageView {
    func load(url: String) {
        DispatchQueue.global().async { [weak self] in
            if let Url = URL(string: url) {
                if let data = try? Data(contentsOf: Url) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.image = image
                        }
                    }
                }
            }
        }
    }
    
    func KFloadImage(url: String){
        let url = URL(string: url)
        self.kf.setImage(with: url, placeholder: nil, options: [.transition(ImageTransition.fade(0.2))], progressBlock: .none)
        
    }
    
    func KFload(url: String, complation: @escaping(UIImage)->()){
        let url = URL(string: url)
        self.kf.setImage(with: url, placeholder: nil, options: [.transition(ImageTransition.fade(0.2))], progressBlock: .none) { (result) in
            switch result {
                case.success(let data):
                    complation(data.image)
                case .failure(_):
                print("error")
            }
        }
    }
}

extension UIImage {
    func scalePreservingAspectRatio(targetSize: CGSize) -> UIImage {
        // Determine the scale factor that preserves aspect ratio
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        
        let scaleFactor = min(widthRatio, heightRatio)
        
        // Compute the new image size that preserves aspect ratio
        let scaledImageSize = CGSize(
            width: size.width * scaleFactor,
            height: size.height * scaleFactor
        )

        // Draw and return the resized UIImage
        let renderer = UIGraphicsImageRenderer(
            size: scaledImageSize
        )

        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(
                origin: .zero,
                size: scaledImageSize
            ))
        }
        
        return scaledImage
    }
}