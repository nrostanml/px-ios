//
//  PXBehaviour.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 09/03/2020.
//

import Foundation

public struct PXBehaviour: Codable {
    let modal: String?
    let target: String?

    enum Behaviours: String {
        case switchSplit = "switch_split"
        case tapPay = "tap_pay"
        case tapCard = "tap_card"
    }
}
