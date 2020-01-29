//
//  ViewController.m
//  ExampleObjectiveC
//
//  Created by AUGUSTO COLLERONE ALFONSO on 29/01/2020.
//  Copyright © 2020 MercadoPago. All rights reserved.
//

#import "ViewController.h"

#ifdef PX_PRIVATE_POD
    @import MercadoPagoSDKV4;
#else
    @import MercadoPagoSDK;
#endif

@implementation ViewController

- (void)viewDidLoad {
    // [self runMercadoPagoCheckout];
    [self runMercadoPagoCheckoutWithLifecycle];
}

-(void)runMercadoPagoCheckout {
    // 1) Create Builder with your publicKey and preferenceId.
    self.checkoutBuilder = [[[MercadoPagoCheckoutBuilder alloc] initWithPublicKey:@"TEST-4763b824-93d7-4ca2-a7f7-93539c3ee5bd" preferenceId:@"243966003-0812580b-6082-4104-9bce-1a4c48a5bc44"] setLanguage:@"es"];

    // 2) Create Checkout reference
    MercadoPagoCheckout *mpCheckout = [[MercadoPagoCheckout alloc] initWithBuilder:self.checkoutBuilder];


    // 3) Start with your navigation controller.
    [mpCheckout startWithNavigationController:self.navigationController lifeCycleProtocol:NULL];
}

-(void)runMercadoPagoCheckoutWithLifecycle {
    // 1) Create Builder with your publicKey and preferenceId.
    self.checkoutBuilder = [[[MercadoPagoCheckoutBuilder alloc] initWithPublicKey:@"TEST-4763b824-93d7-4ca2-a7f7-93539c3ee5bd" preferenceId:@"243966003-0812580b-6082-4104-9bce-1a4c48a5bc44"] setLanguage:@"es"];

    // 2) Create Checkout reference
    MercadoPagoCheckout *mpCheckout = [[MercadoPagoCheckout alloc] initWithBuilder:self.checkoutBuilder];


    // 3) Start with your navigation controller.
    [mpCheckout startWithNavigationController:self.navigationController lifeCycleProtocol:self];
}

// MARK: Optional Lifecycle protocol implementation example.
-(void (^ _Nullable)(void))cancelCheckout {
    return ^ {
        [self.navigationController popViewControllerAnimated:YES];
    };
}

- (void (^)(id<PXResult> _Nullable))finishCheckout {
    return nil;
}

-(void (^)(void))changePaymentMethodTapped {
    return ^ {
        NSLog(@"px - changePaymentMethodTapped");
    };
}

@end

