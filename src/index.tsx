import { NativeModules, Platform } from 'react-native';

const LINKING_ERROR =
  `The package 'upi-uri-payment' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

const UpiUriPayment = NativeModules.UpiUriPayment
  ? NativeModules.UpiUriPayment
  : new Proxy(
    {},
    {
      get() {
        throw new Error(LINKING_ERROR);
      },
    }
  );

export function openUPIApp(url: string): Promise<number> {
  let upiUrl = url;

  if (Platform.OS == 'ios') {
    upiUrl = upiUrl.replaceAll("upi://pay", "upi/pay")
  }
  return UpiUriPayment.openUPIApp(upiUrl);
}
