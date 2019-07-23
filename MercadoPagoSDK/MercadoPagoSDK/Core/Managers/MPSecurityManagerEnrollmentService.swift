//
//  MPSecurityManagerEnrollmentService.swift
//  MercadoPagoSDK
//
//  Created by Juan sebastian Sanzone on 7/23/19.
//

import Foundation
import LocalAuthentication

struct MPSecurityManagerEnrollmentService {
    private let authenticationContext: LAContext

    init(withAuthenticationContext: LAContext) {
        self.authenticationContext = withAuthenticationContext
    }

    func needUserValidation() -> Bool {
        var authError: NSError?
        return authenticationContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &authError) && isUserAlreadyEnrolled() && isUserInTarget()
    }
}

// MARK: Privates.
extension MPSecurityManagerEnrollmentService {
    private func isUserAlreadyEnrolled() -> Bool {
        // TODO: Check enrollment flag. (User local settings?)
        return true
    }

    private func isUserInTarget() -> Bool {
        // TODO: Check MeliData experiment.
        return true
    }
}
