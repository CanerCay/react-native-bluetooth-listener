#import "RNBluetoothListener.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface RNBluetoothListener ()
@property (nonatomic, strong) CBCentralManager *bluetoothManager;
@end

@implementation RNBluetoothListener

RCT_EXPORT_MODULE();

- (CBCentralManager *)bluetoothManager
{
    if (!_bluetoothManager) {
        _bluetoothManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue() options:@{CBCentralManagerOptionShowPowerAlertKey: @(NO)}];
    }
    
    return _bluetoothManager;
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    [self sendEventWithName:@"bluetoothDidUpdateState" body:@{@"connectionState": [self getConnectionState]}];
}

- (void)startObserving
{
    //[self sendEventWithName:@"bluetoothDidUpdateState" body:@{@"connectionState": [self getConnectionState]}];
}

- (void)stopObserving
{
    //_bluetoothManager = nil;
}


- (NSString *)getConnectionState
{
    NSString *bluetoothState = nil;
    switch(self.bluetoothManager.state)
    {
        case CBCentralManagerStateResetting: bluetoothState = @"resetting"; break;
        case CBCentralManagerStateUnsupported: bluetoothState = @"unsupported"; break;
        case CBCentralManagerStateUnauthorized: bluetoothState = @"unauthorized"; break;
        case CBCentralManagerStatePoweredOff: bluetoothState = @"off"; break;
        case CBCentralManagerStatePoweredOn: bluetoothState = @"on"; break;
        default: bluetoothState = @"unknown"; break;
    }
    NSLog(@"bluetoothState %@", bluetoothState);
    return bluetoothState;
}

- (NSArray<NSString *> *)supportedEvents
{
    return @[@"bluetoothDidUpdateState"];
}

RCT_EXPORT_METHOD(getCurrentState:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)
{
    if (!self.bluetoothManager) {
        NSError * error;
        reject(@"no_bluetooth_init", @"Bluetooth manager cannot be initialized", error);
    } else {
        resolve(@{@"connectionState": [self getConnectionState]});
    }
    
}

RCT_EXPORT_METHOD(setBluetoothOn:(RCTResponseSenderBlock)callback)
{
    if (self.checkBluetoothAccess){
        [self requestBluetoothAccess];
        callback(@[[NSNull null], @[[NSNull null]]]);
    } else {
        callback(@[[NSNull null], @[[NSNull null]]]);
    }
}

- (Boolean)checkBluetoothAccess {
    if(!self.bluetoothManager) {
        self.bluetoothManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    }
    
    /*
     We can ask the bluetooth manager ahead of time what the authorization status is for our bundle and take the appropriate action.
     */
    CBCentralManagerState state = [self.bluetoothManager state];
    
    if(state != CBCentralManagerStateUnknown && state != CBCentralManagerStateUnauthorized) {
        return true;
    }
    return false;
}


- (void)requestBluetoothAccess {
    if(!self.bluetoothManager) {
        self.bluetoothManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    }
    /*
     When the application requests to start scanning for bluetooth devices that is when the user is presented with a consent dialog.
     */
    [self.bluetoothManager scanForPeripheralsWithServices:nil options:nil];
}

@end
