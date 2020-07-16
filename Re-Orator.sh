#!/bin/bash
#
###############################################################################################################################################
#
# ABOUT THIS PROGRAM
#
#	Re-Orator.sh
#	https://github.com/Headbolt/Re-Orator
#
#   This Script is designed for use in JAMF in a policy run with a Smart Group to Target it.
#		
#   - This script will ...
#			Delete and then re-write a text file up to 3 Lines long, with optional spacing between lines
#			and also write a very specific timestamp to the file for versioing purposes.
#
###############################################################################################################################################
#
# HISTORY
#
#   Version: 1.0 - 16/07/2020
#
#   - 16/07/2020 - V1.0 - Created by Headbolt
#
###############################################################################################################################################
#
#   DEFINE VARIABLES & READ IN PARAMETERS
#
###############################################################################################################################################
#
TextFilePath=$4 # Grab the path to the text file from JAMF variable #4 eg /Library/Security/PolicyBanner.txt
#TimeStampVariable=$5 # Grab the required TimeStamp from JAMF variable #5 eg 2020-07-16_17:00:00
#
Line1="${6}" # Grab the required First Line of text from JAMF variable #6 eg TEXT LINE 1
BlankLine12="${7}" # Grab the required number of Blank Lines between Lines 1 and 2 of Text from JAMF variable #7 eg 3
Line2="${8}" # Grab the required Second Line of text from JAMF variable #8 eg TEXT LINE 2
BlankLine23="${9}" # Grab the required number of Blank Lines between Lines 2 and 3 of Text from JAMF variable #9 eg 2
Line3="${10}" # Grab the required Third Line of text from JAMF variable #10 eg TEXT LINE 3
#
ScriptName="append suffix as required - Delete and Re-Write TextFile with Stamp" # Set the name of the script for later logging
#
###############################################################################################################################################

