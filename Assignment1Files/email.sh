#!/bin/bash

echo $'\n************************************************************************'
echo $'\n-----------------------------Email-----------------------------------\n'
echo $'************************************************************************'
PS3=$'\nTo email a recorder or recorders, please choose one of the above options (enter the number): ' #menu script to select options for sending emails
echo $'\n'
options=("Search entire list of recorder emails alphabetically" "Search individual recorder emails" "Search for recorders by particular species name" "Email all recorders" "Main Menu") #different options for selection
select opt in "${options[@]}"
do 
        case $opt in
                "Search entire list of recorder emails alphabetically") #if the user wants to search all the emails of recorders alphabetically...
                        awk 'BEGIN{FS=";"} {print $4}' speciesDetails.txt | sort -u > speciesDetailsAlpha.txt #use awk to focus on 4th field of text file (using ; as delineator) and sort with removal of duplications and send to temporary text file
			echo $'\nList of emails from recorders: \n'
			cat -n speciesDetailsAlpha.txt #display temporary text file
			echo $'\nWould you like to email any of the recorders (y/n)?\n' #checks if user wants to email anyone
			read decision #assigns variable to descision
			case $decision in 
				[yY] ) #if yes (big or small y)
					echo ""
					echo "OK, please type the email title:"
					read emailtitle #asks for email title and assigns a variable
					echo ""
					echo "Please type your message:"
					read message #asks for a message and assigns a variable
					count=0 #counter created to stay in loop unit valid input
					while [ $count -lt 1 ] #while counter is less than one (before valid input)...
					do
						echo $'\nPlease type the line numbers of the recorder emails you would like to email (use \"1 2 3\" format)\n'
                        			read lines #user asked to list lines and variable assigned to lines listed
						valid="^[0-9 ]+$" #defines valid input as combination of numbers and spaces
						if [[ $lines =~ $valid ]] #if user input is valid
						then
                        				echo $'\nAre you sure you would like to email the recorders on line number(s)' $lines $'(y/n)?\n'
                        				read decision2  #checks user is sure they want to delete and assigns variable to decision
                        				case $decision2 in 
                                				[yY] ) #if yes (big or small y)
                                       		 			echo "OK"
									emailaddresses="" #assigns blank variable to email addresses list
        								for i in $lines #for each of the lines the user selected...
									do 
										emailaddress=$(sed ""$i"q;d" speciesDetailsAlpha.txt | awk 'BEGIN{FS=";"} { print $1 }')"," #assigns a variable to a single email address, taking the first field in temporary file (email address) and adding a comma
										emailaddresses=$emailaddresses$emailaddress #adds single email address, including comma, to email address list
									done
									echo "$message" | mail $emailaddresses -s "$emailtitle" #command to send email via mailutils, including message and email title and all email addresses
									echo $'\nYour email has been sent to' $emailaddresses $'\n' #confirmation email was sent to addresses specified
                                        				./email.sh #returns to email shell
									break
									;;
                                				[nN] ) #if no (big or small n)
                                        				echo $'\nOK, returning to Email\n'
                                        				./email.sh #return to email shell 
									break
                                        				;;
                                        			*) echo ./email.sh #if invalid input then return to email shell. 
									break
									;;
                        				esac
							count=$((count+1)) #count progresses based on valid user input
						else
							echo ""
							echo "Please make sure you use the correct number format for recorder emails you would like to email (use \"1 2 3 etc\")" '\n'
						fi
					done
					./email #return to email shell
					break
					;;
				[nN] ) #if no (big or small n)
                                        echo "OK, returning to Email Menu"
                                        ./email.sh #return to email shell
					break
                                        ;;
                                *) 	echo "Did not understand. Returning to Email Menu"
					./email.sh #if invalid user input then return to email shell
					break
					;;
                         esac
			break
                        ;;

                "Search individual recorder emails") #if user wants to email a specific recorder...
                        echo $'\nPlease enter a recorder email address: '
                        read emailaddress #asks for email address and assigns variable
                        searchNumber=`grep -c -i $emailaddress speciesDetails.txt` #assigns variable for the number of times the email address comes up, case insensitive
                        if [ $? -eq 1 ]; #if the prevoius command fails...
                        then
                                echo $'\nNo records of that email address (recorder) found\n'
                                ./email.sh #notifies user there are no records and returns to email shell
                        else
				if [ $searchNumber -lt 2 ] #if the number of records for the email address is 1...
				then
                                	echo $'\nThere is' $searchNumber $'record related to that email address\n' #states the number of records
					grep -n -i $emailaddress speciesDetails.txt #shows the record including it's number in the list, case insensitive
                                else
					echo $'\nThere are' $searchNumber $'records related to that email address\n' #states the number of records
					grep -n -i $emailaddress speciesDetails.txt #shows the reords including their line numbers, case insensitive
				fi
				echo $'\nWould you like to email' $emailaddress $'(y/n)?\n'
              	                read decision #checks if user wants to email selected address and assigns variable to decision
                                case $decision in
                               		[yY] ) #if yes (big or small y)
						echo ""
						echo "Please enter an email title:"
						read emailtitle #assigns variable to email title
						echo ""
						echo "Please enter your message:"
						read emailmessage #assigns variable to email message
				 		echo "$emailmessage" | mail $emailaddress -s "$emailtitle" #command to send email
                                                echo $'\nYour email has been sent to' $emailaddress #confirmation of email sent
						echo ""
                                       		./email.sh #return to email shell
						break
						;;
                                	[nN] ) #if no (big or small n)
                                       		echo "OK"
                                        	./email.sh #return to email shell
						break
                                        	;;
                                	*) echo ./email.sh #if invalid input then return to email shell
						break
						;;
                         	esac
                        fi
                        break
                        ;;

		"Search for recorders by particular species name") #if the user wants to search for recorders to emailby the species name...
			echo $'\nPlease enter a species name: '
                        read speciesname #enter a name and assigns a variable
                        searchNumber=`grep -c -i $speciesname speciesDetails.txt` #assigns variable to the number of matching records in text list, case insensitive  
                        if [ $? -eq 1 ]; #if the previous command fails, i.e. no records...
                        then
                                echo $'\nNo records of that species found\n'
                                ./email.sh #no records found, return to email shell
                        else
                                if [ $searchNumber -lt 2 ] #if there is only one record
                                then
                                        echo $'\nThere is' $searchNumber $'record related to that species\n'
                                        grep -n -i $speciesname speciesDetails.txt #display list of matching records
                                else #if there were more than one record
                                        echo $'\nThere are' $searchNumber $'records related to that email address\n'
                                        grep -n -i $speciesname speciesDetails.txt #display list of matching records, not case sensitive
                                fi
                                echo $'\nWould you like to email all recorders for $speciesname records (y/n)?'
                                read decision #checks whether the user wants to email all records related to a species, assigns variable to decision
                                case $decision in
                                        [yY] ) #if yes (big or small y)
						echo ""
                                                echo "Please enter an email title:" $'\n'
                                                read emailtitle #assigns variable to email title
                                                echo ""
                                                echo "Please enter your message:" $'\n'
                                                read emailmessage #assigns vairalbe to message text 
						grep -i $speciesname speciesDetails.txt | awk 'BEGIN{FS=";"} {print $4}' | sort -u > speciesDetailsAlpha.txt #searches for the records relate to the species, secifically takes the email field from each record (using ; as delineator), sorts all the emails alphabetically and removes duplicates, passes to text file
                        			emailaddresses="" #assigns variable for list of email addresses
						addressnumber=$(grep -c "@" speciesDetailsAlpha.txt) #assigns variable to the number of different addresses in temporary text file
						counter=0 #assigns counter to loop the email process
						while [ $addressnumber -gt $counter ] #while the number of email addresses is greater than the counter
                                                do 
                                             		interestline=$((counter+1)) #assigns variable to the line number currently being processed
							emailaddress=$(sed ""$interestline"q;d" speciesDetailsAlpha.txt | awk '{ print $1 }')", " #assigns variable to email address by indentifying the current line number, extracting the email address (first field in temporary text), and adding a comma 
                                                	emailaddresses=$emailaddresses$emailaddress #adds individual email to list of email addresses
							counter=$((counter+1)) #progresses counter to next email address
                                                done
                                                echo "$message" | mail $emailaddresses -s "$emailtitle" #sends email on mailutils, including message and title
                                                echo "Your email has been sent to" $emailaddresses #confirms to user that email was sent
                                                echo ""
                                                ./email.sh #returns to email shell
						break
                                                ;;
                                        [nN] ) #if no (big or small n)
                                                echo "OK"
                                                ./email.sh #retruns to email shell
						break
                                                ;;
                                        *) echo ./email.sh #if invalid entry then return to email shell
						break
						;;
                                esac
                        fi
                        break
                        ;;

		"Email all recorders") #if the user wants to email all recorder emails...
                        awk 'BEGIN{FS=";"} {print $4}' speciesDetails.txt | sort -u > speciesDetailsAlpha.txt #select the email field in text file, sort it alphabetically and remove duplicates, send to temporary file
                        echo $'\nList of all emails: \n' #show list of all emails
			cat -n speciesDetailsAlpha.txt #numbered list of all emails alphabetically ordered
                        echo $'\nWould you like to email all of the recorders (y/n)?' #checks if user wants to email all recorders
                        read decision #assigns variable to decision
                        case $decision in
                                [yY] ) #if yes (big or small y)
                                        echo ""
                                        echo "OK, please type the email title:"
                                        read emailtitle #assign value to email title
                                        echo ""
                                        echo "Please type your message:"
                                        read emailmessage #assign value to email message
                                        awk 'BEGIN{FS=";"} {print $4}' speciesDetails.txt | sort -u > speciesDetailsAlpha.txt #select email field from text file, sort and remove duplicates, send to temporary file
                                        emailaddresses="" #assign value for list of email addresses
                                        addressnumber=$(grep -c "@" speciesDetailsAlpha.txt) #assign variable that counts the email addresses, using @ to denote a new address
                                        counter=0 #assign variable for counting through each email
                                        while [ $addressnumber -gt $counter ] #if number of emails greater than number of times email listed ...
                                        do 
                                        	interestline=$((counter+1)) #assigns value to line of interest in text file (one greater than counter)
                                                emailaddress=$(sed ""$interestline"q;d" speciesDetailsAlpha.txt | awk '{ print $1 }')", " #assigns value to individual email address using line of interest and relevant field
                                                emailaddresses=$emailaddresses$emailaddress #individual email address added to list of email addresses
                                                counter=$((counter+1)) #counter progresses to next email address
                                        done
                                        echo "$message" | mail $emailaddresses -s "$emailtitle" #emails sent with message and email title to list of email addresses
                                        echo "Your email has been sent to" $emailaddresses #confirmation of emails sent
                                        echo ""
                                        ./email.sh #return to email shell
                                        break
					;;
                                [nN] ) #if no (big or small n)
                                        echo $'\nOK, returning to Email Menu\n'
                                        ./email.sh #return to email shell
                                        break
                                        ;;
                                *)      echo $'\nDid not understand. Returning to Email Menu\n'
                                        ./email.sh #if invalid input then return to email shell
					break
					;;
                         esac
                        break
                        ;;

                "Main Menu") #if user chooses to retrun to main menu
                        echo $'\nReturning to Main Menu!\n'
                        ./menu #returns to main menu
                        break
                        ;;

                *) echo $'\nInvalid option. Please enter a number 1-5\n' #if invalid option chosen then user is warned to input valid option. 

        esac
done
