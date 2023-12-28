import type { TurboModule } from 'react-native';
import { TurboModuleRegistry } from 'react-native';

export interface Spec extends TurboModule {
  /**
   * Gets the device ID: \
   * `Secure.ANDROID_ID` for Android and device vendor's `UUID` for iOS
   */
  getDeviceId(): Promise<string>;
}

export default TurboModuleRegistry.getEnforcing<Spec>('RnDeviceId');