# Checking and Setting Variables Complete
#
###############################################################################################################################################
# 
# SCRIPT CONTENTS - DO NOT MODIFY BELOW THIS LINE
#
###############################################################################################################################################
#
# Defining Functions
#
###############################################################################################################################################
#
# Target File TimeStamp Function
#
FileTimeStamp(){
#
/bin/echo 'Checking TimeStamp Variable Correctly Set'
#
IFS='_' # Internal Field Seperator Delimiter is set to UnderScore (_)
DateStamp=$(echo $TimeStampVariable | awk '{ print $1 }') # Splits down the Date and Timne to extract the Date
TimeStamp=$(echo $TimeStampVariable | awk '{ print $2 }') # Splits down the Date and Timne to extract the Time
#
IFS='-' # Internal Field Seperator Delimiter is set to Dash (-)
Year=$(echo $DateStamp | awk '{ print $1 }') # Splits down the Date to extract the Year
Month=$(echo $DateStamp | awk '{ print $2 }') # Splits down the Date to extract the Month
Day=$(echo $DateStamp | awk '{ print $3 }') # Splits down the Date to extract the Day
#
IFS=':' # Internal Field Seperator Delimiter is set to Colon (:)
Hour=$(echo $TimeStamp | awk '{ print $1 }') # Splits down the Time to extract the Hour
Minute=$(echo $TimeStamp | awk '{ print $2 }') # Splits down the Time to extract the Minute
Second=$(echo $TimeStamp | awk '{ print $3 }') # Splits down the Time to extract the Second
#
unset IFS # Internal Field Seperator Delimiter re-disabled
#
if [[ $Year != "" ]]
	then
		if [[ $Month != "" ]]
			then
				if [[ $Day == "" ]]
					then
						/bin/echo 'Date not set Correctly'
						/bin/echo 'Please Set Date according to Variable Guidelines'
						SectionEnd # Calling the Section End Function to make Screen Output / Reporting easier to read
						ScriptEnd # Calling the Script End Function to make Screen Output / Reporting easier to read
						exit 1
				fi
			else
				/bin/echo 'Date not set Correctly'
				/bin/echo 'Please Set Date according to Variable Guidelines'
				SectionEnd # Calling the Section End Function to make Screen Output / Reporting easier to read
				ScriptEnd # Calling the Script End Function to make Screen Output / Reporting easier to read
				exit 1
		fi
	else
		/bin/echo 'Date not set Correctly'
		/bin/echo 'Please Set Date according to Variable Guidelines'
		SectionEnd # Calling the Section End Function to make Screen Output / Reporting easier to read
		ScriptEnd # Calling the Script End Function to make Screen Output / Reporting easier to read
		exit 1
fi
#
if [[ $Hour == "" ]]
	then
		Hour='00'
fi
if [[ $Minute == "" ]]
	then
		Minute='00'
fi
if [[ $Second == "" ]]
	then
		Second='00'
fi
#
FileStamp=$Year$Month$Day$Hour$Minute.$Second
#
}
#
###############################################################################################################################################
#
# Evaluate Lines Function
#
EvaluateLines(){
#
/bin/echo 'Evaluation Variables to determine Lines and Spaces that need writing'
SectionEnd # Calling the Section End Function to make Screen Output / Reporting easier to read
#
if [[ $Line1 != "" ]]
	then
		LineWrite "$Line1" 1
fi
#
if [[ $Line2 != "" ]]
	then
		/bin/echo # Outputting a Blank Line for Reporting Purposes
		if [[ $BlankLine12 != "" ]]
			then
				BlankLineWrite $BlankLine12
		fi
		SectionEnd # Calling the Section End Function to make Screen Output / Reporting easier to read
		LineWrite "$Line2" 2
fi
#
if [[ $Line3 != "" ]]
	then
		/bin/echo # Outputting a Blank Line for Reporting Purposes
		if [[ $BlankLine23 != "" ]]
			then
				BlankLineWrite $BlankLine23
		fi
		SectionEnd # Calling the Section End Function to make Screen Output / Reporting easier to read
		LineWrite "$Line3" 3
fi
#
}
#
###############################################################################################################################################
#
# Line Writing Function
#
LineWrite(){
#
Line=$1
LineNo=$2
/bin/echo 'Writing Line' $LineNo
/bin/echo '"'$Line'"'
/bin/echo 'to File '"'$TextFilePath'"''
#
/bin/echo $Line >> $TextFilePath
#
}
#
###############################################################################################################################################
#
# Blank Line Writing Function
#
BlankLineWrite(){
#
BlankLines=$1 # Pull in the number of Blank Lines to add as per parsed number
#
if [[ $BlankLines == "1" ]] # Purely for grammatical purposes, check number to output correct message
	then
		/bin/echo 'Adding 1 Blank Line For Spacing Purposes'
	else
		/bin/echo 'Adding '$BlankLines' Blank Lines For Spacing Purposes'
fi
#
until [ $BlankLines -eq 0 ] # Keep adding blank Lines until Counter reaches 0
do
	/bin/echo >> $TextFilePath
	((BlankLines=BlankLines-1))
done
#
}
#
###############################################################################################################################################
#
# Section End Function
#
SectionEnd(){
#
/bin/echo # Outputting a Blank Line for Reporting Purposes
#
/bin/echo  ----------------------------------------------- # Outputting a Dotted Line for Reporting Purposes
#
/bin/echo # Outputting a Blank Line for Reporting Purposes
#
}
#
###############################################################################################################################################
#
# Script End Function
#
ScriptEnd(){
#
/bin/echo Ending Script '"'$ScriptName'"'
#
/bin/echo # Outputting a Blank Line for Reporting Purposes
#
/bin/echo  ----------------------------------------------- # Outputting a Dotted Line for Reporting Purposes
#
/bin/echo # Outputting a Blank Line for Reporting Purposes
#
}
#
###############################################################################################################################################
#
# End Of Function Definition
#
###############################################################################################################################################
# 
# Begin Processing
#
###############################################################################################################################################
#
/bin/echo # Outputting a Blank Line for Reporting Purposes
SectionEnd # Calling the Section End Function to make Screen Output / Reporting easier to read
#
FileTimeStamp # Calling the FileTimeStamp Function to Check the Variable is Correctly Set and Pull out the Relevant Data
SectionEnd # Calling the Section End Function to make Screen Output / Reporting easier to read
#
rm $TextFilePath # Deleting Existing File
#
EvaluateLines # Calling the EvaluateLines Function to evaluate Variables to determine Lines and Spaces that need writing'
SectionEnd # Calling the Section End Function to make Screen Output / Reporting easier to read
#
/bin/echo 'Setting Timestamp of new file to' $FileStamp
touch -t $FileStamp $TextFilePath
#
SectionEnd # Calling the Section End Function to make Screen Output / Reporting easier to read
ScriptEnd # Calling the Script End Function to make Screen Output / Reporting easier to read
