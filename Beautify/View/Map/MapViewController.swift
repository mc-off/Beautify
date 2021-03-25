//
//  MapViewController.swift
//  Beautify
//
//  Created by Артем Маков on 22.03.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import SlideUpPanel


class MapViewController: UIViewController, GMSMapViewDelegate {

    @IBOutlet var mapMasterInfoView: UIView!
    @IBOutlet var initialSlidePanelInfoView: UIView!
    
    var mapView:GMSMapView?
    var cardViewController : SlideUpPanel!
    var london: GMSMarker?
    var marker2: GMSMarker?
    var londonView: UIImageView?

    override func viewDidLoad() {
      super.viewDidLoad()
        
        cardViewController = SlideUpPanel(vc: self, cardHeight: nil)
                cardViewController.contentArea = mapMasterInfoView
                let guide = view.safeAreaLayoutGuide
                //NSLayoutConstraint.activate([
                 //   guide.bottomAnchor.constraint(equalToSystemSpacingBelow: cardViewController.view.bottomAnchor, multiplier: 1.0)
                 //])

                self.addChild(cardViewController)
                self.view.addSubview(cardViewController.view)
                
                cardViewController.view.translatesAutoresizingMaskIntoConstraints = false
                
                NSLayoutConstraint.activate([
                    cardViewController.view.bottomAnchor.constraint(equalTo: guide.bottomAnchor)
                ])
        //        cardViewController.view.attachAnchors(to: containerView)
                cardViewController.didMove(toParent: self)
        
       
//        self.view.addSubview(cardViewController.view)

      let camera = GMSCameraPosition.camera(
        withLatitude: 51.5,
        longitude: -0.127,
        zoom: 14
      )
      mapView = GMSMapView.map(withFrame: self.view.bounds, camera: camera)
      self.view.addSubview(mapView!)

      mapView?.delegate = self

      let house = UIImage(systemName: "house.fill")!.withRenderingMode(.alwaysTemplate)
      let markerView = UIImageView(image: house)
      markerView.tintColor = .red
      londonView = markerView

      let position = CLLocationCoordinate2D(latitude: 51.5, longitude: -0.127)
      let marker = GMSMarker(position: position)
      marker.iconView = markerView
      marker.tracksViewChanges = true
      marker.map = mapView
        marker.tracksViewChanges = false
      london = marker
        
        let position2 = CLLocationCoordinate2D(latitude: 51.51, longitude: -0.127)
        let marker2 = GMSMarker(position: position2)
        marker2.iconView = markerView
        marker2.tracksViewChanges = true
        marker2.map = mapView
        marker2.tracksViewChanges = false

        
        self.marker2 = marker2


        
    }
//
//    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
//      UIView.animate(withDuration: 5.0, animations: { () -> Void in
//        self.londonView?.tintColor = .blue
//      }, completion: {(finished) in
//        // Stop tracking view changes to allow CPU to idle.
//        self.london?.tracksViewChanges = false
//        self.marker2?.tracksViewChanges = false
//      })
//    }
    
    func centerInMarker(mapView: GMSMapView, marker: GMSMarker) {
        var bounds = GMSCoordinateBounds()
        bounds = bounds.includingCoordinate(marker.position)
        let update = GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: (mapView.frame.height)/2 - 160, left: (mapView.frame.width)/2, bottom: (mapView.frame.height)/2 + 160, right: (mapView.frame.width)/2))
        mapView.moveCamera(update)
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        self.centerInMarker(mapView: mapView, marker: marker)
        cardViewController.contentArea = mapMasterInfoView
        cardViewController.cardVisible = true
        return true
    }

}
