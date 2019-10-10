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

class CheckoutConfigs {
    var publicKey: String
    var prefId: String
    var lenguage: String
    var color: UIColor
    var paymentProcesorOn: Bool
    var splitPaymentProcesorOn: Bool

    init(publicKey: String, prefId: String, lenguage: String, color: UIColor, paymentProcesorOn: Bool, splitPaymentProcesorOn: Bool) {
        self.publicKey = publicKey
        self.prefId = prefId
        self.lenguage = lenguage
        self.color = color
        self.paymentProcesorOn = paymentProcesorOn
        self.splitPaymentProcesorOn = splitPaymentProcesorOn
    }
}

struct ConfigData {
    let title: String
    let initialValue: Any
    let type: ConfigType
    let callback: (Any) -> Void
}

public enum ConfigType {
    case string
    case bool
    case color
}

class ViewController: UIViewController {

    var configs = CheckoutConfigs(publicKey: "TEST-4763b824-93d7-4ca2-a7f7-93539c3ee5bd",
                                  prefId: "243966003-0812580b-6082-4104-9bce-1a4c48a5bc44",
                                  lenguage: "es",
                                  color: .orange,
                                  paymentProcesorOn: false,
                                  splitPaymentProcesorOn: false)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Checkout Config"
        render()
    }

    private func render() {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100)
        ])

        let startButton = UIButton()
        startButton.setTitle("Start Checkout", for: .normal)
        startButton.backgroundColor = .blue
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        view.addSubview(startButton)

        NSLayoutConstraint.activate([
            startButton.heightAnchor.constraint(equalToConstant: 40),
            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            startButton.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 30),
            startButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30)
        ])

        //CONTENT VIEW
        let contentView = UIStackView()
        contentView.axis = .vertical
        contentView.backgroundColor = .yellow
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

        //Content View Layout
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])


        let configsData = getConfigs()

        for configData in configsData {
            var view: UIView?
            switch configData.type {
            case .string:
                view = StringConfigView(title: configData.title, initialValue: configData.initialValue as! String, callback: configData.callback)
            case .bool:
                view = BoolConfigView(title: configData.title, initialValue: configData.initialValue as! Bool, callback: configData.callback)
            case .color:
                view = nil
            }

            if let view = view {
                view.layer.borderWidth = 1
                view.layer.borderColor = UIColor.black.withAlphaComponent(0.4).cgColor
                contentView.addArrangedSubview(view)
            }
        }
    }

    func getConfigs() -> [ConfigData] {
        var configsData = [ConfigData]()

        //Pref Id
        let prefId = ConfigData(title: "Public Key", initialValue: configs.publicKey, type: .string, callback: { [weak self] (value) in
            if let stringValue = value as? String {
                self?.configs.publicKey = stringValue
                print("PK = ", stringValue)
            }
        })
        configsData.append(prefId)

        //Procesadora
        let paymentProcessor = ConfigData(title: "Payment Processor", initialValue: configs.paymentProcesorOn, type: .bool, callback: { [weak self] (value) in
            if let boolValue = value as? Bool {
                self?.configs.paymentProcesorOn = boolValue
                print("Payment Processor On = ", boolValue)
            }
        })
        configsData.append(paymentProcessor)

        return configsData
    }

    @objc func startButtonTapped() {
        runMercadoPagoCheckout(configs: configs)
    }

    private func runMercadoPagoCheckout(configs: CheckoutConfigs) {
        // 1) Create Builder with your publicKey and preferenceId.
        let builder = MercadoPagoCheckoutBuilder(publicKey: configs.publicKey, preferenceId: configs.prefId)

        //Language customization
        builder.setLanguage(configs.lenguage)

        //Color customization
        builder.setColor(checkoutColor: configs.color)

        let trackingConfig = PXTrackingConfiguration(trackListener: self, flowName: "instore", flowDetails: [:], sessionId: "123456")
        builder.setTrackingConfiguration(config: trackingConfig)

        // 2) Create Checkout
        let checkout: MercadoPagoCheckout = MercadoPagoCheckout(builder: builder)

        // 3) Start with your navigation controller.
        if let myNavigationController = navigationController {
            checkout.start(navigationController: myNavigationController)
        }
    }


}
extension ViewController: PXTrackerListener {
    func trackScreen(screenName: String, extraParams: [String : Any]?) {
        print("track screen")
    }

    func trackEvent(screenName: String?, action: String!, result: String?, extraParams: [String : Any]?) {
        print("track event")
    }
}

