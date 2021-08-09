//
//  EditeProfileViewModel.swift
//  Beautify
//
//  Created by Артем Маков on 23.02.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import UIKit


class EditeProfileViewModel {

    var userInfo: UserInfoViewModel? { didSet {loadUserInfoClosure?() }}
    var message : String? { didSet { showAlertClosure?() }}
    
    
    var loadUserInfoClosure: (()->())?
    var showAlertClosure   : (()->())?
    
    
    
    
    func initFetch() {
        DefaultSettings.shared.initUserDefaults { [unowned self] (user) in
            self.userInfo = self.proccessCreateUser(user: user)
        }
    }
    
    
    func UpdateProfile(photo: UIImage, firstName: String?, lastName: String?) {
        FBDatabase.shared.editeProfile(profileImage: photo, firstName: firstName, lastName: lastName) { [unowned self] (isSuccess, error) in
            self.message = isSuccess ?  "Профиль успешно обновлен" : error
        }
    }
    
    
    private func proccessCreateUser(user: User) -> UserInfoViewModel{
        return UserInfoViewModel(photo: user.image, firstName: user.first, lastName: user.last)
    }
    
}

//test string

struct UserInfoViewModel {
    var photo  : UIImage?
    var firstName: String?
    var lastName: String?
}
