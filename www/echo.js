var exec = require('cordova/exec');

var echo = {
    echoNow: function() {  
    	var success = function(resp) { 
    		var c = document.getElementById("container")
            var newParagraph = document.createElement('p');
            newParagraph.innerHTML = '('+ resp[0] + ',' + resp[1] + ')';
            c.appendChild(newParagraph);
    	};
        var error = function(message) { alert("Oopsie! " + message); };
        cordova.exec(success, error, "Echo", "escrever", []);
    }   
}

module.exports = echo;
