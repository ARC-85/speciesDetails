#!/bin/bash
PS3='To search a record, please choose one of the above options (enter the number): '
options=("View entire species list alphabetically" "Search by species name" "Main Menu")
select opt in "${options[@]}"
do 
        case $opt in
                "View entire species list alphabetically")
                        awk '{print $1}' speciesDetails.txt | sort -u  > speciesDetailsAlpha.txt
			cat -n speciesDetailsAlpha.txt
			echo "Would you like to search further (y/n)?"
			read decision
			case $decision in 
				[yY] )
					echo "OK"
					./search.sh
					break
					;;
				[nN] )
                                        echo "OK"
                                        ./menu
					break
                                        ;;
                                *) 	echo "Did not understand. Returning to Search Menu"
					./search.sh;;
                         esac
                        ;;

                "Search by species name")
                        echo "Please enter species name: "
                        read name
                        searchNumber=`grep -c -i $name speciesDetails.txt` 
                        if [ $? -eq 1 ];
                        then
                                echo "No species found"
                                ./search.sh
                        else
				if [ $searchNumber -lt 2 ]
				then
                                	echo "There is" $searchNumber "record of that species"
					grep -n -i $name speciesDetails.txt
                                else
					echo "There are" $searchNumber "records of that species"
					grep -n -i $name speciesDetails.txt | awk '{print $1 $2}'
				fi
				echo "Would you like to search further (y/n)?"
              	                read decision
                                case $decision in 
                               		[yY] )
                                        	echo "OK"
                                       		./search.sh
						;;
                                	[nN] )
                                       		echo "OK"
                                        	./menu
                                        	;;
                                	*) echo exit;;
                         	esac
                        fi
                        break
                        ;;

                "Main Menu")
                        echo "Returning to Main Menu!"
                        ./menu
                        break
                        ;;

                *) echo "Invalid option. Please enter a number 1-3"

        esac
done
