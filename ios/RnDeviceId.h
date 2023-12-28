#import <UIKit/UIKit.h>

// conditional header import and 
// interface protocol (<RCTBridgeModule>) extension
// based on if react native new architecture is enabled or not
#ifdef RCT_NEW_ARCH_ENABLED
#import "RNRnDeviceIdSpec.h"

@interface RnDeviceId : NSObject <NativeRnDeviceIdSpec>
#else
#import <React/RCTBridgeModule.h>

@interface RnDeviceId : NSObject <RCTBridgeModule>
#endif

@end
