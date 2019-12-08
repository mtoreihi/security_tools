
function hook_methods(classname, methodname) {
    try
    {
        //Your class name here
        var name = classname;
        var k = ObjC.classes[name];
        var m = methodname;
        //var hook = eval('ObjC.classes.' + name + '["' + methodname + '"]');
            var hook = k[m].implementation;
            console.log('Hooking C:' + name + ' M:' + m);
            Interceptor.attach(hook, {
                onLeave: function(retval) {
                    console.log("info: exiting function");
        
                    // read retval
                    var obj = ObjC.Object(retval);
                    console.log("retval type:", obj.$class, obj.$className);
                    console.log("old retval value:", obj.toString());
        
                    // change retval
                    //var retnew = ObjC.classes.NSString.stringWithString_("true");
                    retval.replace(retval);
                    console.log("new retval value:", obj.toString());
                },

            });
    }
    catch(err)
    {
        console.log("[!] Exception2: " + err.message);
    }
}


function find_methods(classname) {
    try
    {
        //Your class name here
        var name = classname;
        var k = ObjC.classes[name];
        k.$ownMethods.forEach(function(m) {
            var impl = k[m].implementation;
            console.log('Observing C:' + name + ' M:' + m);
            Interceptor.attach(impl, {
                onEnter: function(a) {
                    console.log("\nEntering method--------- :" + m);

                   if (m.indexOf(':') !== -1) {
                        var params = m.split(':');
                        params[0] = params[0].split(' ')[1];
                        //console.log(params[0]);
                        for (var i = 0; i < params.length - 1; i++) {
                            console.log(params[i+1] + " => " + new ObjC.Object(a[2 + i]).toString())
                        }
                    }
                },
            });
        });
    }
    catch(err)
    {
        console.log("[!] Exception2: " + err.message);
    }
}

console.log("[*] Started: Find All Methods of a Specific Class");
if (ObjC.available)
{
    find_methods("name_of_the_calss");
    //hook_methods("class_name","- method_name:");


    for (var className in ObjC.classes)
    {
        if (ObjC.classes.hasOwnProperty(className))
        {
            //console.log(className);
            //find_methods(className);
        }
    }



    
}
else
{
    console.log("Objective-C Runtime is not available!");
}
console.log("[*] Completed: Find All Methods of a Specific Class");