var exec = require('cordova/exec');

var echo = {
    echoNow: function(param) {  
    	alert('echoNow');
    	var success = function() { alert(success); };
        var error = function(message) { alert("Oopsie! " + message); };
        cordova.exec(success, error, "Echo", "escrever", [param]);
    }   
}

module.exports = echo;
