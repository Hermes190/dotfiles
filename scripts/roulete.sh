#!/usr/bin/env bash



# Colores
#Colours
green="\e[0;32m\033[1m"
end="\033[0m\e[0m"
red="\e[0;31m\033[1m"
blue="\e[0;34m\033[1m"
yellow="\e[0;33m\033[1m"
purple="\e[0;35m\033[1m"
turquoise="\e[0;36m\033[1m"
gray="\e[0;37m\033[1m"

# Función Ctrl + C
ctrl_c() {
    echo -e "\n\n${red}Saliendo del programa${end}"
    tput cnorm; exit 1
}

trap ctrl_c INT

# Función de ayuda
function help_Panel() {
    echo -e "\t${blue}\U0001F3B0 Panel de ayuda de $0:${end}"
    echo -e "\n-h Mostrar el panel de ayuda."
    echo -e "${green}-m Ingresar la cantidad de dinero para apostar. ${end}"
    echo -e "${gray}-t Técnica a usar al apostar${end} ${yellow}(${end}${turquoise}martingala${end}${yellow}/${end}${turquoise}inverse Labrouchere${end}${yellow})${end}"
}
# Función de apuestas
# Martingala
martingala() {
    echo -e "${gray}Dinero actual:${end} ${green}${dinero}€${end}"
    echo -e "${green}¿Cuánto dinero quieres apostar? \U0001F4B8 -->${end}" && read initial_bet
    echo -e "${gray}¿Qué deseas apostar continuamente (Par/Impar)? -->${end}" && read par_impar

if [[ ! $initial_bet =~ ^[0-9]+$ ]]; then
    echo -e "${red}Introduce un número válido rey.${end}\n\n"
    exit 1

elif [ $initial_bet -gt $dinero ]; then
	echo -e "\n [!] No puedes apostar más dinero que no tienes." ; exit 1
fi


if [ "$par_impar" != "par" ] && [ "$par_impar" != "impar" ]; then
	echo "Introduce una opción válida (par/impar)"
	exit 1
fi


    echo -e "${gray}Vamos a jugar con una cantidad inicial de${end} ${green}${initial_bet}€${end} ${gray}a${end} ${blue}${par_impar}${end}\n\n"
      
    

   sleep 3


    backup_bet=$initial_bet
    lost_counter=0
    win_counter=0
    max_money=0
    declare -i draw_0_count=0

    declare -i play_counter=1
    declare -a numeros_perjudicados=()
    tput civis # quitar
    while true; do
       
if [ $initial_bet -gt $dinero ]; then
	echo "No tienes suficiente saldo para realizar la apuesta."
	echo "GG! Saldo final: ${dinero}" 
	tput cnorm
	break
         fi

	dinero=$(($dinero-${initial_bet}))
        echo -e "${yellow}Acabas de apostar${end} ${green}${initial_bet}€${end}"
        echo -e "${gray}Tu balance actual es:${end} ${green}${dinero}€${end}"

        random_number=$(($RANDOM % 37))
        echo -e "${gray}El número que ha salido es:${end} ${blue}${random_number}${end}"

        if [ "$par_impar" == "par" ]; then
            if [ $random_number -eq 0 ]; then
		     ((lost_counter++))
		     ((draw_0_count++))
		     numeros_perjudicados+=($random_number)		

		     echo "${red}El número es 0, has perdido.${end}"
                     echo -e "${gray}Tu balance actual es:${end} ${green}${dinero}€\n${end}"
                     initial_bet=$(($initial_bet*2))

            elif [ $((${random_number} % 2)) -eq 0 ]; then
                     unset numeros_perjudicados[@]
		     echo -e "${green}¡El número es par, has ganado!${end}"
             ((win_counter++))
	         # Devolvemos la apuesta inicial + las ganancias
                dinero=$(($dinero + $initial_bet * 2))
               if [ $dinero -gt $max_money ]; then
                    max_money=$dinero
                fi
               
               
               
                echo -e "${gray}Tu nuevo balance es:${end} ${green}${dinero}€\n${end}"
                initial_bet=$backup_bet
            else
                echo -e "${red}El número es impar, ¡has perdido!${end}"
                echo -e "${gray}Tu balance actual es:${end} ${green}${dinero}€\n${end}"
		       ((lost_counter++))
		       numeros_perjudicados+=($random_number)
		       initial_bet=$(($initial_bet*2))
            fi
        
        
        elif [ "$par_impar" == "impar" ]; then
            if [ $random_number -eq 0 ]; then
		    ((draw_0_count++))
		    echo -e "${red}El número es 0, has perdido.${end}"
		       ((lost_counter++))
		       ((draw_0_count++))
		       numeros_perjudicados+=($random_number)
		       echo -e "${gray}Tu balance actual es:${end} ${green}${dinero}€${end}"
                initial_bet=$(($initial_bet*2))
               
            elif [ $((${random_number} % 2)) -eq 1 ]; then
		        
                unset numeros_perjudicados
                echo -e "${green}¡El número es impar, has ganado!${end}"
                # Devolvemos la apuesta inicial + las ganancias
                ((win_counter++))
                dinero=$(($dinero + $initial_bet * 2))
		         if [ $dinero -gt $max_money ]; then 
                 max_money=$dinero
                fi             


             unset numeros_perjudicados
                echo -e "${gray}Tu nuevo balance es:${end} ${green}${dinero}€\n${end}"
                initial_bet=$backup_bet
            else
		    ((lost_counter++))
		    numeros_perjudicados+=($random_number)
		echo -e "${red}El número es par, ¡has perdido!${end}"
                echo -e "${gray}Tu balance actual es:${end} ${green}${dinero}€${end}\n"
                initial_bet=$(($initial_bet*2))
            fi
        fi
   ((play_counter++))


    done
  
    numeros=$(printf "%s" "${numeros_perjudicados[@]/#/, }" | sed 's/^[, ]*//')
   
   echo -e "
   - Has jugado un total de ${play_counter} veces.
   - Has perdido un total de ${lost_counter} veces.
   - Has ganado un total de ${win_counter} veces. 
   - Tu saldo máximo ha sido de ${max_money}€.
   - Has perdido seguido por los números: ${numeros}.
   - Ha salido el número 0 un total de ${draw_0_count} veces."
    tput cnorm # recuperar
}

