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

  // overrides getConstants method of the bridge to create a constant 
  // object with property deviceId which holds the return value of getDeviceId method.
  // this constant object can be accessed from JS side by calling getConstants() on this
  // class. I.e DeviceId.getConstants().deviceId
  @Override
    public Map<String, Object> getConstants(){
        final Map<String, Object> constants = new HashMap<>();
        constants.put("deviceId", getDeviceId());
        return constants;
    }

  // main method to get device ID
  @ReactMethod(isBlockingSynchronousMethod = false)
    public void getDeviceId(Promise promise) { promise.resolve(getString(getReactApplicationContext().getContentResolver(), Settings.Secure.ANDROID_ID)); }

}
