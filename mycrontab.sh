#!/bin/bash
#menu_Crontabs
display_Crontabs ()
{
echo "Here are the contents of your crontab file: "
crontab -l | more
mycrontab=$(readlink -f "$0")
exec "$mycrontab"
}

#----------------------------ADDING CRONTAB FUNCTION----------------------
add_Crontab ()
{

#Create temporary file to store cron commands for later installation.
touch /tmp/tempcron.txt

#This lists contents of the crontab file through the temporary file.
crontab -l > /tmp/tempcron.txt

#Introduce the user.
echo "Here you may add a new crontab. To exit the program type '9' and press RETURN"

#Ask for input from the user
echo "Please enter required fields: "
echo "Please enter the minutes you require to run (0-59) "
read minutes


until [[  "$minutes" = '*' || "$minutes" =~ [0-9] && $minutes -ge 0 && $minutes -le 59 ]] 
do

#Start validation process for the minutes field
if [[ "$minutes" -lt 0 ]];
then 
	echo  "You have entered a negative number."
        read  minutes

elif  [[ -z " $minutes" ]];
then 
	echo "You did not enter anything"
	minutes = '\*'
#If input field contains anything other than an integer value (Identical to other variables)
elif ! [[ "$minutes" =~ [^a-zA-Z\] ]];
then 
	echo  "Please enter numerical characters only"
        read minutes

elif  [[ "$minutes" -ge 60 ]];
then 
	echo "The number you entered was too high."
	read minutes
#For all remaninging variations of incorrect data
else
	echo "Invalid characters. Please try again."
	read minutes
fi
done
#End of the minute field validation

#Start validation process for the hours field
echo "Please enter the hours you wish to run(0-23) "
read hours

until [[  "$hours" = '*' || "$hours" =~ [0-9] && "$hours" -ge 0 && "$hours" -le 23 ]] 
do

if [[ "$hours" -lt 0 ]];
then 
	echo  "You have entered a negative number "
        read  hours

elif  [[ -z " $hours" ]];
then 
	echo "You did not enter anything."
	read hours

elif ! [[ "$hours" =~ [^a-zA-Z\] ]];
then 
	echo  "Please enter numerical characters only"
        read hours

elif  [[ "$hours" -ge 24 ]];
then 
	echo "The number you entered is too high"
	read hours
else
	echo "Invalid characters. Please try again."
	read hours
fi
done
#End of the hours field validation

#Start of the day of month validation
echo "Please enter the day of the month you wish to run(month) (1-31) "
read daym

until [[  "$daym" = '*' || "$daym" =~ [0-9] && "$daym" -ge 1 && "$daym" -le 31 ]] 
do

if [[ "$daym" -le 0 ]];
then 
	echo  "You have entered a negative number"
        read  daym

elif  [[ -z " $daym" ]];
then 
	echo "You did not enter anything"
	read daym

elif ! [[ "$daym" =~ [^a-zA-Z\] ]];
then 
	echo  "Please enter numerical characters only"
        read daym

elif  [[ "$daym" -ge 31 ]];
then 
	echo "The number you entered is too high"
	read daym
else
	echo "Invalid characters. Please try again"
	read daym
fi
done
#End of the day of month validation

#Start of the month validation
echo "Please enter the months you wish to run (1-12) "
read month

until [[  "$month" = '*' || "$month" =~ [0-9] && "$month" -ge 1 && "$month" -le 12 ]] 
do

if [[ "$month" -le 0 ]];
then 
	echo  "You have entered a negative number"
        read  month

elif  [[ -z " $month" ]];
then 
	echo "You did not enter anything"
	read month

elif ! [[ "$month" =~ [^a-zA-Z\] ]];
then 
	echo  "Please enter numerical characters only"
        read month

elif  [[ "$month" -ge 60 ]];
then 
	echo "The number you have entered is too high"
	read month
else
	echo "Invalid characters. Please try again "
	read month
fi
done
#End of the month validation

#Start of the day of the week validation
echo "Please enter days of the week you wish to run (0-6) " 
read dayw

until [[  "$dayw" = '*' || "$dayw" =~ [0-9] && "$dayw" -ge 0 && "$dayw" -le 6 ]] 
do

if [[ "$dayw" -lt 0 ]];
then 
	echo  "You have entered a negative number"
        read  dayw

elif  [[ -z " $dayw" ]];
then 
	echo "You did not enter anything"
	read dayw

elif ! [[ "$dayw" =~ [^a-zA-Z\] ]];
then 
	echo  "Please enter numerical characters only"
        read dayw

elif  [[ "$dayw" -ge 7 ]];
then 
	echo "The number you entered is too high"
	read dayw
else
	echo "Invalid characters. Please try again "
	read dayw
fi
done
#End of the day of the week validation

#Start of the command validation
echo "Please enter the command you wish to run"
read comm
#End of the command validation

#Joining results and installing contents of the temporary file into crontab
convalue="$minutes $hours $daym $month $dayw $comm"
destdir=/tmp/tempcron.txt
echo "$convalue" >> "$destdir"
clear
echo "Your command is: "; cat -n $destdir


#Install the tempcron.txt file as the new crontab.
crontab /tmp/tempcron.txt
mycrontab=$(readlink -f "$0")
exec "$mycrontab"
#End of the function
}

