
# react-native-bluetooth-listener

## Getting started

`$ npm install react-native-bluetooth-listener --save`

### Mostly automatic installation

`$ react-native link react-native-bluetooth-listener`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-bluetooth-listener` and add `RNBluetoothListener.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNBluetoothListener.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import com.reactlibrary.RNBluetoothListenerPackage;` to the imports at the top of the file
  - Add `new RNBluetoothListenerPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-bluetooth-listener'
  	project(':react-native-bluetooth-listener').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-bluetooth-listener/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-bluetooth-listener')
  	```

#### Windows
[Read it! :D](https://github.com/ReactWindows/react-native)

1. In Visual Studio add the `RNBluetoothListener.sln` in `node_modules/react-native-bluetooth-listener/windows/RNBluetoothListener.sln` folder to their solution, reference from their app.
2. Open up your `MainPage.cs` app
  - Add `using Bluetooth.Listener.RNBluetoothListener;` to the usings at the top of the file
  - Add `new RNBluetoothListenerPackage()` to the `List<IReactPackage>` returned by the `Packages` method


## Usage
```javascript
import RNBluetoothListener from 'react-native-bluetooth-listener';

// TODO: What to do with the module?
RNBluetoothListener;
```
  