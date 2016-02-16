#!/bin/bash
## Change LDAP User's Password from csv
## V7.3 - oem @ oemden.com 

## With diradmin Hardcoded MDP !!!! WARNING SECURITY RISKS.

###################################################
## What we need :
## 1 List of Users
## 2 Diradmin credentials (hardcoded below)
###################################################

###################################################
################# EDIT BELOW START ################
Version="7.2"
## OpenDirectory Credentials !!!! WARNING SECURITY RISKS.
diradminName="diradmin" # Open Directory admin Short Name, diradmin by default - Hardcoded be carefull
diradminPSW='P@ssw0rd' # Open Directory admin Password - Hardcoded be carefull

## Users list infos
CsvUsersPswList="userpsw.csv" # !!!! if full path NOT passed as argument, put the Name of the file and the file Must be in the same directory ( should be like : user,password on each line )
CsvSeparator="," # Change to whatever separate field you have in your csv , ;

## FQDN-DNS
emaildomain="int.example.com"
emailreport="super.admin@example.com"

#Edit the User email Object"
send_emailuser_Object="Please find your New Password "
#Edit the reporting email object (to yourself)
send_emailreport_Object="New Password Notification"

## Network Home Directories Specific
Server_hostname="server.$emaildomain" # FQDN of the Home Directory Hosting Server - example : file.int.example.com
Net_HomeDir="/Volumes/datas/Users" # Absolute path of Home Directories on the Hosting HomeDir Server

## Switches
Change_Password=0 # Set to 0 if you don't want home directories
Create_NetworkHomeDir=0 # Set to 0 if you don't want home directories
SendEmail=0 # Set to 0 if you don't want to send the password by email to the user
SendEmailReport=0 # Set to 0 if you don't want to send a report by email to you.

################# EDIT ABOVE STOP ################
##################################################

##################################################
## Don't edit below unless you know what you do ##
##################################################
clear
Date=`date`
ScriptPath=`dirname $0`

## ========== CHECKS PREREQ =============
function sudo_check {
	if [ `id -u` -ne 0 ] ; then
		printf "must be run as sudo, exiting"
		echo 
		exit 1
	fi
}

function file_Exist {
	if [[ ! -e "$1" ]] ; then
		printf "Did not found password File\n Exiting now\n\n"
		mini_Help
	fi
}

function Check_PSWFile_exist {
	##If no input file passed
	if [[ ! "$1" ]] ; then
		echo "no input file - check hardcoded password file path"
			##check file is hardcoded in script and exists
			UsersPswList="$ScriptPath/$CsvUsersPswList"
			file_Exist "$UsersPswList"
			echo "Password file \"$UsersPswList\" exists"
	else
		##If input file is passed
		UsersPswList="$1"
		##check input file exists
		file_Exist "$UsersPswList"
			echo "UsersPswList: $UsersPswList"
			echo "Input file exists"
	fi
	echo "Passed Password file check"
	clear
}

#### ECHO DEV #####
function echo_Dev {
	echo "- - - - - - - $Date - - - - -"
	echo "Path $ScriptPath"
	echo "diradminName: $diradminName"
	echo "diradminPSW: $diradminPSW"
	echo "Server_hostname: $Server_hostname"
	echo "Net_HomeDir: $Net_HomeDir"
	echo "UsersPswList: $UsersPswList"
	echo "CsvSeparator: $CsvSeparator"
	echo "change password command: dscl -u $diradminName -P '$diradminPSW' /LDAPv3/127.0.0.1 -passwd /Users/$User $Psw ; "
	echo "create NFSHomeDirectory Record: dscl -u $diradminName -P '$diradminPSW' /LDAPv3/127.0.0.1 -create /Users/$User NFSHomeDirectory /Network/Servers/$Server_hostname$Net_HomeDir/$User ; "
	echo "create HomeDirectory Record: dscl -u $diradminName -P '$diradminPSW' /LDAPv3/127.0.0.1 -create /Users/$User HomeDirectory <home_dir><url>afp://$Server_hostname$Net_HomeDir</url><path>$User</path></home_dir> ; "
	echo "- - - - - - - - - - - - - - - - - - - - - - - - - - -"
}

