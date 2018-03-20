#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface RNBluetoothListener : RCTEventEmitter <RCTBridgeModule, CBCentralManagerDelegate>


@end
  
