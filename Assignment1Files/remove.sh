#!/bin/bash

echo
echo $'\n----------------------Remove Records----------------------\n'
PS3='To remove a record, please choose one of the above options (enter 1-5): '
options=("View entire record list" "Search by species name" "Search by species location" "Search by recorder email" "Main menu")
select opt in "${options[@]}"
do 
	case $opt in 
		"View entire record list")
			echo $'\n\nEntire record list:'
			cat -n speciesDetails.txt
			counter=0
			while [ $counter -lt 1 ]
			do
				echo $'\nPlease type the line number(s) of the record(s) you would like to delete (e.g. use format "1 2 3")'
				read line
				valid="^[0-9 ]+$"
				if [[ $line =~ $valid ]]
				then
					echo $'\nAre you sure you would like to delete the record(s) on line number(s)' $line '(y/n)?'
					read decision
					case $decision in 
						[yY] )
							echo "OK"
							linesremoved=0
							for i in $line
							do
								i=$((i-linesremoved))
								sed ""$i"d" speciesDetails.txt > /tmp/speciesDetails.txt
								mv /tmp/speciesDetails.txt speciesDetails.txt
								linesremoved=$((linesremoved+1)) 
							done
							cat -n speciesDetails.txt
							counter=$((counter+1))
							./remove.sh
							;;
						[nN] )
							echo $'\nNo deletion made'
							break
							./remove.sh
							;;
						*) echo exit;;
					esac
				else
					echo $'\nPlease make sure you enter line numbers you wish to remove in a valid format (e.g. 1 2 3)'
				fi
			done
			break
			;;

		"Search by species name")
			echo $'\nPlease enter species name: '
			read name
			grep -n -i $name speciesDetails.txt 
			if [ $? -eq 1 ];
			then
				echo $'\nNo species found'
				./remove.sh
			else
				counter=0
                	        while [ $counter -lt 1 ]
                	        do
                	                echo $'\nPlease type the line number(s) of the record(s) you would like to delete (e.g. use format "1 2 3")'
                	                read line
                	                valid="^[0-9 ]+$"
                	                if [[ $line =~ $valid ]]
                	                then
                	                        echo $'\nAre you sure you would like to delete the record(s) on line number(s)' $line '(y/n)?'
                	                        read decision
                	                        case $decision in 
                	                                [yY] )
                	                                        echo "OK"
                	                                        linesremoved=0
                        	                                for i in $line
                        	                                do
                               	        	                        i=$((i-linesremoved))
                                	                                sed ""$i"d" speciesDetails.txt > /tmp/speciesDetails.txt
                                                        	        mv /tmp/speciesDetails.txt speciesDetails.txt
                                                   		        linesremoved=$((linesremoved+1)) 
                                                 	       done
                                           	             cat -n speciesDetails.txt
                                           	             counter=$((counter+1))
                                           	             ./remove.sh
                                           	             ;;
                                           	     	[nN] )
                                           	             echo $'\nNo deletion made'
                                           	             break
                                           	             ./remove.sh
                                           	             ;;
                                           	     	*) echo exit;;
                                       			esac
                                	else
                                	        echo $'\nPlease make sure you enter line numbers you wish to remove in a valid format (e.g. 1 2 3)'
                                	fi
                        	done
			#	echo $'\nPlease type the line number of the record you would like to delete'
			#	read linei
			#	echo $'\nAre you sure you would like to delete the record on line number' $line '(y/n)?'
			#	read decision
			#	case $decision in
			#		[yY] )
			#			echo "OK"
			#			sed ""$line"d" speciesDetails.txt  > /tmp/speciesDetails.txt
			#			mv /tmp/speciesDetails.txt speciesDetails.txt 
			#			cat -n speciesDetails.txt
			#			./remove.sh
			#			break;;
#
#					[nN] )
#						echo $'\nNo deletion made'
#						./remove.sh
#						;;
#					*) echo exit;;
#				esac
			fi
			break
			;;

		"Search by species location")
			echo $'\nPlease enter species location: '
			read location
			grep -n -i $location speciesDetails.txt
			if [ $? -eq 1 ];
			then
				echo $'\nNo location found'
				./remove.sh
			else
				echo $'\nPlease type the line number of the record you would like to delete'
				read line
				echo $'\nAre you sure you would like to delete the record on line number' $line '(y/n)'
				read decision
				case $decision in
					[yY] )
						echo "OK"
						sed ""$line"d" speciesDetails.txt  > /tmp/speciesDetails.txt
						mv /tmp/speciesDetails.txt speciesDetails.txt 
						cat -n speciesDetails.txt
						./remove.sh
						break;;
					[nN] )
						echo $'\nNo deletion made'
						./remove.sh
						;;
					*) echo exit;;
				esac
			fi
			break
			;;


		"Search by recorder email")
			echo $'\nPlease enter recorder email: '
			read email
			grep -n -i $email speciesDetails.txt
			if [ $? -eq 1 ];
			then
				echo $'\nNo email found'
				./remove.sh
			else
				echo $'\nPlease type the line number of the record you would like to delete'
				read line
				echo $'\nAre you sure you would like to delete the record on line number' $line '(y/n)'
				read decision
				case $decision in
					[yY] )
						echo "OK"
						sed ""$line"d" speciesDetails.txt  > /tmp/speciesDetails.txt
						mv /tmp/speciesDetails.txt speciesDetails.txt 
						cat -n speciesDetails.txt
						./remove.sh
						break;;
					[nN] )
						echo $'\nNo deletion made'
						./remove.sh
						;;
					*) echo exit;;
				esac
			fi
			break
			;;


		"Main menu")
			echo $'\nReturning to main menu'
			./menu
			break
			;;

		*) echo $'\nInvalid option. Please enter a number 1-5'

	esac
done

