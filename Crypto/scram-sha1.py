    # SCRAM-SHA1
    # by Mehran Toreihi (mtoreihi@gmail.com)
    # 2016-11-07
    
     
    from hashlib import *
    from pbkdf2 import *
    from passlib.utils import saslprep
    from base64 import b64decode
    from base64 import b64encode
    import hmac
    import string
    import itertools
     
    def _strxor(s1, s2):
        return ''.join(chr(ord(a) ^ ord(b)) for a, b in zip(s1, s2))
     
    def testUnit():
        clientFinalMessageBare = "c=biws,r=" + "fyko+d2lbbFgONRv9qkxdawL3rfcNHYJY1ZVvWVs7j"
        saltedPassword = pbkdf2_hmac("sha1", saslprep(unicode("pencil")), b64decode("QSXCR+Q6sek8bf92"), 4096)
        print saltedPassword.encode("hex")
     
        clientKey = hmac.new(saltedPassword, "Client Key", sha1)
        print clientKey.hexdigest()
     
        storedKey = sha1(clientKey.digest())
        print storedKey.hexdigest()
     
        authMessage = "n=user,r=fyko+d2lbbFgONRv9qkxdawL,r=fyko+d2lbbFgONRv9qkxdawL3rfcNHYJY1ZVvWVs7j,s=QSXCR+Q6sek8bf92,i=4096,c=biws,r=fyko+d2lbbFgONRv9qkxdawL3rfcNHYJY1ZVvWVs7j"
        clientSignature = hmac.new(storedKey.digest(), authMessage, sha1)
        print clientSignature.hexdigest()
     
        clientProof = _strxor(clientKey.digest(), clientSignature.digest())
        print clientProof.encode("hex")
     
        serverKey = hmac.new(saltedPassword, "Server Key", sha1)
        print serverKey.hexdigest()
     
        serverSignature = hmac.new(serverKey.digest(), authMessage, sha1)
        print serverSignature.hexdigest()
     
        clientFinalMessage = clientFinalMessageBare + ",p=" + b64encode(clientProof)
        print clientFinalMessage
     
        serverFinalMessage = "v=" + b64encode(serverSignature.digest())
        print serverFinalMessage
     
    def checkPassword(passwd):
        clientFinalMessageBare = "c=biws,r=xxxxxxxxxxxxxxxxxxxxxxxxxxxx"
        saltedPassword = pbkdf2_hmac("sha1", saslprep(unicode(passwd)), b64decode("yyyyyyyyyyyyyyyyy"), 4096)
        #print saltedPassword.encode("hex")
        clientKey = hmac.new(saltedPassword, "Client Key", sha1)
        #print clientKey.hexdigest()
        storedKey = sha1(clientKey.digest())
        #print storedKey.hexdigest()
        authMessage = "n=username,r=hydra,r=xxxxxxxxxxxxxxxxxxxxxxxxxxxx,s=yyyyyyyyyyyyyyyyy,i=4096,c=biws,r=xxxxxxxxxxxxxxxxxxxxxxxxxxxx"
        clientSignature = hmac.new(storedKey.digest(), authMessage, sha1)
        #print clientSignature.hexdigest()
        clientProof = _strxor(clientKey.digest(), clientSignature.digest())
        #print clientProof.encode("hex")
        serverKey = hmac.new(saltedPassword, "Server Key", sha1)
        #print serverKey.hexdigest()
        serverSignature = hmac.new(serverKey.digest(), authMessage, sha1)
        #print serverSignature.hexdigest()
        clientFinalMessage = clientFinalMessageBare + ",p=" + b64encode(clientProof)
        #print clientFinalMessage
        serverFinalMessage = "v=" + b64encode(serverSignature.digest())
        if (serverFinalMessage == "v=base64_encoded_string"):
            return True
        else:
            return False
        #print serverFinalMessage
     
     
    #testUnit()
     
    chars = "abcdefghijklmnopqrstuvwxyz"
    for i in range(1, 10):
        print "Trying lenth: " + str(i)
        for item in itertools.product(chars, repeat=i):
            #print "".join(item)
            password =  "pass" + "".join(item)
            #print password
            try:
                if checkPassword(password):
                    print password
                    exit()
            except:
                print password
