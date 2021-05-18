//
//  HomeViewModel.swift
//  Beautify
//
//  Created by Артем Маков on 15.02.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import Foundation
import Firebase


class HomeViewModel {
    
    let defaults = UserDefaults.standard
    var user = User() {
        didSet {
            loadInfoClosure?()
        }
    }
    
    var bookingViewModel = BookingObjectViewModel() {
        didSet {
            reloadTableViewClosure?()
        }
    }
    
    var bookedMaster = MasterShortViewModel() {
        didSet {
            reloadTableViewClosure?()
        }
    }
    
    var loadInfoClosure: (()->())?
    var reloadTableViewClosure: (()->())?
    
    
    func loadInfo() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        if self.defaults.string(forKey: "id") == uid  {
            DefaultSettings.shared.initUserDefaults { (user) in
                self.user = user
            }
        } else {
        FBDatabase.shared.loadUserInfo(for: uid) { [weak self] (user, error) in
                guard let self = self else { return }
                if error != nil {
                    print(error!)
                } else {
                    guard let user = user else { return }
                    self.user = user
                    DefaultSettings.shared.setUserDefauls(first: user.first, last: user.last, id: user.id, email: user.email, imageURL: user.imageURL)
                }
            }
        }
    }
    
    func loadBookingInfo() {
        FBMasters.shared.loadBookings(userID: currentUser.id!) { [weak self] (bookings, error) in
            guard let self = self else { return }
            if error != nil {
                print(error!)
            } else {
                guard let bookings = bookings else { return }
                let bookingViewModel = bookings.last
                FBMasters.shared.loadMasterInfo(for: bookingViewModel!.masterID!) { [weak self] (master, error) in
                    guard let self = self else { return }
                    if error != nil {
                        print(error!)
                    } else {
                        guard let master = master else { return }
                        self.bookedMaster = self.proccessFetchMasters(master: master)
                        self.bookingViewModel = self.proccessFetchBookings(booking: bookingViewModel!)
                    }
                }
            }
        }
    }
    
    private func proccessFetchMasters(master: Master) -> MasterShortViewModel {
        return MasterShortViewModel(uid: master.id!, coordinate: master.coordinate, name: master.name, profileImage: master.profileImage, type: master.type, workHours: master.workHours)
    }
    
    private func proccessFetchBookings(booking: Booking) -> BookingObjectViewModel {
        return BookingObjectViewModel(id: booking.id, masterID: booking.masterID, userID: booking.userID, bookDate: booking.bookDate)
    }
}

struct BookingObjectViewModel {
    var id:String?
    var masterID: String?
    var userID: String?
    var bookDate: Date?
}
