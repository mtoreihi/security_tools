Java.perform(function(){
    console.log("\nmtoreihi: Root detection bypass with Frida");
    var DeviceUtils = Java.use("com.scottyab.rootbeer.b");
    console.log("\nHijacking j() function in com.scottyab.rootbeer.a class");
    DeviceUtils.j.implementation = function(){
        console.log("\nmtoreihi: Inside the j() function");
        return false;
    };
    console.log("\nmtoreihi: Root detection bypassed");
});