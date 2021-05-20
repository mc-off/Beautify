//
//  MapViewController.swift
//  Beautify
//
//  Created by Артем Маков on 22.03.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import UIKit
import GoogleMaps
import GoogleMapsUtils
import CoreLocation

class MapViewController: UIViewController, GMSMapViewDelegate, MapMarkerDelegate {
    
    func didTapInfoButton(vm: MasterShortViewModel) {
        self.passedVM.name = vm.name
        self.passedVM.type = vm.type
        self.passedVM.uid = vm.uid
        performSegue(withIdentifier: "mapToMaster", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapToMaster" {
                let vc = segue.destination as! MasterCardViewController
                vc.masterTitle = passedVM.name!
                vc.masterType = passedVM.type!
                vc.uid  = passedVM.uid!
        }
    }
    
    

    var passedVM = MasterShortViewModel()
    var mapView:GMSMapView?
    var clusterManager: GMUClusterManager?
    var london: GMSMarker?
    var marker2: GMSMarker?
    var londonView: UIImageView?
    var locationMarker : GMSMarker?

    
    var infoWindow: MapInfoWindow?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        self.clusterManager!.cluster()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }


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
        
      mapView?.isMyLocationEnabled = true
      mapView?.settings.myLocationButton = true
      mapView?.settings.compassButton = true



        let iconGenerator = GMUDefaultClusterIconGenerator()
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let renderer = GMUDefaultClusterRenderer(mapView: mapView!,
                                        clusterIconGenerator: iconGenerator)
        clusterManager = GMUClusterManager(map: mapView!, algorithm: algorithm,
                                                              renderer: renderer)

            // Register self to listen to GMSMapViewDelegate events.
        clusterManager?.setMapDelegate(self)
        loadMarkersFromDB()
        
        self.clusterManager!.cluster()
        
    }
    
    func loadMarkersFromDB() {
            let ref = FBAuthentication.shared.ref.child("masters")
        ref.observe(.childAdded, with: { (snapshot) in
                    if snapshot.value as? [String : AnyObject] != nil {
                        self.mapView?.clear()
                        // Get coordinate values from DB
                        let latitude = snapshot.childSnapshot(forPath: "coordinate").childSnapshot(forPath: "latitude").value as? Double
                        let longitude = snapshot.childSnapshot(forPath: "coordinate").childSnapshot(forPath: "longitude").value as? Double
                        
                        let values = snapshot.value as! [String: Any]
                        var master = MasterShortViewModel()
                        master.uid = values["id"] as? String ?? ""
                        master.name = values["name"] as? String ?? ""
                        master.type = values["type"] as? String ?? ""
                        master.priceTier = snapshot.childSnapshot(forPath: "priceTier").value as? Int
                        master.coordinate = Coordinate(longitude: longitude!, latitude: latitude!)
                        
                        DispatchQueue.main.async(execute: {
                            let marker = GMSMarker()
                            // Assign custom image for each marker
                            // Customize color of marker here:
                            marker.position = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
                            marker.userData = master
                            self.clusterManager!.add(marker)
                        })
                    }
        }, withCancel: nil)
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
    
        func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
            
            locationMarker = marker
            self.mapView?.selectedMarker = marker
                
            mapView.animate(toLocation: marker.position)
              // check if a cluster icon was tapped
              if marker.userData is GMUCluster {
                // zoom in on tapped cluster
                mapView.animate(toZoom: mapView.camera.zoom + 3)
                NSLog("Did tap cluster")
                return true
              }
            
            NSLog("Did tap a normal marker")


                infoWindow = Bundle.main.loadNibNamed("MapInfoWindowView", owner: self, options: nil)![0] as? MapInfoWindow
            
            infoWindow?.cellVM = marker.userData as! MasterShortViewModel
                infoWindow?.delegate = self

            
                let frame = CGRect(x: 0, y: 20, width: 300, height: infoWindow?.frame.height ?? 200)
            
                infoWindow?.frame = frame
            infoWindow?.layer.cornerRadius = 20

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
                if ((infoWindow) != nil) {
                    infoWindow!.center = mapView.projection.point(for: location)
                    infoWindow!.center.y = infoWindow!.center.y - sizeForOffset(view: infoWindow!)
                }
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
            return  130
        }
        
}
