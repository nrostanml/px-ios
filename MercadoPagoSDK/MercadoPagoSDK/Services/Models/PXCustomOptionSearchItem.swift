//
//  PXCustomOptionSearchItem.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 10/20/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation
/// :nodoc:
open class PXCustomOptionSearchItem: NSObject, Codable {
    open var id: String!
    open var _description: String?
    open var paymentMethodId: String?
    open var paymentTypeId: String?
    open var discountInfo: String?
    open var selectedAmountConfiguration: String
    open var selectedPayerCostConfiguration: PXPayerCostConfiguration?
    open var payerCostConfigurations: [String: PXPayerCostConfiguration]
    open var comment: String?

    public init(id: String, description: String?, paymentMethodId: String?, paymentTypeId: String?, discountInfo: String?, selectedAmountConfiguration: String, payerCostConfigurations: [String: PXPayerCostConfiguration], comment: String?) {
        self.id = id
        self._description = description
        self.paymentMethodId = paymentMethodId
        self.paymentTypeId = paymentTypeId
        self.discountInfo = discountInfo
        self.selectedAmountConfiguration = selectedAmountConfiguration
        self.payerCostConfigurations = payerCostConfigurations
        self.comment = comment

        if let selectedPayerCostConfiguration = payerCostConfigurations[selectedAmountConfiguration] {
            self.selectedPayerCostConfiguration = selectedPayerCostConfiguration
        }
    }

    public enum PXCustomOptionSearchItemKeys: String, CodingKey {
        case id
        case description
        case paymentMethodId = "payment_method_id"
        case paymentTypeId = "payment_type_id"
        case discountInfo = "discount_info"
        case selectedAmountConfiguration = "selected_amount_configuration"
        case payerCostConfigurations = "payer_cost_configurations"
        case comment = "comment"
    }

    required public convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PXCustomOptionSearchItemKeys.self)
        let id: String = try container.decode(String.self, forKey: .id)
        let description: String? = try container.decodeIfPresent(String.self, forKey: .description)
        let paymentMethodId: String? = try container.decodeIfPresent(String.self, forKey: .paymentMethodId)
        let paymentTypeId: String? = try container.decodeIfPresent(String.self, forKey: .paymentTypeId)
        let comment: String? = try container.decodeIfPresent(String.self, forKey: .comment)
        let discountInfo: String? = try container.decodeIfPresent(String.self, forKey: .discountInfo)
        let selectedAmountConfiguration: String = try container.decode(String.self, forKey: .selectedAmountConfiguration)
        let payerCostConfigurations: [String: PXPayerCostConfiguration] = try container.decode([String: PXPayerCostConfiguration].self, forKey: .payerCostConfigurations)

        self.init(id: id, description: description, paymentMethodId: paymentMethodId, paymentTypeId: paymentTypeId, discountInfo: discountInfo, selectedAmountConfiguration: selectedAmountConfiguration, payerCostConfigurations: payerCostConfigurations, comment: comment)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: PXCustomOptionSearchItemKeys.self)
        try container.encodeIfPresent(self.id, forKey: .id)
        try container.encodeIfPresent(self._description, forKey: .description)
        try container.encodeIfPresent(self.paymentMethodId, forKey: .paymentMethodId)
        try container.encodeIfPresent(self.paymentTypeId, forKey: .paymentTypeId)
        try container.encodeIfPresent(self.discountInfo, forKey: .discountInfo)
        try container.encodeIfPresent(self.selectedAmountConfiguration, forKey: .selectedAmountConfiguration)
        try container.encodeIfPresent(self.payerCostConfigurations, forKey: .payerCostConfigurations)
        try container.encodeIfPresent(self.comment, forKey: .comment)
    }

    open func toJSONString() throws -> String? {
        let encoder = JSONEncoder()
        let data = try encoder.encode(self)
        return String(data: data, encoding: .utf8)
    }

    open func toJSON() throws -> Data {
        let encoder = JSONEncoder()
        return try encoder.encode(self)
    }

    open class func fromJSONToPXCustomOptionSearchItem(data: Data) throws -> PXCustomOptionSearchItem {
        return try JSONDecoder().decode(PXCustomOptionSearchItem.self, from: data)
    }

    open class func fromJSON(data: Data) throws -> [PXCustomOptionSearchItem] {
        return try JSONDecoder().decode([PXCustomOptionSearchItem].self, from: data)
    }
}
