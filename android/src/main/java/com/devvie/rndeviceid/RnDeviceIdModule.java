package com.devvie.rndeviceid;

import androidx.annotation.NonNull;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactMethod;

import android.provider.Settings;
import java.util.HashMap;
import java.util.Map;
import static android.provider.Settings.Secure.getString;

public class RnDeviceIdModule extends RnDeviceIdSpec {
  public static final String NAME = "RnDeviceId";

  RnDeviceIdModule(ReactApplicationContext context) {
    super(context);
  }

  @Override
  @NonNull
  public String getName() {
    return NAME;
  }

  // main method to get device ID
  @ReactMethod(isBlockingSynchronousMethod = false)
    public void getDeviceId(Promise promise) { promise.resolve(getString(getReactApplicationContext().getContentResolver(), Settings.Secure.ANDROID_ID)); }

}
