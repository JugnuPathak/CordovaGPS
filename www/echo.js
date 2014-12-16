var exec = require('cordova/exec');

var echo = {
    echoNow: function(param) {  
    	window.TEXTO.innerHTML = 'echoNow';      
    	var success = function() { window.TEXTO.innerHTML = 'Sussexo'; };
        var error = function(message) { alert("Oopsie! " + message); };
        cordova.exec(success, error, "Echo", "echo", [param]);
    }   
}

module.exports = echo;
