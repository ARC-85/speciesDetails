#!/bin/bash

echo $'\n********************************************************************'
echo $'\n-----------------------Search Records----------------------------\n'
echo $'********************************************************************\n'
PS3=$'\nTo search a record, please choose one of the above options (enter the number): ' #menu script for the different search options
options=("View entire species list alphabetically" "Search by species name" "Main Menu") #different search options
select opt in "${options[@]}"
do 
        case $opt in
                "View entire species list alphabetically") #if user wants to see list of all species alphabetically...
                        awk '{print $1}' speciesDetails.txt | sort -u  > speciesDetailsAlpha.txt #passes first field (species name) of text file to sort alphabetically and remove duplicates and prints in temporary file
			cat -n speciesDetailsAlpha.txt #displays list from temporary file
			echo $'\nWould you like to search further (y/n)?\n' #checks if user wants to do another search now they've seen list of species
			read decision
			case $decision in #if yes (big or small y)
				[yY] )
					echo "OK"
					./search.sh #go back to search shell
					break
					;;
				[nN] ) #if no (big or small n)
                                        echo "OK"
                                        ./menu #go back to main menu
					break
                                        ;;
                                *) 	echo $'\nDid not understand. Returning to Search Menu' #if invalid input
					./search.sh #go back to search shell
                        		break
					;; 
			esac
                        ;;

                "Search by species name") #if user wants to search by specific species name...
                        echo $'\nPlease enter species name: '
                        read name #assigns variable to species name
                        searchNumber=`grep -c -i $name speciesDetails.txt` #assigns variable to number of times species is listed, case insensitive
                        if [ $? -eq 1 ]; #if previous command fails, i.e. no records matching...
                        then
                                echo $'\nNo species found\n'
                                ./search.sh #return to search shell
                        else
				if [ $searchNumber -lt 2 ] #if the number of species records found is only 1 (but not zero)...
				then
                                	echo $'\nThere is' $searchNumber $'record of that species\n' #state the number of species
					grep -n -i $name speciesDetails.txt #show the species details, case insensitive 
                                else
					echo $'\nThere are' $searchNumber $'records of that species\n' #if the number of species is more than 1...
					grep -n -i $name speciesDetails.txt | awk 'BEGIN {FS=";"} {print $1 $2}' #show the 1st and 2nd fields for each record of that species, i.e. name and location
				fi
				echo $'\nWould you like to search further (y/n)?' #checks if user wants to search further
              	                read decision #assigns variable to decision
                                case $decision in 
                               		[yY] ) #if yes (big or small y)
                                        	echo "OK"
                                       		./search.sh #return to search shell
						break
						;;
                                	[nN] ) #if no (big or small n)
                                       		echo "OK"
                                        	./menu #return to main menu
						break
                                        	;;
                                	*) echo ./search.sh #if invalid input then return to seach shell
						break
						;;
                         	esac
                        fi
                        break
                        ;;

                "Main Menu") #if main menu option selected...
                        echo $'\nReturning to Main Menu!\n'
                        ./menu #return to main menu
                        break
                        ;;

                *) echo $'\nInvalid option. Please enter a number 1-3' #if invalid selection then user asked to input valid option

        esac
done
