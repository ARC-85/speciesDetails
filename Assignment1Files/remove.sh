#!/bin/bash

echo $'\n*************************************************************'
echo $'\n----------------------Remove Records----------------------\n'
echo $'************************************************************\n'
PS3=$'\nTo remove a record, please choose one of the above options (enter 1-6): \n' #menu script for different record remove options
options=("View entire record list" "Search by species name" "Search by species location" "Search by recorder email" "Erase all records" "Main menu") #menu options for record removals
select opt in "${options[@]}"
do 
	case $opt in 
		"View entire record list") #option to review entire record list and select records to remove
			echo $'\n\nEntire record list:'
			cat -n speciesDetails.txt #displays record list with numbering
			counter=0 #counter to ensure user remains in loop until valid input included
			while [ $counter -lt 1 ] #while user has not inputted valid option
			do
				echo $'\nPlease type the line number(s) of the record(s) you would like to delete (e.g. use format "1 2 3")'
				read line #assigns a variable to user input
				valid="^[0-9 ]+$" #defines variable for valid user input (any number of numbers or spaces, starting and finishing with this format)
				if [[ $line =~ $valid ]] #checks if the user input is valid
				then #if valid..
					echo $'\nAre you sure you would like to delete the record(s) on line number(s)' $line '(y/n)?' #checks whether the user definitely wants to delete records
					read decision #records decision variable
					case $decision in 
						[yY] ) #if yes (big or little y)
							echo "OK"
							linesremoved=0 #sets a counter for each time a line/record is removed
							for i in $line #for loop to work through each line the user wanted removed
							do
								i=$((i-linesremoved)) #reduces user input line number each time a line is removed because line moves up one (e.g. if line 1 is removed, line 2 becomes line 1)
								sed ""$i"d" speciesDetails.txt > /tmp/speciesDetails.txt #removes the line and sends to a separate text file
								mv /tmp/speciesDetails.txt speciesDetails.txt #moves the reduced text file back into the main speciesDetails.txt file
								linesremoved=$((linesremoved+1)) #increases the number of lines removed
							done
							cat -n speciesDetails.txt #shows the updated text file
							counter=$((counter+1)) #increases the counter to move out of removal loop
							./remove.sh #returns to remove shell
							break
							;;
						[nN] ) #if no for removal
							echo $'\nNo deletion made'
							./remove.sh #return to remove shell without any deletion
							break
							;;
						*) echo ./remove.sh #if incorrect input then return to remove shell without deletion
							break
							;;
					esac
				else #if invalid user input...
					echo $'\nPlease make sure you enter line numbers you wish to remove in a valid format (e.g. 1 2 3)' #user warned to use correct format for choosing lines and remains within loop for selecting lines to remove
				fi
			done
			break
			;;

		"Search by species name") #option to review records to delete by searching for species 
			echo $'\nPlease enter species name: ' 
			read name #assigns species variable to user input
			grep -n -i $name speciesDetails.txt #shows list of all species with numbering and without case sensitivity 
			if [ $? -eq 1 ]; #if the previous command could not be processed, i.e. there is no records of that species
			then
				echo $'\nNo species found'
				./remove.sh #user told that not species are found and returned to remove shell menu
			else
				counter=0 #counter variable to ensure valid input before moving out of loop
                	        while [ $counter -lt 1 ] #while valid input has not been provided...
                	        do
                	                echo $'\nPlease type the line number(s) of the record(s) you would like to delete (e.g. use format "1 2 3")' #user requested to enter line numbers they want deleted, as per displayed on each line
                	                read line #assigns variable to user input 
                	                valid="^[0-9 ]+$" #assigns variable to valid input example (any number of numbers or spaces, starting and finishing with this format)
                	                if [[ $line =~ $valid ]] #if user input is valid
                	                then
                	                        echo $'\nAre you sure you would like to delete the record(s) on line number(s)' $line '(y/n)?' #check whether is sure they want these lines removed
                	                        read decision
                	                        case $decision in 
                	                                [yY] ) #if yes (big or little y)
                	                                        echo "OK"
                	                                        linesremoved=0 #variable to account for the lines that are removed from record list
                        	                                for i in $line #for each line number within user input
                        	                                do
                               	        	                        i=$((i-linesremoved)) #account for the number of lines removed
                                	                                sed ""$i"d" speciesDetails.txt > /tmp/speciesDetails.txt #removes line and sends to a separate text file
                                                        	        mv /tmp/speciesDetails.txt speciesDetails.txt #moves the text from the temporary text file into the main file
                                                   		        linesremoved=$((linesremoved+1)) #progresses the counter for the lines removed to make sure the next record is correctly removed
                                                 	       done
                                           	             cat -n speciesDetails.txt #displays the updated list with items removed
                                           	             counter=$((counter+1)) #progresses the counter for the loop to assess valid input
                                           	             ./remove.sh #return to remove shell
                                           	             ;;
                                           	     	[nN] )
                                           	             echo $'\nNo deletion made'
                                           	             ./remove.sh #if no deletion made then return to remove shell
				       				break
                                           	             ;;
                                           	     	*) echo ./remove.sh #returns to remove shell if invalid response to y/n question
								break
								;;
                                       			esac
                                	else
                                	        echo $'\nPlease make sure you enter line numbers you wish to remove in a valid format (e.g. 1 2 3)' #if user puts invalid format they are warned and loop is continued
                                	fi
                        	done
			fi
			break
			;;

		"Search by species location") #option to search for records to delete by searching location
			echo $'\nPlease enter species location: '
			read location #assigns location variable
			grep -n -i $location speciesDetails.txt #shows records matching that location in a numbered list, case insensitive 
			if [ $? -eq 1 ]; #if previous process can't be processed because there are no records for that location
			then
				echo $'\nNo location found'
				./remove.sh #return to remove shell
			else
				counter=0 #sets a counter for ensuring valid input
				while [ $counter -lt 1 ] # while the counter is less than one the loop will continue to run
				do
					echo $'\nPlease type the line number(s) of the record(s) you would like to delete (e.g.use format "1 2 3")'
					read line #assigns variable to input
					valid="^[0-9 ]+$" #defines valid input as a combination of numbers and spaces
					if [[ $line =~ $valid ]] #if the user input is valid...
					then
						echo $'\nAre you sure you would like to delete the record(s) on line number(s)' $line '(y/n)' #checks the user definitely wants to delete the lines stated
						read decision #sets variable to decision
						case $decision in
							[yY] ) #if decision is yes (big or small y)../
								echo "OK"
								linesremoved=0 #assigns a variable to account for the number of lines removed so subsequent lines are removed correctly
								for i in $line #for each line number in the user's input
								do
									i=$((i-linesremoved)) #the line number accounts for previously removed lines within the loop
									sed ""$i"d" speciesDetails.txt  > /tmp/speciesDetails.txt #delete the line defined by the user and assign it to a temporary list
									mv /tmp/speciesDetails.txt speciesDetails.txt  #move the temporary list into the main list
									linesremoved=$((linesremoved+1)) #progress the counter for the number of lines removed
								done
								cat -n speciesDetails.txt #display updated list
								counter=$((counter+1)) #progress counter to exit loop for valid input
								./remove.sh #return to remove shell
								break;;
							[nN] ) #if no is chosen (big or small n)...
								echo $'\nNo deletion made'
								./remove.sh #return to remove shell
								break
								;;
							*) echo ./remove.sh #if invalid selection then return to remove shell
								break
								;;
						esac
					else
						echo $'\nPlease make sure you enter the line number you would like to remove in a valid format (e.g. 1 2 3)' #if incorrect format then user warned and remains within location loop
					fi
				done
			fi
			break
			;;


		"Search by recorder email") #allows to search for records to remove by email of recorder
			echo $'\nPlease enter recorder email: '
			read email #assigns variable to input
			grep -n -i $email speciesDetails.txt #displays list of matching records numbered and case insensitive
			if [ $? -eq 1 ]; #if previous command fails...
			then
				echo $'\nNo email found' #there are no records for that search
				./remove.sh #return to remove shell
			else
				counter=0 #sets a counter for the correct format user input
				while [ $counter -lt 1 ] #while the counter remains 0, i.e. user hasn't entered valid input...
				do
					echo $'\nPlease type the line number(s) of the record(s) you would like to delete (e.g. use format "1 2 3")'
					read line #assigns variable to user input
                                        valid="^[0-9 ]+$" #defines the valid format of input as combination of numbers and spaces
                                        if [[ $line =~ $valid ]] #if the user input is equivalent to valid format...
					then
						echo $'\nAre you sure you would like to delete the record(s) on line number(s)' $line '(y/n)' #checks user definitely wants to remove lines stated
						read decision #assigns variable to decision
						case $decision in
							[yY] ) #if decision is yes (big or small y)
								echo "OK"
								linesremoved=0 #counter for the number of lines removed in a loop
								for i in $line #for each line the user specified to delete...
								do
									i=$((i-linesremoved)) #subtract the previous number of lines removed to account for position
									sed ""$i"d" speciesDetails.txt  > /tmp/speciesDetails.txt #delete line and send to temporary text file
									mv /tmp/speciesDetails.txt speciesDetails.txt #move text from temp file to main file
									linesremoved=$((linesremoved+1)) #increase the counter for number of lines removed
								done
								cat -n speciesDetails.txt #display updated list
								counter=$((counter+1)) #progress counter for loop due to valid input
								./remove.sh #return to remove shell
								break;;
							[nN] ) #if decision is no (big or small n)
								echo $'\nNo deletion made'
								./remove.sh #no deletion made and return to remove shell
								break
								;;
							*) echo ./remove.sh
								break
								;;
						esac
					else
						echo $'\nPlease make sure you enter the line number you wish to remove in a valid format (e.g. 1 2 3)' #if incorrect format for input user is warned to use correct format and loop is continued
					fi
				done
			fi
			break
			;;

		"Erase all records") #if user is looking to delete all the records on the list
				echo $'\nWARNING: Are you sure you would like to delete all the records on the system? (y/n)?' #warning asks if the user is sure they want to delete all records
                                read decision #assigns variale to answer
                                case $decision in 
                                	[yY] ) #if decision yes (big or small y)
                                                echo "OK"
                                                cp blankDetails.txt speciesDetails.txt #copy of blank text file overwrites main text file
                                                ./remove.sh #return to remove shell
						break
                                                ;;
                                        [nN] ) #if decision is no (big or small n)
                                                echo $'\nNo deletion made'
                                                ./remove.sh #no deletion made and return to remove shell
                                                break
                                                ;;
                                        *) echo ./remove.sh #if invalid input then return to remove shell
						break
						;;
                                esac
				break
				;;

		"Main menu") #if user wants to retrun to main menu
			echo $'\nReturning to main menu'
			./menu #returns to main menu
			break
			;;

		*) echo $'\nInvalid option. Please enter a number 1-6' #if user puts in wrong input then the are told to put in a correct number, loop continues

	esac
done

