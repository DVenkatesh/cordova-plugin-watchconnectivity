# Cordova Watch Connectivity Plugin

Simple plugin that establishes iOS Watch Connectivity session with Watch OS 2 and helps exchange of messages between an iPhone hybrid application and its iWatch application.

## Installation

### With cordova-cli

If you are using [cordova-cli](https://github.com/apache/cordova-cli), install
with:

    cordova plugin add https://github.com/DVenkatesh/cordova-plugin-watchconnectivity.git

### With plugman

With a plain [plugman](https://github.com/apache/cordova-plugman), you should be able to install with something like:

    plugman --platform <ios> --project <directory> --plugin https://github.com/DVenkatesh/cordova-plugin-watchconnectivity.git

## Use from Javascript
Edit `www/js/index.js` and add the following code inside `onDeviceReady`
```js
    var didReceiveMessage = function(message){
        var obj = JSON.parse(message);
        alert(obj.message);
    }
    var msgSendSuccess = function() {
        alert("Message send success");
    }
    var failure = function() {
        alert("Error");
    }
    var success = function() {
        sswc.messageReceiver(didReceiveMessage, failure);
        sswc.sendMessage("Message from phone", msgSendSuccess, failure);
    }
    sswc.init(success, failure);
```
Install iOS platform
    cordova platform add ios
    
Run the code
    cordova run 

## Credits
Written by [Venkatesh D](https://www.linkedin.com/in/dvenkateshd) and [Vagish M M](http:///)

## More Info
TODO: The plugin is very simple and short without much error handling. This is developed for an immediate need and shall be upgraded to support other platforms with error handling and improved design. 

For more information on setting up Cordova see [the documentation](http://cordova.apache.org/docs/en/4.0.0/guide_cli_index.md.html#The%20Command-Line%20Interface)

For more info on plugins see the [Plugin Development Guide](http://cordova.apache.org/docs/en/4.0.0/guide_hybrid_plugins_index.md.html#Plugin%20Development%20Guide)
