cordova.define('cordova/plugin_list', function(require, exports, module) {
module.exports = [
    {
        "file": "plugins/com.vitorventurin.echo/www/echo.js",
        "id": "com.vitorventurin.echo.Echo",
        "clobbers": [
            "window.echo"
        ]
    }
];
module.exports.metadata = 
// TOP OF METADATA
{
    "com.vitorventurin.echo": "0.1.0"
}
// BOTTOM OF METADATA
});