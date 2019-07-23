//
//  MPSecurityManager.swift
//  MercadoPagoSDK
//
//  Created by Juan sebastian Sanzone on 7/22/19.
//

import Foundation
import LocalAuthentication

struct MPSecurityManager {
    private let localAuthenticationContext = LAContext()
    private let reasonString: String
    private var needUserValidation: Bool = true

    init(flowUsageDescription: String) {
        reasonString = flowUsageDescription
    }
}

extension MPSecurityManager {
    func authorize(onSuccess: @escaping() -> Void, onFailure: @escaping ((String) -> Void)) {
        if !shouldValidateUser() {
            onSuccess()
            return
        }
        // let localizedFallbackTitle = "Test Juan"
        // let localAuthenticationContext = LAContext()
        // localAuthenticationContext.localizedFallbackTitle = localizedFallbackTitle
        var authError: NSError?

        if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
            localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString) { success, evaluateError in
                DispatchQueue.main.async {
                    if success {
                        // Authenticate successfully.
                        onSuccess()
                    } else {
                        // User did not authenticate successfully.
                        guard let error = evaluateError else {
                            return
                        }
                        onFailure(self.getErrorDescription(errorCode: error._code))
                    }
                }
            }
        } else {
            guard let error = authError else {
                return
            }
            // TouchID/FaceID is not available or not enrolled
            onFailure(self.getErrorDescription(errorCode: error._code))
        }
    }

    private func invalidateSession() {
        localAuthenticationContext.invalidate()
    }
}

// MARK: Validation for user.
extension MPSecurityManager {
    func shouldValidateUser() -> Bool {
        return needUserValidation
    }
}

// MARK: Error handler.
extension MPSecurityManager {
    private func getErrorDescription(errorCode: Int) -> String {
        var message: String
        switch errorCode {
        case LAError.authenticationFailed.rawValue:
            message = "The user failed to provide valid credentials"
        case LAError.appCancel.rawValue:
            message = "Authentication was cancelled by application"
        case LAError.invalidContext.rawValue:
            message = "The context is invalid"
        case LAError.notInteractive.rawValue:
            message = "Not interactive"
        case LAError.passcodeNotSet.rawValue:
            message = "Passcode is not set on the device"
        case LAError.systemCancel.rawValue:
            message = "Authentication was cancelled by the system"
        case LAError.userCancel.rawValue:
            message = "The user did cancel"
        case LAError.userFallback.rawValue:
            message = "The user chose to use the fallback"
        default:
            message = getFallbackErrorDescription(errorCode: errorCode)
        }

        #if DEBUG
        print("MPSecurityManager error: \(message)")
        #endif

        return message
    }

    private func getFallbackErrorDescription(errorCode: Int) -> String {
        var message: String = "unknown"
        if #available(iOS 11.0, *) {
            switch errorCode {
            case LAError.biometryNotAvailable.rawValue:
                message = "Authentication could not start because the device does not support biometric authentication."
            case LAError.biometryLockout.rawValue:
                message = "Authentication could not continue because the user has been locked out of biometric authentication, due to failing authentication too many times."
            case LAError.biometryNotEnrolled.rawValue:
                message = "Authentication could not start because the user has not enrolled in biometric authentication."
            default:
                message = "Did not find error code on LAError object"
            }
        } else {
            switch errorCode {
            case LAError.touchIDLockout.rawValue:
                message = "Too many failed attempts."
            case LAError.touchIDNotAvailable.rawValue:
                message = "TouchID is not available on the device"
            case LAError.touchIDNotEnrolled.rawValue:
                message = "TouchID is not enrolled on the device"
            default:
                message = "Did not find error code on LAError object"
            }
        }
        return message
    }
}
