Java.perform(function(){
    console.log("\nmtoreihi: Root detection bypass with Frida");
    var DeviceUtils = Java.use("com.scottyab.rootbeer.b");
    console.log("\nHijacking j() function in com.scottyab.rootbeer.a class");
    DeviceUtils.j.implementation = function(){
        console.log("\nmtoreihi: Inside the j() function");
        return false;
    };
    console.log("\nmtoreihi: Root detection bypassed");
	
	var array_list = Java.use("java.util.ArrayList");
    var ApiClient = Java.use('com.android.org.conscrypt.TrustManagerImpl');
    ApiClient.checkTrustedRecursive.implementation = function(a1, a2, a3, a4, a5, a6) {
        // console.log('Bypassing SSL Pinning');
        var k = array_list.$new();
        return k;
    }
	
});