#### Basic Help
function mini_Help {
	printf "## Open Directory Infos ## \n"
	printf "  minihelp \n	You must edit the script according to your need\n	for now it is basic, and targeted to be run with no arguments\n	Maybe will evolve to have all variables as arguments in the future\n\n" 
	printf " diradminName: OD admin Short Name\n  - \"diradmin\" by default [security Risks here]\n\n"
	printf " diradminPSW: OD admin Password [security Risks here]\n\n"
	printf "## Input Password File ##\n"
	printf " CsvUsersPswList: csv password file \n  ### should be like : user,password on each line ### \n  ### the file Must be in the same directory as the script ###\n  - If your harcode it in the script put ONLY the file's name\n	Something like \"userpsw00.csv\" \n"
	printf "  - If you want an input file \n	- Drag and drop the CSV file in your Terminal Window \n	- Or pass the FULL path of your file as an argument\n\n"
	printf " CsvSeparator: csv file separator field\n  Change to whatever separator field you have in your csv \n \",\" \";\"\n\n"
	printf "## Domains and emails ##\n"
	printf "emaildomain: Your email domain\n  - like example.com\n	This script will append this domain to users shortname found in the csv\n	See below the switches to send password by email\n  	If your user's emails is not set then shortname@example.com will be set\n		see below for the switches\n\n"
	printf "emailreport: If you want to send email to you\n put Your (admin) email like admin@example.com\n\n"
	printf "## Network Home Directories Specific ##\n"
	printf "Server_hostname: FQDN of the Hosting Home Directory Server\n	Not necessarily your OD server !\n either server.int.\$emaildomain\n or server.\$emaildomain\n for example with \$emaildomain=$emaildomain setup above\n would be server.int.$emaildomain\n\n" 
	printf "Net_HomeDir:\n  Absolute path of Network Home Directories on the Hosting HomeDir Server\n  should be something like \"/Volumes/DATAS/Users\"\n\n"
	printf "## Switches ##\n"
	printf "Create_NetworkHomeDir: 0 or 1 \n  - Set to 1\n  - if you DO want home directories to be set\n  - Set to 0\n  - if you DON'T want home directories to be Set\n\n"
	printf "SendEmail: 0 or 1 \n  - Set to 0\n  -- if you DON'T want the password sent by email to the user(s) you're changing the password\n  - Set to 1\n  -- if you DO want to send the password by email to the user(s) you're changing the password\n\n"
	printf "SendEmailReport:  0 or 1 \n Send new settings to admin account: $emailreport\n  - Set to 0\n  -- if you DON'T want to send a report by email to you.\n  - Set to 1\n  -- if you DO want to receive a report by email.\n\n"
	exit 1
}

#### CHANGE PASSWORDS
function chg_Password {
	if [[ ! "$Psw" ]] ; then
		echo "Psw empty for user: \"$User\" Not changing Password"
	else
		dscl -u "$diradminName" -P "$diradminPSW" /LDAPv3/127.0.0.1 -passwd /Users/"$User" "$Psw" ; 
		echo "	$Date : Changed passw for User \"$User\"" && logger "$Date : Changed passw for User \"$User\"" 
	fi
}

#### CREATE HOME DIRS
function set_NFSHomeDirectory {
	dscl -u "$diradminName" -P "$diradminPSW" /LDAPv3/127.0.0.1 -create /Users/"$User" NFSHomeDirectory /Network/Servers/$Server_hostname$Net_HomeDir/"$User" ; 
	echo "	$Date : Created NFSHomeDirectory Record /Network/Servers/$Server_hostname$Net_HomeDir/$User" && logger "$Date : Created NFSHomeDirectory Record for User \"$User\""
}
function set_HomeDirectory {
	dscl -u "$diradminName" -P "$diradminPSW" /LDAPv3/127.0.0.1 -create /Users/"$User" HomeDirectory "<home_dir><url>afp://$Server_hostname$Net_HomeDir</url><path>$User</path></home_dir>" ; 
	echo "	$Date : Created HomeDirectory Record <home_dir><url>afp://$Server_hostname$Net_HomeDir</url><path>$User</path></home_dir>" && logger "$Date : Created HomeDirectory Record for User \"$User\""
}