#----------------------------REMOVING CRONTAB FUNCTION----------------------
remove_Crontab ()
{
#Create temporary file to store cron commands for later installation.
touch /tmp/tempcron.txt
#This lists contents of the crontab file through the temporary file.
crontab -l > /tmp/tempcron.txt
cat -n /tmp/tempcron.txt
echo "Please select the number of crontab you would like to remove: "
read usrinput
sed -i "$usrinput"d /tmp/tempcron.txt
#Install the edited file as the new crontab
crontab /tmp/tempcron.txt
clear
#re-executes the program to loop to the main menu
mycrontab=$(readlink -f "$0")
exec "$mycrontab"
}

#----------------------------REMOVE ALL CRONTAB FUNCTION----------------------
remove_all_Crontabs ()
{
echo "Are you sure you want to remove ALL crontabs for this user? Changes cannot be reversed. Y/N: "
#Checks if user choice is of the 'Yes' response - if not, loops back to main menu
read usrchoice
if [[ $usrchoice == [yY] ]]
then
crontab -r
echo "Your crontab has been removed successfully"
else
echo "Program exiting. Crontab has not been removed."
exit
fi
#Clears the console and loops back to the main menu
clear
mycrontab=$(readlink -f "$0")
exec "$mycrontab"
}

#-----------------------------------MENU-------------------------------

echo ========= Crontab Scheduler =========
echo 1. Display crontab jobs
echo 2. Insert a job 
echo 3. Edit a job 
echo 4. Remove a job
echo 5. Remove all jobs 
echo 9. Exit 
echo --------- Select a command ---------
read -p 'Command : ' choice

#echo "You have chosen $choice"  
usr="$(whoami)"

#while [ $choice != [9] ]
#do
case "$choice" in 

#Case statements used to specify response to user input

1)echo "You have chosen $choice"
#Call the function for displaying crontabs
clear
display_Crontabs
;;
#Call the function for adding crontabs
2)echo "you have chosen $choice"
add_Crontab
;;
#Call the function for editing a crontab
3)
#----------------------------EDITING CRONTAB FUNCTION----------------------
cat -n /tmp/tempcron.txt
echo "Please choose a job to edit (by line number.)"
read -p 'Line Number: ' linechoice
echo "Please enter the new command: "
read -p 'New command: ' newcommand

#Takes input for line choice and substitutes a new command at that line position
sed -i "${linechoice}s/.*/${newcommand}/" /tmp/tempcron.txt

#Ammends edited temporary file & new command to master crontab file
crontab /tmp/tempcron.txt
clear
mycrontab=$(readlink -f "$0")
exec "$mycrontab"
;;
#Call the function for removing a specific crontab
4)echo "you have chosen $choice"
remove_Crontab
;;
#Call the function for removing all jobs
5)echo "you have chosen $choice"
remove_all_Crontabs
;;
#Exit the program on the spot
9)
clear
exit
;;
#Else statement that restarts the program should the user fail to enter a valid choice
*)
clear
echo "Invalid entry, please try again."
mycrontab=$(readlink -f "$0")
exec "$mycrontab"
;;
esac


#----------------------------------------------------------


