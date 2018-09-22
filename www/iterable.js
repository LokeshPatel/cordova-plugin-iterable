var exec = require('cordova/exec');

exports.deviceRegister = function(success, error, emailId, userId) {
    exec(success, error, "IterablePlugin", "deviceRegister", [emailId,userId]);
};

exports.loadInAppMessage = function(success, error) {
  exec(success, error, "IterablePlugin", "loadInAppMessage", []);
};