######################### REAL WORK ########################
function Do_it {
	echo "========================================================="
	echo " Change Open Directory Password and/or Set Home Directory"
	echo " and/or Send password via email to user and/or to admin"
	echo " Version: $Version"
	echo "========================================================="
	sudo_check
	Check_PSWFile_exist "$1"
	OLDIFS=$IFS
	IFS="$CsvSeparator"
	while read User Psw Mail
		do
			echo "----------------------------------"
			##Check if Mail is present
				if [[ ! "$Mail" ]] ; then
					emailuser="$User@$emaildomain"
					printf "No email set for user $User,\n setting email to $emailuser\n\n"
				else
					emailuser="$Mail"
					printf "Email for user $User is set to: $emailuser\n\n"
				fi
			##Change PSW
			Change_ODUsers
			##Send emails
			send_email
		echo "----------------------------------"
		echo
		done < "$UsersPswList"
	echo "========================= Done ==========================" && echo
}	

function Change_ODUsers {
	if [[ "$Change_Password" == "1" ]] ; then
		echo "\$Change_Password = $Change_Password: Changing Password"
		echo "chg_Password \"$User\" \"$Psw\""
		chg_Password "$User" "$Psw"
		if [[ "$Create_NetworkHomeDir" == "1" ]] ; then
			if [[ -n "$Server_hostname" ]] && [[ -n "$Net_HomeDir" ]] ; then
				echo " \$Create_NetworkHomeDir = $Create_NetworkHomeDir , Setting Network Home Directory for user \"$User\""
				echo "set_NFSHomeDirectory && set_HomeDirectory"
				set_NFSHomeDirectory "$User"
				set_HomeDirectory "$User"
			else
				printf " ! WARNING ! \n	missing Server_hostname and/or Net_HomeDir Variables \n	Please edit the script and relaunch it \n exiting with error \n\n"
				exit 1
			fi
		else
			echo "Only Changed Users Password	"
		fi
	elif [[ "$Change_Password" == "0" ]] ; then
		echo "\$Change_Password = $Change_Password: Not changing Password"
	fi
}

######################## Send Emails ########################
function send_emailuser {

mailx -s "$send_emailuser_Object" "$emailuser" <<EOF 

 Dear $User,
 
 Your New password is : 
  
	$Psw
 
 Best Regards, 

 The It service

EOF

}

function send_emailreport {

	if [[ "$Create_NetworkHomeDir" == "1" ]] ; then

mail -s "$send_emailreport_Object for User \"$User\"" "$emailreport" <<EOF 

"	$Date :"

	User "$User" new Password is : "$Psw"
"	Created NFSHomeDirectory Record /Network/Servers/$Server_hostname$Net_HomeDir/$User" 
"	Created HomeDirectory Record <home_dir><url>afp://$Server_hostname$Net_HomeDir</url><path>$User</path></home_dir>"

EOF

	else

mail -s "$send_emailreport_Object for User \"$User\"" "$emailreport" <<EOF 

"	$Date :"

	User "$User" new Password is : "$Psw"

EOF

	fi
}

function send_email {
		## ------------------------
		
		if [[ "$SendEmail" == "1" ]] ; then
			if [[ "$Psw" =~ "secret" ]] || [[ ! "$Psw" ]] || [[ "$User" =~ "scan" ]] ; then
				echo "Password is empty, does not comply, or User is a scanner"
				echo "email for user: \"$User\"  Not sent."
			else
				send_emailuser > /dev/null 2>&1 && echo "email sent to \"$User\" at \"$emailuser\""
			fi
		elif [[ "$SendEmail" == "0" ]] ; then
			echo "email for user: \"$User\"  Not sent."
		fi
		
		## ------------------------
		if [[ "$SendEmailReport" == "1" ]] ; then
			if [[ ! "$Psw" ]] ; then
				echo "Psw empty, emailreport for user: \"$User\" Not sent to admin"
			else
				send_emailreport > /dev/null 2>&1 && echo "emailreport for user: $User sent to admin \"$emailreport\""
			fi		
		elif [[ "$SendEmailReport" == "0" ]] || [[ "$Psw" == "secret" ]] ; then
			echo "emailreport for user: \"$User\" Not sent to admin"
		fi
		## ------------------------
}

######################## PROGRAM ########################

Do_it "$1"

####################### TODOs #####################
## TODOs
## ASK FOR ADMIN AND PASSW if psw empty
## means -p -l -f options... 
