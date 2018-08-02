
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

## Usage
```javascript
import RNBluetoothListener from 'react-native-bluetooth-listener';

class App extends Component<{}> {

  constructor(props) {
    super(props);

    this.state = {
      connectionState : ''
    }
  }

  componentDidMount() {
    RNBluetoothListener.getCurrentState().then(this.handleConnection)
  }

  componentWillMount() {
    RNBluetoothListener.addEventListener('change', this.handleConnection);
  }

  componentWillUnmount() {
    RNBluetoothListener.removeEventListener('change', this.handleConnection)
  }

  handleConnection = (resp) => {
    let {connectionState} = resp.type;
    console.log('type ', connectionState);
    this.setState({connectionState});
  }

  checkBluetooth = () => {
    RNBluetoothListener.getCurrentState().then(resp =>{
      let {connectionState} = resp.type;
      this.setState({connectionState});
    } )
  }
  // Android only Changes bluetooth state. check and request on ios side.
  _toggleBluetooth = () => {
    if (this.state.connectionState === 'on'){
        RNBluetoothListener.enable();
    } else {
        RNBluetoothListener.disable();
    }
  }

  render() {
    return (
      <View style={styles.container}>
        <Button title="Check Bluetooth State" onPress={this.checkBluetooth} />
        <Text style={styles.instructions}>
          Cuurent Bluetooth Status: <Text style={styles.bluetoothStatusText}>{this.state.connectionState}</Text>
        </Text>
        <Button title="Enable Bluetooth" onPress={this._toggleBluetooth} />
      </View>
    );
  }
}
```
### API

| Method| Description |
|:----------------------------------|:----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|**getCurrentState**|Returns an object, `type:on` if bluetooth is enabled, other ways disabled.|
|**enable**|**Android only** Changes bluetooth state. Takes boolean parameter (defaults to true), `true` to enable, `false` to disable. Returns a promise, which returns whether the change was successful or not. Request on IOS.|
|**disable**|**Android only** Disables bluetooth, same end result as calling `enable(false)`. Returns a promise, which returns whether the change was successful or not.|
|**openBluetoothSettings**|**iOS only** Open OS Settings directly to bluetooth settings, recommended to use from Alert dialog, where user decides to change bluetooth state.|

### HANDLER
| Method| Description|
|:----------------------------------|:----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|**change**| Its handle bluetooth state changes, return an object like getCurrentState.|


#### Thanks
Thanks go to [react-native-bluetooth-state](https://github.com/frostney/react-native-bluetooth-state) and [react-native-bluetooth-info](https://github.com/dariyd/react-native-bluetooth-info) librarys.
  