//
//  BookingListViewModel.swift
//  Beautify
//
//  Created by Артем Маков on 13.04.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import Foundation

class BookingListViewModel {
    
    var bookingListViewModel     = [BookingObjectViewModel]() { didSet { reloadTableViewClosure?() } }
    var selectedCell        : BookingObjectViewModel?
    var numberOfCells       : Int { return bookingListViewModel.count }
        
    var reloadTableViewClosure: (()->())?
    
    
    
    // MARK:- Init fetch masters
    
    func initFetch() {
        FBMasters.shared.loadBookings(userID: currentUser.id!)  { [weak self] (bookings, error) in
            guard let self = self else { return }
            if error == nil {
                guard var bookings = bookings else {
                    self.reloadTableViewClosure?()
                    return
                }
                self.bookingListViewModel.removeAll()
                self.createBookingsViewModel(bookings: bookings)
            }
        }
    }
    
    private func createBookingsViewModel(bookings: [Booking]) {
        for booking in bookings {
            FBMasters.shared.loadMasterInfo(for: booking.masterID!) { [weak self] (master, error) in
                guard let self = self else { return }
                if error != nil {
                    print(error!)
                } else {
                    guard let master = master else {
                        return
                    }
                    self.bookingListViewModel.append(self.proccessFetchBookings(booking: booking, master: master))
                }
            }
        }
    }
    
    private func proccessFetchBookings(booking: Booking, master: Master) -> BookingObjectViewModel {
        return BookingObjectViewModel(id: booking.id, masterName: master.name, masterID: booking.masterID, userID: booking.userID, bookDate: booking.bookDate, workID: booking.workID)
    }
    
    func getCellViewModel(at indexpath: IndexPath) -> BookingObjectViewModel {
        return bookingListViewModel[indexpath.row]
    }
    
    func pressedCell(at indexpath: IndexPath) {
        selectedCell = bookingListViewModel[indexpath.row]
    }
    
}

