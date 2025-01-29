#!/bin/bash

# Colores

greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"


# Variables principales

main_url="https://htbmachines.github.io/bundle.js"

# Funciones

function ctrl_c() {
echo -e "\n\n${greenColour}Saliendo del programa...${endColour}"
tput cnorm && exit 1
}

# Ctrl + C 
trap ctrl_c INT

# Panel de ayuda

function helpPanel(){
echo -e "${purpleColour}[-]${endColour} ${yellowColour}Uso del script:${endColour}"
echo -e "${purpleColour}-u${endColour} ${yellowColour}Buscar actualizaciones disponibles.${endColour}"
echo -e "${purpleColour}-m${endColour} ${yellowColour}Buscar una máquina por su nombre.${endColour}"
echo -e "${purpleColour}-h${endColour} ${yellowColour}Mostrar panel de ayuda.${endColour}"
echo -e "${purpleColour}-y${endColour} ${yellowColour}Mostrar el vídeo de YouTube de la máquina.${endColour}"

echo -e "${purpleColour}-i${endColour} ${yellowColour}Buscar una máquina por dirección IP.${endColour}"

echo -e "${purpleColour}-d${endColour} ${yellowColour}Buscar una máquina por dificultad (Fácil/Media/Difícil/Insane).${endColour}"


echo -e "${purpleColour}-o${endColour} ${yellowColour}Buscar una máquina por el sistema operativo.${endColour}"
echo -e "${purpleColour}-s${endColour} ${yellowColour}Buscar una máquina por la skill aprendida. ${endColour}"
}
# Actualización

archivo="excel.js"

function updateFiles(){

if [ ! -f bundle.js ] ; then

echo -e "${greenColour}[✓]${endColour} ${blueColour}Descargando archivos necesarios...${endColour}"
tput civis

curl -s $main_url > bundle.js
js-beautify bundle.js | sponge bundle.js

tput cnorm

else


curl -s $main_url > bundle_temp.js
js-beautify bundle_temp.js | sponge bundle_temp.js

md5sum_temp=$(md5sum bundle_temp.js | awk {'print $1'})
md5sum_original=$(md5sum bundle.js | awk {'print $1'})

echo -e "${greenColour}[~]${endColour} ${blueColour}Comprobando actualizaciones...${endColour}"

if [ $md5sum_temp == $md5sum_original ]; then

	echo -e "\n${greenColour}[✓]${endColour} ${blueColour}Actualizado a la versión más reciente. Nada que hacer.${endColour}"
	rm bundle_temp.js
else
	echo -e "\n${greenColour}[✓]${endColour} ${blueColour}Actualización completada.${endColour}"
	rm bundle.js
	mv bundle_temp.js bundle.js
fi
fi


}

# Indicador
declare -i parameter_counter=0


# Funcion buscar máquinas



function SearchMachine() {
machineName="$1"

echo -e "Buscando máquina:"


sleep 1

machineChecker=$(cat bundle.js | awk "/name: \"${machineName}"\/,/resuelta:/""| grep -e "name:" -e "ip" -e "dificultad" -e "skills" -e "like" -e "youtube" | sed 's/like/Certificaciones/g' | sed 's/,//g' | tr -d '""' | sed 's/^ *//g' | sed 's/^name*/Nombre de máquina/1'| sed 's/^ip*/IP/1' | sed 's/^dificultad*/Dificultad/1' | sed 's/^skills*/Skills/1' | sed 's/^youtube*/Link de la máquina/1' |  awk '{print $0 "\n"}')

	
if [ "$machineChecker" ];

then 
	echo -e "${machineChecker}"

else

echo -e	"No se encontró la máquina."

fi



}


# Función buscar por IP


searchIP() {
    echo -e "Buscando por dirección IP: ${addressIP}\n"

    machineName=$(cat bundle.js | grep "ip: \"${addressIP}\"" -B3 -A5 | grep -v "sku" | sed 's/name/Nombre/1' | sed 's/youtube/Link de la máquina/1' | sed 's/^ *//g' | tr -d '"' | tr -d ',')

    if [ "$machineName" ]; then
        echo -e "[Información de la máquina]:\n\n$machineName"
        
 #       read -p "¿Quieres más información? (Y/N) " respuesta
        
#       if [ "$respuesta" = "Y" ] || [ "$respuesta" = "y" ]; then
 #           echo "ok"
  #      else
   #         echo "me vale verga"
    #    fi
    else
        echo "No se encontró la máquina."
    fi

}



