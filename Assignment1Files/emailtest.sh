#!/bin/bash

echo ""
echo "-----------------------------Email-----------------------------------"
echo ""
PS3='To email a recorder or recorders, please choose one of the above options (enter the number): '
options=("Search entire list of recorder emails alphabetically" "Search individual recorder emails" "Search for recorders by particular species name" "Main Menu")
select opt in "${options[@]}"
do 
        case $opt in
                "Search entire list of recorder emails alphabetically")
                        awk 'BEGIN{FS=";"} {print $4}' speciesDetails.txt | sort -u > speciesDetailsAlpha.txt
			cat -n speciesDetailsAlpha.txt
			echo "Would you like to email any of the recorders (y/n)?"
			read decision
			case $decision in 
				[yY] )
					echo ""
					echo "OK, please type the email title:"
					read emailtitle
					echo ""
					echo "Please type your message:"
					read message
					count=0
					while [ $count -lt 1 ]
					do
						echo "Please type the line numbers of the recorder emails you would like to email (use \"1 2 3\" format)"
                        			read lines
						valid="^[0-9 ]+$"
						if [[ $lines =~ $valid ]]
						then
                        				echo "Are you sure you would like to email the recorders on line number(s)" $lines "(y/n)?"
                        				read decision2 
                        				case $decision2 in 
                                				[yY] )
                                       		 			echo "OK"
									emailaddresses=""
        								for i in $lines
									do 
										emailaddress=$(sed ""$i"q;d" speciesDetailsAlpha.txt | awk 'BEGIN{FS=";"} { print $1 }')","
										emailaddresses=$emailaddresses$emailaddress
									done
									echo "$message" | mail $emailaddresses -s "$emailtitle"
									echo "Your email has been sent to" $emailaddresses
                                        				;;
                                				[nN] )
                                        				echo "OK, returning to Email"
                                        				./email.sh
									break
                                        				;;
                                        			*) echo exit;;
                        				esac
							count=$((count+1))
						else
							echo "Please make sure you use the correct number format for recorder emails you would like to email (use \"1 2 3 etc\")"
						fi
					done
					;;
				[nN] )
                                        echo "OK, returning to Email Menu"
                                        ./email.sh
					break
                                        ;;
                                *) 	echo "Did not understand. Returning to Email Menu"
					./email.sh;;
                         esac
			break
                        ;;

                "Search individual recorder emails")
                        echo "Please enter a recorder email address: "
                        read emailaddress
                        searchNumber=`grep -c -i $emailaddress speciesDetails.txt` 
                        if [ $? -eq 1 ];
                        then
                                echo "No records of that email address (recorder) found"
                                ./email.sh
                        else
				if [ $searchNumber -lt 2 ]
				then
                                	echo "There is" $searchNumber "record related to that email address"
					grep -n -i $emailaddress speciesDetails.txt
                                else
					echo "There are" $searchNumber "records related to that email address"
					grep -n -i $emailaddress speciesDetails.txt
				fi
				echo "Would you like to email $emailaddress (y/n)?"
              	                read decision
                                case $decision in
                               		[yY] )
						echo ""
						echo "Please enter an email title:"
						read emailtitle
						echo ""
						echo "Please enter your message:"
						read emailmessage
				 		echo "$emailmessage" | mail $emailaddress -s "$emailtitle"
                                                echo "Your email has been sent to" $emailaddress
						echo ""
                                       		./email.sh
						;;
                                	[nN] )
                                       		echo "OK"
                                        	./email.sh
                                        	;;
                                	*) echo exit;;
                         	esac
                        fi
                        break
                        ;;

		"Search for recorders by particular species name")
			echo "Please enter a species name: "
                        read speciesname
                        searchNumber=`grep -c -i $speciesname speciesDetails.txt` 
                        if [ $? -eq 1 ];
                        then
                                echo "No records of that species found"
                                ./email.sh
                        else
                                if [ $searchNumber -lt 2 ]
                                then
                                        echo "There is" $searchNumber "record related to that species"
                                        grep -n -i $speciesname speciesDetails.txt
                                else
                                        echo "There are" $searchNumber "records related to that email address"
                                        grep -n -i $speciesname speciesDetails.txt
                                fi
                                echo "Would you like to email all recorders for $speciesname records (y/n)?"
                                read decision
                                case $decision in
                                        [yY] )
						echo ""
                                                echo "Please enter an email title:"
                                                read emailtitle
                                                echo ""
                                                echo "Please enter your message:"
                                                read emailmessage
						grep -i $speciesname speciesDetails.txt | awk 'BEGIN{FS=";"} {print $4}' | sort -u > speciesDetailsAlpha.txt
                        			emailaddresses=""
						addressnumber=$(grep -c "@" speciesDetailsAlpha.txt)
						counter=0
						while [ $addressnumber -gt $counter ]
                                                do 
                                             		interestline=$((counter+1))
							emailaddress=$(sed ""$interestline"q;d" speciesDetailsAlpha.txt | awk '{ print $1 }')","
                                                	emailaddresses=$emailaddresses$emailaddress
							counter=$((counter+1))
                                                done
                                                echo "$message" | mail $emailaddresses -s "$emailtitle"
                                                echo "Your email has been sent to" $emailaddresses
                                                echo ""
                                                ./email.sh
                                                ;;
                                        [nN] )
                                                echo "OK"
                                                ./email.sh
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
