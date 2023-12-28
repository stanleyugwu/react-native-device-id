#import "RnDeviceId.h"

/**
* This class exposes a `getDeviceId` instance method to get the unique Id of the device
*/

// extend RnDeviceId public interface in "RnDeviceId.h" 
// to add _keychainIdKey and _deviceID properties only for this module
@interface RnDeviceId ()

@property(nonatomic, strong, readonly) NSString *_keychainIdKey; // keychain key for storing device Id
@property(nonatomic, strong, readonly) NSString *_deviceID; // class propery to hold device Id

@end

// implement the RnDeviceId interface declared in RnDeviceId header file
// and extended here above
@implementation RnDeviceId
RCT_EXPORT_MODULE() // Exposes this module over the bridge as object 'DeviceId'

// shortcut class method which when called
// instanciate DeviceId class, call the initWithKey instance
// method with "deviceID" argument and calls getDeviceId instance method of
// the return value of initWithKey which is an instance of DeviceId
+ (NSString *)getDeviceId {
    NSString *idKey = @"_deviceID_"; // keychain key
    return [[[DeviceId alloc] initWithKey:idKey] getDeviceId];
}

// instance method that sets __keychainIdKey to given key argument and
// returns an instance of this class (DeviceId)
- (id)initWithKey:(NSString *)key {
    self = [super init];
    if(self) {
        __keychainIdKey = key;
        _deviceID = nil;
    }
    return self;
}

// instance method to save the value of _deviceID class property to
// keychain with __keychainIdKey as the key
- (void)save {
  if (![DeviceId valueForKeychainKey:__keychainIdKey service:__keychainIdKey]) {
    [DeviceId setValue:_deviceID forKeychainKey:__keychainIdKey inService:__keychainIdKey];
  }
}

// class method to get an item (as an object) with given key from the keychain
+ (NSMutableDictionary *)keychainItemForKey:(NSString *)key service:(NSString *)service {
    NSMutableDictionary *keychainItem = [[NSMutableDictionary alloc] init];
    keychainItem[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
    keychainItem[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleAlways;
    keychainItem[(__bridge id)kSecAttrAccount] = key;
    keychainItem[(__bridge id)kSecAttrService] = service;
    return keychainItem;
}

// class method that gets the value of a key from keychain, changes it to given value,
// encodes it to UTF8, and stores it back to keychain. It's called by save.
// put simply, it sets given value (encoded) for the given key, in the keychain
+ (OSStatus)setValue:(NSString *)value forKeychainKey:(NSString *)key inService:(NSString *)service {
    NSMutableDictionary *keychainItem = [[self class] keychainItemForKey:key service:service];
    keychainItem[(__bridge id)kSecValueData] = [value dataUsingEncoding:NSUTF8StringEncoding];
    return SecItemAdd((__bridge CFDictionaryRef)keychainItem, NULL);
}

// class method to get an item (as UTF8-encoded string) with given key from the keychain
+ (NSString *)valueForKeychainKey:(NSString *)key service:(NSString *)service {
    OSStatus status;
    NSMutableDictionary *keychainItem = [[self class] keychainItemForKey:key service:service];
    keychainItem[(__bridge id)kSecReturnData] = (__bridge id)kCFBooleanTrue;
    keychainItem[(__bridge id)kSecReturnAttributes] = (__bridge id)kCFBooleanTrue;
    CFDictionaryRef result = nil;
    status = SecItemCopyMatching((__bridge CFDictionaryRef)keychainItem, (CFTypeRef *)&result);
    if (status != noErr) {
        return nil;
    }
    NSDictionary *resultDict = (__bridge_transfer NSDictionary *)result;
    NSData *data = resultDict[(__bridge id)kSecValueData];
    if (!data) {
        return nil;
    }
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

 // class method that retrieves the Universally Unique Identifier (UUID) string 
 // associated with the vendor of the device. 
+ (NSString *)randomUUID {
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

// overrides constantsToExport method of the bridge to create a constant 
// object with property deviceId which holds the return value of getDeviceId method.
// this constant object can be accessed from JS side by calling getConstants() on this
// class. I.e DeviceId.getConstants().deviceId
- (NSDictionary *)constantsToExport {
    return @{
        @"deviceId": [DeviceId getDeviceId]
    };
    
}

// needed by react native.
// return YES if module is calling UI or overrrides constantsToExport,
// and NO otherwise
+ (BOOL)requiresMainQueueSetup
{
    return YES;
}

// => imported END

// getDeviceId is main method - exposed via RCT_EXPORT_METHOD - to be called
// from the JS side through the bridge to get device id.
// it's the entry point of this module from the JS side
RCT_EXPORT_METHOD(getDeviceId:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)
{
    // if device id (_deviceID) not set already, try to get any 
    // previously stored device id from keychain and return it
    if (!_deviceID) _deviceID = [[self class] valueForKeychainKey:__keychainIdKey service:__keychainIdKey];

    // if device id wasn't found in keychain, get the 
    // device UUID (randomUUID) and save it in the keychain [self save]
    if (!_deviceID) _deviceID = [[self class] randomUUID];
    [self save];

    // at this point device id (_deviceID) should be set either 
    // by getting the value from keychain or from device (UUID).
    // resolve is called to return result back to caller
    // function which is on JS side, as a promise, over the bridge
    resolve(_deviceID);
}

// Don't compile this code when we build for the old architecture.
#ifdef RCT_NEW_ARCH_ENABLED
- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeRnDeviceIdSpecJSI>(params);
}
#endif

@end