# Buscar videos de Youtube por el nombre de la maquina

function searchVideo(){

video="$1"


machineName=$(cat bundle.js | grep "name: \"${video}"\" -A9 | grep -e "youtube" | sed 's/name/Nombre/1' | sed 's/youtube/Link de la máquina/1' | sed 's/^ *//g' | tr -d '"' | tr -d ',')

echo "${machineName}"


}


# Buscar máquina por dificultad


function searchSkills(){

skill=$1


checkskills=$(cat bundle.js | grep "dificultad: \"${skill}"\" -B5 | grep "name" | awk '{print $NF}' | tr -d '"' | tr -d ',' | column)

 if [ "${skill}" == "Fácil" ]; then

 echo -e "${turquoiseColour} Máquinas fáciles - ${endColour}
 ${greenColour}${checkskills}${endColour}"

    elif [ "${skill}" == "Media" ]; then 
    echo -e "${turquoiseColour} Máquinas medias - ${endColour}
    ${yellowColour}${checkskills}${endColour}"

    elif [ "${skill}" == "Difícil" ]; then
	    echo -e "${turquoiseColour} Máquinas díficiles - ${endColour} 
	   ${redColour} ${checkskills}${endColour}"

    elif [ "${skill}" == "Insane" ]; then
	    echo -e "${turquoiseColour} Máquinas insane - ${endColour}
	    
   ${purpleColour}${checkskills}${endColour}"

    else 
	    echo "Dificultad no válida"

 fi

}

# Función para determinar el Sistema Operativo

searchOS()

{

os="$1"
verify_os=$(cat bundle.js | grep "so: \"${os}"\" -B4 | grep "name:" | tr -d '"' | tr -d ',' | awk {'print $NF'} | column) 

    if [ "$os" == "Linux" ]; then
        echo -e "${turquoiseColour}Máquinas de sistema Linux: ${endColour}

	${yellowColour}${verify_os}${endColour}"

elif [ "$os" == "Windows" ]; then

	echo -e "${turquoiseColour}Máquinas de sistema Windows: ${endColour}

${blueColour}${verify_os}${endColour}"

    else 
        echo -e "\nSistema Operativo no válido."
    fi
}


# Función mixed

function mixed(){

local difficulty="$1"
local os="$2"



mix_check=$(cat bundle.js | grep "so: \"$os\"" -C5 | grep "$difficulty" -B5 | grep "name:" | awk '{print $NF}' | tr -d ',' | tr -d '"')



if [ "${mix_check}" ]; then

echo -e "Listando máquinas con el sistema operativo ${os} con la dificultad ${difficulty}.


${mix_check}"


else
 
	echo "Se ha ingresado un argumento ilegal."

fi

}

# Función para ver las skills

skillslearned()

{

skill="$@"

skill_checker=$(cat bundle.js | grep "skills: " -B6 | grep -i "${skill}" -B6 | grep "name:" | awk '{print $NF}' | tr -d ',' | tr -d '"')

if [ "$skill_checker" ]; then 

	echo "Máquinas con la skill de ${skill}:

	${skill_checker}"

else 

echo "Skill no válida."

fi

}


# Indicadores especiales mixtos

declare -i chiva=0


while getopts "m:hi:uy:d:o:s:" opt; do
case $opt in

m) machineName="$OPTARG" ; ((parameter_counter+=1))
;;

h) ;;

u) ((parameter_counter+=2)) 
;;

i) addressIP="$OPTARG" ; ((parameter_counter+=5))
;;

y) video=$OPTARG ; ((parameter_counter+=3))
;;

d) skill="$OPTARG"; ((parameter_counter+=4)) ; ((chiva+=1))
;;

o) os="$OPTARG" ; ((parameter_counter+=6)) ; ((chiva+=1))
;;

s) skill="$OPTARG" ; ((parameter_counter+=7))

esac

done

if [ $parameter_counter -eq 1 ]; then
 SearchMachine $machineName


elif [ $parameter_counter -eq 2 ]; then 
updateFiles

elif [ $parameter_counter -eq 5 ]; then
searchIP $addressIP

elif [ $parameter_counter -eq 3 ]; then
searchVideo $video

elif [ $parameter_counter -eq 4 ]; then

searchSkills $skill

elif [ $parameter_counter -eq 7 ]; then

skillslearned $skill


elif [ $parameter_counter -eq 6 ]; then

searchOS $os

elif [ $chiva -eq 2 ]; then

mixed $skill $os

else
 helpPanel
fi
