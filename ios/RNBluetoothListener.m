#import "RNBluetoothListener.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface RNBluetoothInfo ()
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

#pragma mark - public method

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

RCT_EXPORT_METHOD(openBluetoothSettings:(RCTResponseSenderBlock) callback) {
    NSLog(@"iOS: trying to open settings");
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10.0")) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"App-Prefs:root=Bluetooth"]];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=Bluetooth"]];
    }
    callback(@[[NSNull null]]);
}

@end
