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


class MapViewController: UIViewController, GMSMapViewDelegate, MapMarkerDelegate {
    
    func didTapInfoButton() {
        print("tapped to info window")
    }
    

    
    var mapView:GMSMapView?
    var london: GMSMarker?
    var marker2: GMSMarker?
    var londonView: UIImageView?
    var locationMarker : GMSMarker?

    
    var infoWindow: MapInfoWindow?


    override func viewDidLoad() {
      super.viewDidLoad()
        
        
        
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
    
    func centerInMarker(marker: GMSMarker) {
        var bounds = GMSCoordinateBounds()
        bounds = bounds.includingCoordinate(marker.position)
        
        var camera = GMSCameraPosition.camera(
            withLatitude: marker.position.latitude,
            longitude: marker.position.longitude,
            zoom: 18
          )
        let zoom = GMSCameraUpdate.setCamera(camera)
        
        self.mapView?.moveCamera(zoom)
        
    }
    
        func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
            
            locationMarker = marker
            self.mapView?.selectedMarker = marker
            
            centerInMarker(marker: locationMarker!)

                infoWindow = Bundle.main.loadNibNamed("MapInfoWindowView", owner: self, options: nil)![0] as? MapInfoWindow
            
                infoWindow?.delegate = self

            
                let frame = CGRect(x: 0, y: 0, width: 300, height: infoWindow?.frame.height ?? 200)
            
                infoWindow?.frame = frame
                infoWindow?.center = mapView.projection.point(for: marker.position)
            infoWindow?.center.y = (infoWindow?.center.y)! - sizeForOffset(view: infoWindow!)
                self.view.addSubview(infoWindow!)
            
            return false
        }
        
        // MARK: Needed to create the custom info window
        func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
            if (locationMarker != nil){
                guard let location = locationMarker?.position else {
                    print("locationMarker is nil")
                    return
                }
                infoWindow?.center = mapView.projection.point(for: location)
                infoWindow!.center.y = infoWindow!.center.y - sizeForOffset(view: infoWindow!)
            }
        }
        
        // MARK: Needed to create the custom info window
        func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
            return UIView()
        }

        
        // MARK: Needed to create the custom info window
        func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
            infoWindow?.removeFromSuperview()
        }
        
        // MARK: Needed to create the custom info window (this is optional)
        func sizeForOffset(view: UIView) -> CGFloat {
            return  110
        }
        
}
