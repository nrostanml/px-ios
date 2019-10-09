//
//  ViewController.swift
//  PXTestProject
//
//  Created by AUGUSTO COLLERONE ALFONSO on 08/10/2019.
//  Copyright © 2019 Mercado Pago. All rights reserved.
//

import UIKit
import MercadoPagoSDK

//#if PX_PRIVATE_POD
//import MercadoPagoSDKV4
//#else
//import MercadoPagoSDK
//#endif

struct CheckoutConfigs {
    let publicKey: String
    let prefId: String
    let lenguage: String
    let color: UIColor
    let paymentProcesorOn: Bool
    let splitPaymentProcesorOn: Bool
}

class ViewController: UIViewController {

    private var checkout: MercadoPagoCheckout?
    var configs = CheckoutConfigs(publicKey: "TEST-4763b824-93d7-4ca2-a7f7-93539c3ee5bd",
                                  prefId: "243966003-0812580b-6082-4104-9bce-1a4c48a5bc44",
                                  lenguage: "es",
                                  color: .orange,
                                  paymentProcesorOn: false,
                                  splitPaymentProcesorOn: false)

    override func viewDidLoad() {
        super.viewDidLoad()
        runMercadoPagoCheckout(configs: configs)
    }

    private func runMercadoPagoCheckout(configs: CheckoutConfigs) {
        // 1) Create Builder with your publicKey and preferenceId.
        let builder = MercadoPagoCheckoutBuilder(publicKey: configs.publicKey, preferenceId: configs.prefId)

        //Language customization
        builder.setLanguage(configs.lenguage)

        //Color customization
        builder.setColor(checkoutColor: configs.color)

        // 2) Create Checkout
        checkout = MercadoPagoCheckout(builder: builder)

        // 3) Start with your navigation controller.
        if let myNavigationController = navigationController {
            checkout?.start(navigationController: myNavigationController)
        }
    }


}

