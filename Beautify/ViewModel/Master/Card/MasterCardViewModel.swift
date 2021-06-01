//
//  MasterCardViewModel.swift
//  Beautify
//
//  Created by Артем Маков on 19.04.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import Foundation

class MasterCardViewModel {
    
    var worksViewModel = WorksViewModel() { didSet { reloadTableViewClosure?() } }
    var masterViewModel =  MasterShortViewModel() { didSet { reloadTableViewClosure?() } }
    var reviewsViewModel = [ReviewViewModel]() { didSet { reloadTableViewClosure?() } }
    var selectedInfoCell: MasterShortViewModel?
    var selectedReviewCell: ReviewViewModel?
    var selectedWorkCell: WorkViewModel?
    
    var selectedSegment: Int = 0
    
    var numberOfCells: Int {
        switch selectedSegment {
        case 0:
            return 5
        case 1:
            return reviewsViewModel.count
        default:
            return worksViewModel.numberOfCells
        }
    }
    
    public var message: String?         { didSet { showAlertClosure?() }}

    
    var reloadTableViewClosure: (()->())?
    var showAlertClosure      : (()->())?
    
    
    
    
    
    
    // MARK:- Init fetch masters
    
    func initFetch(uid: String) {
        FBMasters.shared.loadMasterInfo(for: uid) { [weak self] (master, error) in
            guard let self = self else { return }
            if error == nil {
                self.masterViewModel = self.proccessFetchMaster(master: master!)
            } else { self.message = error! }
            self.fetchReviews(masterID: uid)
            self.worksViewModel.initFetch(creatorID: uid)
        }
    }
    
    private func proccessFetchMaster(master: Master) -> MasterShortViewModel {
        return MasterShortViewModel(uid: master.id!, description: master.description, coordinate: master.coordinate, name: master.name, profileImage: master.profileImage, type: master.type, workHours: master.workHours, reviews: master.reviews, grade: master.grade, gradeAmount: master.gradeAmount)
    }
    
    func fetchReviews(masterID: String) {
        FBReviews.shared.loadReviews(masterID: masterID) { [weak self] (reviews, error) in
            guard let self = self else { return }
            if error == nil {
                guard let reviews = reviews else {
                    self.reloadTableViewClosure?()
                    return
                }
                self.reviewsViewModel.removeAll()
                self.createReviewsViewModel(reviews: reviews)
            }
        }
    }
    
    private func createReviewsViewModel(reviews: [Review]) {
        var vms = [ReviewViewModel]()
        for review in reviews {
            vms.append(proccessFetchReview(review: review))
        }
        reviewsViewModel.append(contentsOf: vms)
    }
    
    private func proccessFetchReview(review: Review) -> ReviewViewModel {
        return ReviewViewModel(id: review.id, userID: review.userID, username: review.username, masterID: review.masterID, topImageURL: review.topImageURL, description: review.description, grade: review.grade, status: review.status)
    }
    
    func getReviewCellViewModel(at indexpath: Int) -> ReviewViewModel{
        return reviewsViewModel[indexpath]
    }
    
    func pressedReviewCell(at indexpath: IndexPath) {
        selectedReviewCell = reviewsViewModel[indexpath.row]
    }
    
    func pressedWorkCell(at indexpath: IndexPath) {
        selectedWorkCell = worksViewModel.worksViewModel[indexpath.row]
    }
    
}

struct ReviewViewModel {
    var id: String?
    var userID: String?
    var username: String?
    var masterID: String?
    var topImageURL: String?
    var description: String?
    var grade: Double?
    var status: String?
}

