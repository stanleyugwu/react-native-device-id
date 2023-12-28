
#ifdef RCT_NEW_ARCH_ENABLED
#import "RNRnDeviceIdSpec.h"

@interface RnDeviceId : NSObject <NativeRnDeviceIdSpec>
#else
#import <React/RCTBridgeModule.h>

@interface RnDeviceId : NSObject <RCTBridgeModule>
#endif

@end
