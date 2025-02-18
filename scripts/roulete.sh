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

max_money() {
    if [ $dinero -gt $max_money ]; then
        max_money=$dinero
    fi
}






tput civis

declare -i jugadas_realizadas=0
max_money=0
bet_renew=$(($dinero+50)) # Dinero el cual una vez alcanzado, se reinicia la secuencia a la original


sleep 5


while true; do
	
	((jugadas_realizadas++))
    random_number=$(($RANDOM % 37))

    # Reiniciar la secuencia si se ha alcanzado el límite
    if [ ${#logica[@]} -eq 0 ] || [ ${#logica[@]} -eq 1 ]; then
        logica=(${backup_logica[@]})
        echo "Se ha reiniciado la secuencia. Vale lo mismo que la inicial."
        bet=$((logica[0] + logica[${#logica[@]}-1])) # Recalcular bet después de reiniciar la secuencia
    fi

    	# Dinero insuficiente
    if [ $dinero -lt $bet ]; then
        echo -e "Te has quedado sin dinero para seguir jugando."
        tput cnorm
        break
    fi 

	if [ $dinero -gt $bet_renew ]; then
	logica=(${backup_logica[@]})
	logica=(${logica[@]})
	bet=$((logica[0] + logica[-1]))
    bet_renew=$(($dinero+50))
	echo -e "${yellow}Se ha reiniciado la secuencia a la original para jugar con el dinero de la casa.${end}"
    fi

    echo -e "Tu dinero actual es ${dinero}€ y la secuencia es [${logica[@]}]."


dinero=$(($dinero - $bet))

echo -e "Se apuesta ${bet}€ con la secuencia [${logica[@]}] y tu dinero queda en ${dinero}."

    echo -e "El número que ha salido es ${random_number}"

    if [ $par_impar == "par" ]; then
        if [ $random_number -eq 0 ]; then
            echo "El número es 0, has perdido."
            unset logica[0]
            unset logica[-1] 
            logica=(${logica[@]})
            echo -e "Tu dinero actual es ${dinero}€.\n"
        elif [ $(($random_number % 2)) -eq 0 ]; then
            echo -e "El número es par, has ganado."
            reward=$(($bet * 2))
            dinero=$(($dinero + $reward))
            logica+=($bet)
            logica=(${logica[@]})
            echo -e "Tu recompensa es de ${reward}€ y el dinero es ${dinero}€.\n"
        else
            unset logica[0]
            unset logica[-1]  
            logica=(${logica[@]})
            echo -e "El número es impar y pierdes. La secuencia queda de esta forma: ${logica[@]}\n"
        fi
    elif [ $par_impar == "impar" ]; then
        if [ $random_number -eq 0 ]; then
            echo "El número es 0, has perdido."
            unset logica[0]
            unset logica[-1] 
            logica=(${logica[@]})
            echo -e "Tu dinero actual es ${dinero}€.\n"
        elif [ $(($random_number % 2)) -eq 1 ]; then
            echo -e "El número es impar, has ganado."
            reward=$(($bet * 2))
            dinero=$(($dinero + $reward))
            logica+=($bet)
            logica=(${logica[@]})
            echo -e "Tu recompensa es de ${reward}€ y el dinero es ${dinero}€.\n"
        else
            unset logica[0]
            unset logica[-1]
            logica=(${logica[@]})
            echo -e "El número es impar y pierdes. La secuencia queda de esta forma: ${logica[@]}\n"
        fi
    fi

    if [ ${#logica[@]} -gt 1 ]; then # Si la secuencia es mayor a 1, se recalcula el bet
        bet=$((logica[0] + logica[${#logica[@]}-1]))
    elif [ ${#logica[@]} -eq 1 ]; then # Si vale 1, bet es el único valor
        bet=${logica[0]}
    else
        logica=(${backup_logica[@]}) # Si es 0, se reinicia la secuencia
        bet=$((logica[0] + logica[${#logica[@]}-1]))
    fi

    max_money
done

echo -e "\n${yellow}Tu saldo final es de ${end}${green}${dinero}€.${end}"
echo -e "${yellow}Has jugado un total de${end} ${purple}${jugadas_realizadas}${end}${yellow} veces.${end}"
echo -e "${yellow}Máximo saldo alcanzado:${end} ${green}${max_money}€.${end}"
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
