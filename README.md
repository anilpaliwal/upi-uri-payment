**upi-uri-payment**

`upi-uri-payment` is a native module for React Native that facilitates UPI (Unified Payments Interface) payments. This module provides a method called openUPIApp which takes a UPI payment intent URL as a parameter and opens a bottom sheet displaying installed UPI apps on the device. Selecting a specific app navigates the user to that app to complete the payment.

**Features**

- Opens a bottom sheet with installed UPI apps on the device.
+ Navigates to the selected UPI app to complete the payment.
- Supports both Android and iOS platforms.

**Installation**

**Using npm**
```
npm install upi-uri-payment
```

**Using yarn**
```
yarn add upi-uri-payment
```


**Linking the Package**
For React Native versions 0.60 and above, the package is automatically linked. For older versions, you need to link the package manually:

```
react-native link upi-uri-payment
```

**Usage** 

To use the `upi-uri-payment` module, import it into your React Native component and call the `openUPIApp` method with the UPI payment intent URL as a parameter.

**Example**

```
import React from 'react';
import { Button, View } from 'react-native';
import { openUPIApp } from 'upi-uri-payment';

const App = () => {
  const handlePayment = () => {
    const upiPaymentUrl = 'upi://pay?pa=example@upi&pn=Example%20Merchant&am=10&cu=INR';
    openUPIApp(upiPaymentUrl);
  };

  return (
    <View>
      <Button title="Pay with UPI" onPress={handlePayment} />
    </View>
  );
};

export default App;
```

**Parameters**

- `upiPaymentUrl` (string): The UPI payment intent URL.

**Methods**

`openUPIApp(upiPaymentUrl)`

Opens a bottom sheet displaying installed UPI apps and navigates to the selected app for completing the payment.

**Platforms Supported**

- Android
+ iOS

**Contributing**

Contributions are welcome! Please open an issue or submit a pull request if you have any suggestions or improvements.

**License**

This project is licensed under the MIT License.

**Author**

[Anil Paliwal](https://github.com/anilpaliwal)
