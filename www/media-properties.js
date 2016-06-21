var argscheck = require('cordova/argscheck'), exec = require('cordova/exec');

module.exports = {
  getProperties: function (successCallback, errorCallback, path) {
    cordova.exec(successCallback, errorCallback, "MediaProperties", "getProperties", [path]);
  }
}
