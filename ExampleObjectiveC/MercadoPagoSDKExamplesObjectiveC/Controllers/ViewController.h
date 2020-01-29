//
//  ViewController.h
//  ExampleObjectiveC
//
//  Created by AUGUSTO COLLERONE ALFONSO on 29/01/2020.
//  Copyright © 2020 MercadoPago. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifdef PX_PRIVATE_POD
    @import MercadoPagoSDKV4;
#else
    @import MercadoPagoSDK;
#endif

@interface ViewController : UIViewController <PXLifeCycleProtocol>

@property MercadoPagoCheckoutBuilder *checkoutBuilder;

@property PXCheckoutPreference *pref;
@property PXPaymentConfiguration *paymentConfig;

@end

