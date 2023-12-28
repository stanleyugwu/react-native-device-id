package com.devvie.rndeviceid;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.Promise;

abstract class RnDeviceIdSpec extends ReactContextBaseJavaModule {
  RnDeviceIdSpec(ReactApplicationContext context) {
    super(context);
  }

  public abstract void getDeviceId(Promise promise);
}
