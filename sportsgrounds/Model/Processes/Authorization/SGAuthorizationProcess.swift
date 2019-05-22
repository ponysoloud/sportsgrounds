//
//  SGAuthorizationProcess.swift
//  sportgrounds
//
//  Created by Alexander Ponomarev on 14/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import Foundation

struct SGAuthorizationProcess {
    
    var email: String?
    var password: String?
    
    var name: String?
    var surname: String?
    
    var birthdate: Date?
    
    // Check correctness and completion status
    
    var isEmailCorrect: Bool {
        guard let email = email else {
            return false
        }
        
        let emailRegularExpression = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return isCorrect(value: email, for: emailRegularExpression)
    }
    
    var isPassowordCorrect: Bool {
        guard let password = password else {
            return false
        }
        
        return password.count > 6
    }
    
    var isNameCorrect: Bool {
        guard let name = name else {
            return false
        }
        
        let nameRegularExpression = "[\\wЁёА-я- ]{2,20}"
        return isCorrect(value: name, for: nameRegularExpression)
    }
    
    var isSurnameCorrect: Bool {
        guard let surname = surname else {
            return false
        }
        
        let surnameRegularExpression = "[\\wЁёА-я- ]{2,28}"
        return isCorrect(value: surname, for: surnameRegularExpression)
    }
    
    var isBirthdateCorrect: Bool {
        guard let birtdate = birthdate else {
            return false
        }
        
        return birtdate.age > 2
    }
    
    var isAuthorizationComplete: Bool {
        return isEmailCorrect && isPassowordCorrect
    }
    
    var isRegistrationComplete: Bool {
        return isAuthorizationComplete && isNameCorrect && isSurnameCorrect && isBirthdateCorrect
    }
    
    func isCompleted(step: SGAuthorizationStep) -> Bool {
        switch step {
        case .login:
            return isEmailCorrect && isPassowordCorrect
        case .register:
            return isAuthorizationComplete && isNameCorrect && isSurnameCorrect && isBirthdateCorrect
        }
    }
    
    private func isCorrect(value: String, for regularExpression: String) -> Bool {
        let matchPredicate = NSPredicate(format:"SELF MATCHES %@", regularExpression)
        return matchPredicate.evaluate(with: value)
    }
}
