import { NativeModules, Platform } from 'react-native';

/**
 *  Device ID interface 
 */
interface DeviceID {
  /**
   * Gets the device ID. This is `Secure.ANDROID_ID` for Android and device vendor's `UUID` for iOS
   */
  getDeviceId(): Promise<string>;
}

const LINKING_ERROR =
  `The package '@devvie/rn-device-id' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

// @ts-expect-error
const isTurboModuleEnabled = global.__turboModuleProxy != null;

const RnDeviceIdModule = isTurboModuleEnabled
  ? require('./NativeRnDeviceId').default
  : NativeModules.RnDeviceId;

const RnDeviceId = RnDeviceIdModule
  ? RnDeviceIdModule
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    ) as DeviceID;

/**
 * Gets the device ID. This is `Secure.ANDROID_ID` for Android and device vendor's `UUID` for iOS
 */
export function getDeviceId(): Promise<string> {
  return RnDeviceId.getDeviceId();
}

export default RnDeviceId as DeviceID
