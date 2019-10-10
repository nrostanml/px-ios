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

class StringConfigView: UIView, UITextFieldDelegate {
    let title: String
    let initialValue: String
    let callback: (String) -> Void

    init(title: String, initialValue: String, callback: @escaping (String) -> Void) {
        self.title = title
        self.initialValue = initialValue
        self.callback = callback
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        render()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func render() {
        self.isUserInteractionEnabled = true
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = title
        addSubview(label)

        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
        ])

        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = UITextField.BorderStyle.line
        textField.placeholder = "Enter text here"
        textField.text = initialValue
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.clearButtonMode = UITextField.ViewMode.whileEditing;
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        textField.delegate = self

        addSubview(textField)

        NSLayoutConstraint.activate([
            textField.centerYAnchor.constraint(equalTo: centerYAnchor),
            textField.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            textField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6)
        ])

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 80)
        ])
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return false
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        print("TextField did end editing method called")
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
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
        renderConfigsViews()
    }

    private func renderConfigsViews() {
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

        let publicKeyView = StringConfigView(title: "Public Key", initialValue: configs.publicKey) { (value) in
            print(value)
        }

        let prefIdView = StringConfigView(title: "Preference ID", initialValue: configs.prefId) { (value) in
            print(value)
        }

        let configViews: [UIView] = [publicKeyView, prefIdView]

        for view in configViews {
            contentView.addArrangedSubview(view)
        }
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

