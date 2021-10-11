#!/bin/bash
count=0
while [ $count -lt 4 ]
do
if [ $count -eq 0 ]
then
echo "Please enter species name: "
read name
if ! [ -z "${name}" ]
then 
count=$((count+1))
else
echo "Warning: You cannot enter a blank name"
fi
fi
if [ $count -eq 1 ]
then
echo "Please enter species location: "
read location
if ! [ -z "${location}" ]
then
count=$((count+1))
else
echo "Warning: You cannot enter a blank location"
fi
fi
if [ $count -eq 2 ]
then
date=`date`
count=$((count+1))
fi
if [ $count -eq 3 ]
then
echo "Please enter your email: "
read email
if ! [ -z "${email}" ]
then
count=$((count+1))
else
echo "Warning: You cannot enter a blank email"
fi
fi
echo "-------------Entered Data--------------"
echo $name "; " $location "; " $date "; " $email ";"
echo "---------------------------------------"

echo -n "Are you sure you wnat to add this record (y/n): "
read answer
if [[ "$answer" == "y" || "$answer" == "Y" ]]
then
echo "------------------------"
echo $name "; " $location "; " $date "; " $email ";" "added successfully"
echo "-----------------------"
echo $name "; " $location "; " $date "; " $email ";" >> speciesDetails.txt
else
echo "Record has not been added"
fi
echo
echo "Would you like to add another record [y/n]?"
read answer
case $answer in 
[yY])
./add.sh
;;
[nN])
./menu
;;
*) ./menu;;
esac
done