function inverse(){

echo -e "${gray}¿Qué deseas apostar continuamente (Par/Impar)? -->${end}" && read par_impar
echo -e "${gray}Introduzca la secuencia de números a apostar (separados por espacios, sin comas. Ex: "1 2 3 4 5 6") 
Ó seleccione la default (1 2 3 4) escribiendo la palabra "default". ${end}" && read -a logica

	     if [ "$logica" == "default" ]; then
		     logica=(1 2 3 4)

	     elif [ "$logica" == "" ]; then
		     echo -e "${red}Introduce una secuencia válida.${end}\n\n"
		     exit 1
	     fi

	logica=(${logica[@]})
	backup_logica=(${logica[@]})

	echo -e "Su dinero a apostar sería ${dinero}€" 
  	bet=$((logica[0] + logica[-1]))
    	logica=(${logica[@]})

	
	sleep 4

tput civis
while true; do
random_number=$(($RANDOM % 37))
dinero=$(($dinero - $bet))

if [ ${#logica[@]} -eq 0 ] || [ ${#logica[@]} -eq 1 ]; then
    logica=(${backup_logica[@]})
    echo "Se ha reiniciado la secuencia. Vale lo mismo que la inicial."
fi

if [ $dinero -lt 0 ]; then
    echo -e "Te has quedado sin dinero para seguir jugando."
    tput cnorm
    break
fi

echo -e "Se apuesta ${bet} y la secuencia inicial es [${logica[@]}]. Tu dinero actual es ${dinero}€."
echo -e "El número que ha salido es ${random_number}"

if [ $par_impar == "par" ]; then
    if [ $random_number -eq 0 ]; then
        echo "El número es 0, has perdido."
        unset logica[0]
        unset logica[${#logica[@]}-1]
        logica=(${logica[@]})
        echo "Tu dinero actual es ${dinero}€."
    elif [ $(($random_number % 2)) -eq 0 ]; then
        echo -e "El número es par, has ganado."
        reward=$(($bet * 2))
        dinero=$(($dinero + $reward))
        logica+=($bet)
        logica=(${logica[@]})
        echo "Tu recompensa es de ${reward}€ y el dinero es ${dinero}€."
    else
        echo "El número es impar, has perdido."
        unset logica[0]
        unset logica[${#logica[@]}-1]
        logica=(${logica[@]})
        echo "La secuencia queda de esta forma: ${logica[@]}"
    fi
elif [ $par_impar == "impar" ]; then
    if [ $random_number -eq 0 ]; then
        echo "El número es 0, has perdido."
        unset logica[0]
        unset logica[${#logica[@]}-1]
        logica=(${logica[@]})
        echo "Tu dinero actual es ${dinero}€."
    elif [ $(($random_number % 2)) -eq 1 ]; then
        echo -e "El número es impar, has ganado."
        reward=$(($bet * 2))
        dinero=$(($dinero + $reward))
        logica+=($bet)
        logica=(${logica[@]})
        echo "Tu recompensa es de ${reward}€ y el dinero es ${dinero}€."
    else
        echo "El número es par, has perdido."
        unset logica[0]
        unset logica[${#logica[@]}-1]
        logica=(${logica[@]})
        echo "La secuencia queda de esta forma: ${logica[@]}"
    fi
fi

if [ ${#logica[@]} -gt 1 ]; then
    bet=$((logica[0] + logica[${#logica[@]}-1]))
elif [ ${#logica[@]} -eq 1 ]; then
    bet=${logica[0]}
else
    logica=(${backup_logica[@]})
    bet=$((logica[0] + logica[${#logica[@]}-1]))
fi
done
tput cnorm
}



# Indicadores (opcional)
declare -i counter=0

while getopts "m:t:h" caso; do
    case $caso in
        h) help_Panel ;;
        m) dinero=$OPTARG ;;
        t) technique="$OPTARG"
    esac
done

if [ $dinero ] && [ $technique ]; then
    if [ "$technique" == "martingala" ]; then
        martingala

elif [ "$technique" == "inverse" ]; then
	inverse

else
	echo -e "${red}⚠️  Técnica introducida inexistente.${end}\n\n"
	help_Panel
    fi
 

else
    help_Panel
    exit
fi
