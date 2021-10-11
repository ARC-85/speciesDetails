#!/bin/bash

echo
echo ------------------------------------------
PS3='To remove a record, please choose one of the above options (enter 1-5): '
options=("View entire record list" "Search by species name" "Search by species location" "Search by recorder email" "Quit")
select opt in "${options[@]}"
do 
	case $opt in 
		"View entire record list")
			cat -n speciesDetails.txt
			echo "Please type the line number of the record you would like to delete"
			read line
			echo "Are you sure you would like to delete the record on line number" $line "(y/n)?"
			read decision
			case $decision in 
				[yY] )
					echo "OK"
					sed ""$line"d" speciesDetails.txt > /tmp/speciesDetails.txt
					mv /tmp/speciesDetails.txt speciesDetails.txt 
					cat -n speciesDetails.txt
					./menu
					;;
				[nN] )
					echo "No deletion made"
					echo exit
					;;
					*) echo exit;;
			esac
			break
			;;

		"Search by species name")
			echo "Please enter species name: "
			read name
			grep -n $name speciesDetails.txt 
			if [ $? -eq 1 ];
			then
				echo "No species found"
				./remove.sh
			else
				echo "Please type the line number of the record you would like to delete"
				read linei
				echo "Are you sure you would like to delete the record on line number" $line "(y/n)?"
				read decision
				case $decision in
					[yY] )
						echo "OK"
						sed ""$line"d" speciesDetails.txt  > /tmp/speciesDetails.txt
						mv /tmp/speciesDetails.txt speciesDetails.txt 
						cat -n speciesDetails.txt
						./menu
						break;;

					[nN] )
						echo "No deletion made"
						./menu
						;;
					*) echo exit;;
				esac
			fi
			break
			;;

		"Search by species location")
			echo "Please enter species location: "
			read location
			grep -n $location speciesDetails.txt
			if [ $? -eq 1 ];
			then
				echo "No location found"
				./remove.sh
			else
				echo "Please type the line number of the record you would like to delete"
				read line
				echo "Are you sure you would like to delete the record on line number" $line "(y/n)"
				read decision
				case $decision in
					[yY] )
						echo "OK"
						sed ""$line"d" speciesDetails.txt  > /tmp/speciesDetails.txt
						mv /tmp/speciesDetails.txt speciesDetails.txt 
						cat -n speciesDetails.txt
						./menu
						break;;
					[nN] )
						echo "No deletion made"
						./menu
						;;
					*) echo exit;;
				esac
			fi
			break
			;;


		"Search by recorder email")
			echo "Please enter recorder email: "
			read email
			grep -n $email speciesDetails.txt
			if [ $? -eq 1 ];
			then
				echo "No email found"
				./remove.sh
			else
				echo "Please type the line number of the record you would like to delete"
				read line
				echo "Are you sure you would like to delete the record on line number" $line "(y/n)"
				read decision
				case $decision in
					[yY] )
						echo "OK"
						sed ""$line"d" speciesDetails.txt  > /tmp/speciesDetails.txt
						mv /tmp/speciesDetails.txt speciesDetails.txt 
						cat -n speciesDetails.txt
						./menu
						break;;
					[nN] )
						echo "No deletion made"
						./menu
						;;
					*) echo exit;;
				esac
			fi
			break
			;;


		"Quit")
			echo "Good bye!"
			./menu
			break
			;;

		*) echo "Invalid option. Please enter a number 1-5"

	esac
done

