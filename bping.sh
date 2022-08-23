#!/bin/bash
#ping script for monitoring

# trap ctrl-c and call ctrl_c()
trap ctrl_c INT

function ctrl_c() {
        summary
        exit
}
########################
### HELP             ###
########################
Help()
{
    printf "%60s\n" "------------------------------------------------------------"    
    printf "%60s\n" "                   Ping Monitoring README                   "
    printf "%60s\n" "------------------------------------------------------------"    
    printf "%60s\n" "This utility was created to monitor multiple hosts and      "
    printf "%60s\n" "provide an easy visual reference to their current status.   "
    printf "%60s\n" "                                                            "
    printf "%60s\n" "Use the following options:                                  "
    printf "%60s\n" "                                                            "
    printf "%60s\n" "   bping -f <filename.txt>                                  "
    printf "%60s\n" "      Ping all hostnames and IP address in specified file.  "
    printf "%60s\n" "                                                            "
    printf "%60s\n" "   bping -h <hostname or IP address)                        "
    printf "%60s\n" "      Ping a single hostname or IP address.                 "
    printf "%60s\n" "                                                            "
    printf "%60s\n" "   bping --help                                             "
    printf "%60s\n" "      Display this help file.                               "
    printf "%60s\n" "                                                            "
    printf "%60s\n" "   bping <hostname or IP address>                           "
    printf "%60s\n" "      Same as -h.                                           "
    printf "%60s\n" "                                                            "
    printf "%60s\n" "Use Ctrl-C to exit the utility.                             "
    printf "%60s\n" "                                                            "
    printf "%60s\n" "------------------------------------------------------------"
}
########################
### ANSI COLORS      ###
########################

RED='\033[31m'
GREEN='\033[32m'
CLEAR='\033[0m'
BOLD=$(tput bold)
NORMAL=$(tput sgr0)

########################
### MAIN PROGRAM     ###
########################

# declare global variables
declare -A hostArray 
COUNTER=0
TOTALPINGS=0

bping() 
{
    until [ $COUNTER -gt 1 ]; do
        ((TOTALPINGS=TOTALPINGS+1))

        for HOST in "${!hostArray[@]}"
            do
                fping --retry=0 --timeout=200 -q -c 1 $HOST &> /dev/null
                if [    $? = 0  ]; then
                    RESULT="O"                
                else
                    RESULT="X"
                fi
                hostArray[$HOST]="${hostArray[$HOST]}$RESULT"
                
            done  
        sleep 2
        printf "\033c"
        printf "%60s\n" "------------------------------------------------------------"    
        printf "%60s\n" "                    ${BOLD}Monitoring Hosts....${NORMAL}                    "
        printf "%60s\n" "------------------------------------------------------------"    
        for HOST in "${!hostArray[@]}"
            do
                #print the hostname
                printf "%30s" "$HOST: "

                #print the statuses
                SHORT=${hostArray[$HOST]}
                if [ ${#SHORT} -le 30 ]; then
                    while read -n 1 char; do
                        if [ "$char" = "O" ]; then
                            printf "${GREEN}$char${CLEAR}"
                        else
                            printf "${RED}$char${CLEAR}"
                        fi
                    done <<< ${hostArray[$HOST]}
                    printf "\n"
                else
                    while read -n 1 char; do
                        if [ "$char" = "O" ]; then
                            printf "${GREEN}$char${CLEAR}"
                        else
                            printf "${RED}$char${CLEAR}"
                        fi
                    done <<< ${SHORT: -30}
                    printf "\n"
                fi
            done
        printf "%60s\n" "------------------------------------------------------------"    
        printf "%60s\n" "Total Pings Sent: $TOTALPINGS "
        printf "%60s\n" "------------------------------------------------------------"    
    done
}

summary() 
{
    printf "\n"
    printf "%60s\n" "------------------------------------------------------------"    
    printf "%60s\n" "                          ${BOLD}Summary${NORMAL}                           "
    printf "%60s\n" "------------------------------------------------------------"    
    for HOST in "${!hostArray[@]}"
        do
            
            #print the hostname
            printf "%30s" "$HOST: "

            #print the statuses
            result=${hostArray[$HOST]}
            success="${result//[^O]}"
            printf "${#success} / $TOTALPINGS Successful"
            printf "\n"
        done
    printf "%60s\n" "------------------------------------------------------------"
}
# Process the input options
if [ $# -eq 0 ]; then
    Help
    exit
else
    while getopts ":hf:" option; do
        case $option in
            help) # display Help
                Help
                exit;;
            f) # take file input
                HOSTS=$(cat $2)
                

                for HOST in $HOSTS
                    do
                        hostArray[$HOST]=""
                    done

                bping
                
                exit;;
            h) # single host
                hostArray[$2]=""
                
                bping

                exit;;
           \?) # Invalid Option
                Help
                exit;;
        esac
    done
    if [ -z "$hostArray" ]; then
        #populate array with arg1 if no switch is provided
        hostArray[$1]=""

        #run the bping   
        bping
        exit
    fi
fi

