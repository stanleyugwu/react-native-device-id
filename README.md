# React Native Device ID

Fetches the device ID for both Android and iOS.
On __Android__ this will be `Secure.ANDROID_ID`, on __iOS__ this will be the device vendor's `UUID`

## Installation

```sh
npm install @devvie/rn-device-id
```

## Usage

```js
import { getDeviceId } from '@devvie/rn-device-id';

// ...

const deviceId = await getDeviceId(3, 7);
```

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT

---

Made with [create-react-native-library](https://github.com/callstack/react-native-builder-bob)
