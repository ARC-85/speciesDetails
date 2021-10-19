#!/bin/bash
echo $'\n*************************************************'
echo $'\n----------------Add Record---------------------\n'
echo $'*************************************************'
count=0 #count loop for different data add options
while [ $count -lt 4 ] #there are 4 different add requirements, loop is set
do
	if [ $count -eq 0 ] #first add requirement (species name) when count=0
	then
		count4=0 #new count variable to ensure user remains in first option (species name loop) until a valid entry is made
		while [ $count4 -lt 1 ] #loop while user is still required to enter valid input
		do
			echo $'\nPlease enter species name: '
			read name #variable for species name
			if ! [ -z "${name}" ] #checks whether name is not blank
			then
				count=$((count+1)) #if not blank then add loop progresses
				count4=$((count4+1)) #if not blank then species name loop progresses
			else
				echo $'\nWarning: You cannot enter a blank name' #if blank then remain within species loop 
			fi
		done
	fi
	if [ $count -eq 1 ] #second add requirement (location) when count=1
	then
		count2=0 #new count variable to ensure user remians in second option (location loop) until a valid entry is made
		while [ $count2 -lt 1 ] #loop while user is still required to enter valid input
		do
			echo $'\nPlease enter species location using an Eir Code: '
			read location #variable for location
			valid='[a-zA-Z][0-9][0-9][0-9a-zA-Z]{4}' #variable for valid Eir code format (letter, number, number, alphanumeric X 4
				if [[ $location =~ $valid ]] #checks if location variable is valid
				then
					count=$((count+1)) #if valid then add loop progresses
					count2=$((count2+1)) #if valid then location loop progresses
				else 
					echo $'\nPlease enter a correct format Eir Code (e.g. A11XXXX)' #if not valid then user warning to enter valid format and maintained within loop
				fi
		done
	fi
	if [ $count -eq 2 ] #third add requirement (date) when count =2
	then
		date=`date` #assigns the date command to the date variable
		count=$((count+1)) #progresses the add loop
	fi
	if [ $count -eq 3 ] #fourth add requirement (email) when count =3
	then
		count3=0 #new count variable to ensure user remains in thrid option (email loop) until a valid entry is made
		while [ $count3 -lt 1 ] #loop while user is still required to enter valid input
		do
			echo $'\nPlease enter your email: '
			read email #variable for email
			valid2="^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$" #variable for valid email format (any number of letters/symbols/numbers, an @ symbol, any number of letters/numbers, a dot, and at least 2 but not more than 4 letters
			if [[ $email =~ $valid2 ]] #checks if email variable is valid
			then
				count=$((count+1)) #if valid then add loop progresses
				count3=$((count3+1)) #if valid then email loop progresses
			else
				echo $'\nPlease enter a correct email format (e.g. text@text.com)' #if not valid then user warning to enter valid format and maintained within loop
			fi
		done
	fi
	echo ""
	echo $'-------------Entered Data--------------\n'
	echo "Name: "$name "; Location: " $location "; Date entered: " $date "; Recorder email: " $email ";" #Repeat all the variables for user to check
	echo $'\n---------------------------------------'
	echo ""
	echo -n "Are you sure you want to add this record (y/n): " #Checks whether user wants to record the input
	read answer #variable for answer
	if [[ "$answer" == "y" || "$answer" == "Y" ]] #If yes (capital or small y)
	then
		echo $'\n------------------------\n'
		echo "Record added successfully" #Confirm record added
		echo $'\n-----------------------'
		echo $name "; " $location "; " $date "; " $email ";" >> speciesDetails.txt #species details file is updated with appended record, ; used to delineate
	else
		echo $'\nRecord has not been added' #if yes not selected then record not stored
	fi
	echo
	echo $'\nWould you like to add another record [y/n]?' #check whether new record to be added
	read answer #variable for answer
	case $answer in 
		[yY])
			./add.sh #if yes (big or small Y) then start add shell again
			break
			;;
		[nN])
			./menu #if no then return to main menu
			break
			;;
		*) ./menu;; #if alternative input then return to main menu by default
	esac
done #end of add loop
