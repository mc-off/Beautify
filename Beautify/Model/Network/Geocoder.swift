//
//  GMSPlaceDecoder.swift
//  Beautify
//
//  Created by Артем Маков on 12.04.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import GoogleMaps

//sourcery: mock
protocol Geocoding {
    func reverseGeocodeCoordinate(
        _ coordinate: Coordinate,
        completion: @escaping (Bool, String?) -> Void
    )
}

final class Geocoder: Geocoding {
    
    private let geocoder: GMSGeocoder
    
    init(geocoder: GMSGeocoder) {
        self.geocoder = geocoder
    }
    
    func reverseGeocodeCoordinate(
        _ coordinate: Coordinate,
        completion: @escaping (Bool, String?) -> Void
    ) {
        geocoder.reverseGeocodeCoordinate(CLLocationCoordinate2D(
            latitude: coordinate.latitude,
            longitude: coordinate.longitude
        )) { response, error in
            guard
                let parsedAddress = response?.firstResult(),
                let address = parsedAddress.thoroughfare
            else {
                completion(false, nil)
                return
            }
            
            completion(true, address);
        }
    }
}
