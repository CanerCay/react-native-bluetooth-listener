import {NativeEventEmitter, NativeModules, Platform} from "react-native";

const {RNBluetoothListener} = NativeModules;

// console.log("RNBluetoothListener", RNBluetoothListener);
let BluetoothManager = {};

if (RNBluetoothListener) {
    const BluetoothInfoEventEmitter = new NativeEventEmitter(RNBluetoothListener);
    const DEVICE_CONNECTIVITY_EVENT = "bluetoothDidUpdateState";

    const _subscriptions = new Map();

    BluetoothManager = {

        addEventListener(eventName, handler): { remove: () => void } {
            let listener;
            if (eventName === "change") {
                listener = BluetoothInfoEventEmitter.addListener(
                    DEVICE_CONNECTIVITY_EVENT,
                    (appStateData) => {
                        handler({
                            type: appStateData,
                        });
                    }
                );
            }
            else {
                console.warn("Trying to subscribe to unknown event: \"" + eventName + "\"");
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
                if (enabled) {
                    RNBluetoothListener.setBluetoothOn((error, done) => {
                        if (error) {
                            reject(error);
                            return;
                        }
                        resolve(done);
                    });
                }
                else {
                    if (Platform.OS === "android") {
                        RNBluetoothListener.setBluetoothOff((error, done) => {
                            if (error) {
                                reject(error);
                                return;
                            }
                            resolve(done);
                        });

                    }
                }
            });
        },

        async disable() {
            return this.enable(false);
        },

        openBluetoothSettings() {
            if (Platform.OS === "ios") {
                RNBluetoothListener.openBluetoothSettings(() => {
                })
            }
        }
    };
}

export default BluetoothManager;


