var exec = require('cordova/exec');

exports.deviceTokenIDRegister = function(success, error,emailId) {
  exec(success, error, "IterablePlugin", "deviceTokenIDRegister", [emailId]);
};

exports.loadInAppMessage = function(success, error) {
  exec(success, error, "IterablePlugin", "loadInAppMessage", []);
};
