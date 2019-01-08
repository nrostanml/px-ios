//
//  PXSummaryAmount.swift
//  FXBlurView
//
//  Created by Demian Tejo on 13/12/18.
//

import Foundation

class PXSummaryAmount: NSObject, Codable {
    let payerCostConfigurations: [String: PXPayerCostConfiguration]?
    let discountConfigurations: [String: PXDiscountConfiguration]?
    let selectedAmountConfigurationId: String
    var selectedAmountConfiguration: PXPaymentOptionConfiguration {
        get {
            return PXPaymentOptionConfiguration(id: selectedAmountConfigurationId, discountConfiguration: discountConfigurations?[selectedAmountConfigurationId], payerCostConfiguration: payerCostConfigurations?[selectedAmountConfigurationId])
        }
    }

    init(payerCostConfigurations: [String: PXPayerCostConfiguration]?, discountConfigurations: [String: PXDiscountConfiguration]?, selectedAmountConfigurationId: String) {
        self.payerCostConfigurations = payerCostConfigurations
        self.discountConfigurations = discountConfigurations
        self.selectedAmountConfigurationId = selectedAmountConfigurationId
    }

    public enum PXSummaryAmountKeys: String, CodingKey {
        case payerCostConfigurations = "payer_cost_configurations"
        case discountConfigurations = "discounts_configurations"
        case  selectedAmountConfigurationId = "selected_amount_configuration"
    }
    required public convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PXSummaryAmountKeys.self)
        let discountConfigurations: [String: PXDiscountConfiguration]? = try container.decodeIfPresent([String: PXDiscountConfiguration].self, forKey: .discountConfigurations)
        let payerCostConfigurations: [String: PXPayerCostConfiguration]? = try container.decodeIfPresent([String: PXPayerCostConfiguration].self, forKey: .payerCostConfigurations)
        let selectedAmountConfigurationId: String? = try container.decodeIfPresent(String.self, forKey: .selectedAmountConfigurationId)

        self.init(payerCostConfigurations: payerCostConfigurations, discountConfigurations: discountConfigurations, selectedAmountConfigurationId: selectedAmountConfigurationId!)
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: PXSummaryAmountKeys.self)
        try container.encodeIfPresent(self.payerCostConfigurations, forKey: .payerCostConfigurations)
        try container.encodeIfPresent(self.discountConfigurations, forKey: .discountConfigurations)
        try container.encodeIfPresent(self.selectedAmountConfigurationId, forKey: .selectedAmountConfigurationId)
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
    open class func fromJSON(data: Data) throws -> PXSummaryAmount {
        return try JSONDecoder().decode(PXSummaryAmount.self, from: data)
    }
}
