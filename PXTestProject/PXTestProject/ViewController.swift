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
    var accessToken: String
    var lenguage: String
    var color: UIColor
    var paymentProcesorOn: Bool
    var splitPaymentProcesorOn: Bool
    var oneTapOn: Bool

    init(publicKey: String, prefId: String, accessToken: String, lenguage: String, color: UIColor, paymentProcesorOn: Bool, splitPaymentProcesorOn: Bool, oneTapOn: Bool) {
        self.publicKey = publicKey
        self.prefId = prefId
        self.accessToken = accessToken
        self.lenguage = lenguage
        self.color = color
        self.paymentProcesorOn = paymentProcesorOn
        self.splitPaymentProcesorOn = splitPaymentProcesorOn
        self.oneTapOn = oneTapOn
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
}

class ViewController: UIViewController {

    var cases: [String : [String : String]] = [
        "MLA": ["public_key": "TEST-4763b824-93d7-4ca2-a7f7-93539c3ee5bd",
                "pred_id": "243966003-0812580b-6082-4104-9bce-1a4c48a5bc44",
                "access_token": "APP_USR-7092-091314-cc8f836a12b9bf78b16e77e4409ed873-470735636"],
        "MLB": ["public_key": "TEST-4763b824-93d7-4ca2-a7f7-93539c3ee5bd",
                "pred_id": "243966003-0812580b-6082-4104-9bce-1a4c48a5bc44",
                "access_token": "APP_USR-7092-091314-cc8f836a12b9bf78b16e77e4409ed873-470735636"],
        "MLU": ["public_key": "TEST-4763b824-93d7-4ca2-a7f7-93539c3ee5bd",
                "pred_id": "243966003-0812580b-6082-4104-9bce-1a4c48a5bc44",
                "access_token": "APP_USR-7092-091314-cc8f836a12b9bf78b16e77e4409ed873-470735636"],
        "Augusto": ["public_key": "TEST-4763b824-93d7-4ca2-a7f7-93539c3ee5bd",
                "pred_id": "243966003-0812580b-6082-4104-9bce-1a4c48a5bc44",
                "access_token": "APP_USR-7092-091314-cc8f836a12b9bf78b16e77e4409ed873-470735636"]
    ]

    var configs = CheckoutConfigs(publicKey: "TEST-4763b824-93d7-4ca2-a7f7-93539c3ee5bd",
                                  prefId: "243966003-0812580b-6082-4104-9bce-1a4c48a5bc44",
                                  accessToken: "APP_USR-7092-091314-cc8f836a12b9bf78b16e77e4409ed873-470735636",
                                  lenguage: "es",
                                  color: .orange,
                                  paymentProcesorOn: false,
                                  splitPaymentProcesorOn: false,
                                  oneTapOn: true)

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


        //MACROS
        let casesData = Array(cases.keys)
        let macrosView = StringConfigView(title: "Macros", initialValue: casesData.first ?? "", pickerMode: true, data: casesData, callback: { [weak self] (value) in
            print("Selected Data = ", self?.cases[value])
        })

        macrosView.layer.borderWidth = 2
        macrosView.layer.borderColor = UIColor.black.withAlphaComponent(0.4).cgColor
        contentView.addArrangedSubview(macrosView)

        let configsData = getConfigs()
        for configData in configsData {
            var view: UIView?
            switch configData.type {
            case .string:
                view = StringConfigView(title: configData.title, initialValue: configData.initialValue as! String, callback: configData.callback)
            case .bool:
                view = BoolConfigView(title: configData.title, initialValue: configData.initialValue as! Bool, callback: configData.callback)
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

        //Public Key
        let publicKey = ConfigData(title: "Public Key", initialValue: configs.publicKey, type: .string, callback: { [weak self] (value) in
            if let stringValue = value as? String {
                self?.configs.publicKey = stringValue
                print("PK = ", stringValue)
            }
        })
        configsData.append(publicKey)

        //Pref Id
        let prefId = ConfigData(title: "Preference ID", initialValue: configs.prefId, type: .string, callback: { [weak self] (value) in
            if let stringValue = value as? String {
                self?.configs.prefId = stringValue
                print("Pref ID = ", stringValue)
            }
        })
        configsData.append(prefId)

        //Access Token
        let accessToken = ConfigData(title: "Access Token", initialValue: configs.accessToken, type: .string, callback: { [weak self] (value) in
            if let stringValue = value as? String {
                self?.configs.accessToken = stringValue
                print("Access Token = ", stringValue)
            }
        })
        configsData.append(accessToken)

        //Procesadora
        let paymentProcessor = ConfigData(title: "Payment Processor", initialValue: configs.paymentProcesorOn, type: .bool, callback: { [weak self] (value) in
            if let boolValue = value as? Bool {
                self?.configs.paymentProcesorOn = boolValue
                print("Payment Processor On = ", boolValue)
            }
        })
        configsData.append(paymentProcessor)

        //One Tap
        let oneTap = ConfigData(title: "One Tap", initialValue: configs.oneTapOn, type: .bool, callback: { [weak self] (value) in
            if let boolValue = value as? Bool {
                self?.configs.oneTapOn = boolValue
                print("One Tap On = ", boolValue)
            }
        })
        configsData.append(oneTap)

        //Color
        let color = ConfigData(title: "Color", initialValue: configs.color.toHexString(), type: .string, callback: { [weak self] (value) in
            if let stringValue = value as? String, let color = self?.colorWithHexString(hexString: stringValue) {
                self?.configs.color = color
                print("Color = ", stringValue)
            }
        })
        configsData.append(color)

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

        let advancedConfig = PXAdvancedConfiguration()
        advancedConfig.expressEnabled = configs.oneTapOn
        builder.setAdvancedConfiguration(config: advancedConfig)

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

// MARK: Utils
extension ViewController {
    func colorWithHexString(hexString: String, alpha:CGFloat = 1.0) -> UIColor {

        // Convert hex string to an integer
        let hexint = Int(self.intFromHexString(hexStr: hexString))
        let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexint & 0xff) >> 0) / 255.0

        // Create color object, specifying alpha as well
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }

    func intFromHexString(hexStr: String) -> UInt32 {
        var hexInt: UInt32 = 0
        // Create scanner
        let scanner: Scanner = Scanner(string: hexStr)
        // Tell scanner to skip the # character
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
        // Scan hex value
        scanner.scanHexInt32(&hexInt)
        return hexInt
    }

//    func hexFromUIColor(color: UIColor) -> String
//    {
//        let hexString = String(format: "%02X%02X%02X",
//                               Int(CGColor.components(color.cgColor)[0] * 255.0),
//                               Int(CGColorGetComponents(color.CGColor)[1] * 255.0),
//                               Int(CGColorGetComponents(color.CGColor)[2] * 255.0))
//        return hexString
//    }
}

extension UIColor {
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0

        getRed(&r, green: &g, blue: &b, alpha: &a)

        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0

        return String(format:"#%06x", rgb)
    }
}
