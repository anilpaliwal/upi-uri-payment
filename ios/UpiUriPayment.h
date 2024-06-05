
#ifdef RCT_NEW_ARCH_ENABLED
#import "RNUpiUriPaymentSpec.h"

@interface UpiUriPayment : NSObject <NativeUpiUriPaymentSpec>
#else
#import <React/RCTBridgeModule.h>

@interface UpiUriPayment : NSObject <RCTBridgeModule>
#endif

@end
