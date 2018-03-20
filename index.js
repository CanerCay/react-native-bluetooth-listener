import {NativeEventEmitter, NativeModules, Platform} from 'react-native';

const {RNBluetoothListener} = NativeModules;
const BluetoothInfoEventEmitter = new NativeEventEmitter(RNBluetoothListener);


const DEVICE_CONNECTIVITY_EVENT = 'bluetoothDidUpdateState';

const _subscriptions = new Map();

const BluetoothManager = {

    addEventListener(eventName, handler): { remove: () => void } {
        let listener;
        if (eventName === 'change') {
            listener = BluetoothInfoEventEmitter.addListener(
                DEVICE_CONNECTIVITY_EVENT,
                (appStateData) => {
                    handler({
                        type: appStateData,
                    });
                }
            );
        } else {
            console.warn('Trying to subscribe to unknown event: "' + eventName + '"');
            return {
                remove: () => {
                }
            };
        }

        _subscriptions.set(handler, listener);
        return {
            remove: () => BluetoothManager.removeEventListener(eventName, handler)
        };
    },

    /**
     * Removes the listener for network status changes.
     */
    removeEventListener(eventName, handler) {
        const listener = _subscriptions.get(handler);
        if (!listener) {
            return;
        }
        listener.remove();
        _subscriptions.delete(handler);
    },

    /**
     * Returns a promise that resolves to an object with `type key
     */
    getCurrentState() {
        return RNBluetoothListener.getCurrentState().then(resp => {
            return {
                type: resp,
            };
        });
    },

    async enable(enabled: boolean = true) {
        return new Promise((resolve, reject) => {
            if (Platform.OS === 'android') {
                if (enabled) {
                    RNBluetoothListener.setBluetoothOn((error, done) => {
                        if (error) {
                            reject(error);
                            return;
                        }
                        resolve(done);
                    });
                } else {
                    RNBluetoothListener.setBluetoothOff((error, done) => {
                        if (error) {
                            reject(error);
                            return;
                        }
                        resolve(done);
                    });
                }
            } else {
                reject('Unsupported platform');
            }
        });
    },

    async disable() {
        return this.enable(false);
    },

    openBluetoothSettings() {
        if (Platform.OS === 'ios') {
            RNBluetoothListener.openBluetoothSettings(() => {
            })
        }
    }
};

export default BluetoothManager;


