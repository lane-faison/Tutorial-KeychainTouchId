//
//  TouchIDAuthentication.swift
//  TouchMeIn
//
//  Created by Lane Faison on 11/24/17.
//  Copyright © 2017 iT Guy Technologies. All rights reserved.
//

import Foundation
import LocalAuthentication

class TouchIDAuth {
    let context = LAContext()
    
    func canEvaluatePolicy() -> Bool {
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
    
    func authenticateUser(completion: @escaping (String?) -> Void) {
        guard canEvaluatePolicy() else {
            completion("Touch ID not available")
            return
        }
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Logging in with Touch ID") { (success, evaluateError) in
            if success {
                DispatchQueue.main.async {
                    completion(nil)
                }
            } else {
                let message: String
                
                switch evaluateError {
                case LAError.authenticationFailed?:
                    message = "There was a problem verifying your identity"
                case LAError.userCancel?:
                    message = "You pressed cancel"
                case LAError.userFallback?:
                    message = "You pressed password"
                default:
                    message = "Touch ID may not be configured"
                }
                completion(message)
            }
        }
    }
}


