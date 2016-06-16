=========================================================

> Change Open Directory Password and/or Set Home Directory
> 
> and/or Send password via email to user and/or to admin
> 
> Version: 7.3

=========================================================

### Open Directory Infos 

You must edit the script according to your need

for now it is basic, and targeted to be run with no arguments

Maybe will evolve to have all variables as arguments in the future

	diradminName: OD admin Short Name
  
   "diradmin" by default **[security Risks here]**

	diradminPSW: OD admin Password [security Risks here]


### Switches ##

**Create_NetworkHomeDir: 0 or 1**

  - Set to 1 - if you DO want home directories to be set
  - Set to 0 - if you DON'T want home directories to be Set

**SendEmail: 0 or 1**

  - Set to 0
  -- if you DON'T want the password sent by email to the user(s) you're changing the password
  - Set to 1
  -- if you DO want to send the password by email to the user(s) you're changing the password

**SendEmailReport:  0 or 1** 

 Send new settings to admin account: it@example.com
 
  - Set to 0 -- if you DON'T want to send a report by email to you.
  - Set to 1 -- if you DO want to receive a report by email.


### Input Password File

 `CsvUsersPswList`: **csv password file** 
 
Should be like : user,password,email per line

The file Must be in the same directory as the script, or as an input:

  - If your harcode it in the script put ONLY the file's name
	Something like **userpsw00.csv** 
  - If you want an input file :
	- Drag and drop the CSV file in your Terminal Window 
	- Or pass the FULL path of your file as an argument

 **CsvSeparator**: 
 - csv file separator field
  - Change to whatever separator field you have in your csv **"," ";"**
```

### Domains and emails
**emaildomain:** Your email domain
  - like example.com (if you want to send the email to the user or IT Team)
 
This script will append this domain to users shortname found in the csv

*See the switches above to send password by email to user*
  	If your user's emails is not set then This script will append this domain to users shortname found in the csv, and shortname@example.com will be set at the destination email to send the password. default is no email sent.
		see below for the switches

**emailreport:** If you want to send email to you
 put Your (admin) email like admin@example.com

### Network Home Directories Specific

**Server_hostname**: FQDN of the Hosting Home Directory Server
	Not necessarily your OD server !
 either server.int.$emaildomain
 or server.$emaildomain
 for example with $emaildomain=example.com setup above
 would be server.hq.example.com

**Net_HomeDir:**
  Absolute path of Network Home Directories on the Hosting HomeDir Server
  should be something like "/Volumes/DATAS/Users"

