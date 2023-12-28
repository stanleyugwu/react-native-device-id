import { NativeModules, Platform } from 'react-native';

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
    );

export function multiply(a: number, b: number): Promise<number> {
  return RnDeviceId.multiply(a, b);
}
