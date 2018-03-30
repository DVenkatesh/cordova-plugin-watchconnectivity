# Cordova Watch Connectivity Plugin

Simple plugin that establishes iOS Watch Connectivity session with Watch OS 2 / 3 / 4 and helps exchange of messages between an iPhone hybrid application and its Apple Watch application and vice-versa.

## Installation

### With cordova-cli

If you are using [cordova-cli](https://github.com/apache/cordova-cli), install
with:

    cordova plugin add https://github.com/guikeller/cordova-plugin-watchconnectivity.git

### With ionic

With ionic:

    ionic cordova plugin add https://github.com/guikeller/cordova-plugin-watchconnectivity.git

## Use from Javascript
Edit `www/js/index.js` and add the following code inside `onDeviceReady`
```js
    // Receiving messages from Watch :: iWatch -> iPhone
    var receiveMessageSuccess = function(message){
        var value = JSON.stringify(message);
        alert("Received message from Apple Watch : "+value);
    };
    var receiveMessageFailure = function(){
        alert("Could not receive message from Apple Watch");
    };

    // Sending Messages to Watch :: iPhone -> iWatch
    var sendMessageSuccess = function() {
        alert("Message sent successfully!");
    };
    var sendMessageFailure = function(){
        alert("Could not send message to Apple Watch.");
    };
    
    // Initialised WatchConnectivity Session successfully
    var initWatchSuccess = function() {
        // Sends a message
        var data = {message: "hello from phone", value: "1234", foo: "bar"};
        iWatchConnectivity.sendMessage(data, sendMessageSuccess, sendMessageFailure);
        // Receive messages
        iWatchConnectivity.messageReceiver(receiveMessageSuccess, receiveMessageFailure);
    };
    var initWatchFailure = function() {
        alert("Could not connect to Apple Watch.");
    };
    
    // Starts things up - WCSession.default
    iWatchConnectivity.init(initWatchSuccess, initWatchFailure);
```
## Use from Apple Watch extension

### Swift
```swift
// Setup and activate session in awakeWithContext or willActivate
if WCSession.isSupported() {
    let session = WCSession.defaultSession()
    session.delegate = self
    session.activateSession()
}

// Implement activationDidCompleteWith to know when it has been paired
func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    // Session started :: phone x watch
    if (error != nil) {
        print("InterfaceController :: session :: error: ", error);
    } else {
        print("InterfaceController :: session :: state: ", activationState);
    }
}

// Implement didReceiveMessage WatchConnectivity handler/callback to receive incoming messages
func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
    // Receiving messages from iPhone
    print("InterfaceController :: session :: message: ", message);
}

// Sending a message to iPhone
func sendMessage:(message: String) -> Void{
    let message = ["message": "hello from watch", "value": "4321", "bar": "foo"]
    WCSession.default.sendMessage( 
        message,
        replyHandler: { (response) -> Void in
            print("transferSurfSession :: Send message success : \(response)")
        },
        errorHandler: { (error) -> Void in
            print("transferSurfSession :: An error happened: \(error)")
        }
    );
}
```
### Objective-C
```objective-c

// FIXME - Help wanted! Translate the code above from Swift to Objective-C
// The code below may or not work; all I know is that it may need updating.
// - - - 
// Setup and activate session in awakeWithContext or willActivate
if ([WCSession isSupported]) {
    WCSession *session = [WCSession defaultSession];
    session.delegate = self;
    [session activateSession];
}

// Implement didReceiveMessage WatchConnectivity handler/callback to receive incoming messages
- (void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *, id> *)message replyHandler:(void(^)(NSDictionary<NSString *, id> *replyMessage))replyHandler {
    NSString *message = [message objectForKey:@"message"];
    NSLog(@"%@",message);
    [self sendMessage:@"Message from iWatch"];
}

// Send message
- (void)sendMessage:(NSString*)message {
    NSDictionary *messageDictionary = [[NSDictionary alloc] initWithObjects:@[message] forKeys:@[@"message"]];
    [[WCSession defaultSession] sendMessage:messageDictionary
                               replyHandler:^(NSDictionary *reply) {
                                   NSLog(@"Send message success");
                               }
                               errorHandler:^(NSError *error) {
                                   NSLog(@"Send message failed");
                               }
     ];
}
```

## Credits
Originally written by [Venkatesh D](https://www.linkedin.com/in/dvenkateshd) and [Vagish M M](http://?)
<br>
[https://github.com/DVenkatesh/cordova-plugin-watchconnectivity](https://github.com/DVenkatesh/cordova-plugin-watchconnectivity)

With (many) contributions of:
[Gui Keller](https://www.github.com/guikeller)

## More Info
TODO: The plugin is very simple and short without much error handling. 
