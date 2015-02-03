#!/bin/bash

# Copyright (c) 2015 Justin Rummel
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

# Created by Justin Rummel
# Version 1.0.0 - 2013-02-20

# Modified by
# Version 1.1.0 - 2013-03-22 by Justin Rummel

### Description 
# Goal is to copy XProtect.plist files to your local /Users/Shared/XProtect folder so you can review what has changed
# when apple updates their XProtect information.  This is not a management system. 
# if Terminal Notifier is installed, will use Notification Center to display an update

# Base Variables that I use for all scripts.  Creates Log files and sets date/time info
declare -x SCRIPTPATH="${0}"
declare -x RUNDIRECTORY="${0%/*}"
declare -x SCRIPTNAME="${0##*/}"

logtag="${0##*/}"
debug_log="disabled"							#	Change to "enable" to start debug logs
logDate=`date +"%Y-%m-%d"`
logDateTime=`date +"%Y-%m-%d_%H.%M.%S"`
log_dir="/Library/Logs/${logtag}"
LogFile="${logtag}-${logDate}.log"

# Script Variables
sourceDir="/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/"
destineDir="/Users/Shared/XProtect/"
XPath=".version/"
file="XProtect.plist"
metaFile="XProtect.meta.plist"
version=`/usr/libexec/PlistBuddy -c "print :Version" /System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/XProtect.meta.plist`
notifier="/Applications/terminal-notifier.app/Contents/MacOS/"


# Script Functions
# Output to stdout and LogFile.
logThis () {
    logger -s -t "${logtag}" "$1"
    [ "${debug_log}" == "enable" ] && { echo "${logDateTime}: ${1}" >> "${log_dir}/${LogFile}"; }
}

init () {
	# Make our log directory
    [ ! -d $log_dir ] && { mkdir $log_dir; }

    # Now make our log file
    if [ -d $log_dir ]; then
        [ ! -e "${log_dir}/${LogFile}" ] && { touch $log_dir/${LogFile}; logThis "Log file ${LogFile} created"; logThis "Date: ${logDateTime}"; }
    else
        echo "Error: Could not create log file in directory $log_dir."
        exit 1
    fi
    echo " " >> "${log_dir}/${LogFile}"
}

# Lets begin
init

[ ! -d "${destineDir}" ] && { mkdir "${destineDir}"; logThis "${destineDir} was created"; } || { logThis "${destineDir} already available... moving on."; }
[ ! -d "${destineDir}${XPath}" ] && { mkdir "${destineDir}${XPath}"; logThis "${destineDir}${XPath} was created"; } || { logThis "${destineDir}${XPath} already available... moving on."; }
[ ! -e "${destineDir}${XPath}${version}" ] && {
	touch "${destineDir}${XPath}${version}"
		logThis "created touch file ${version}"
	cp "${sourceDir}${file}" "${destineDir}${logDateTime}-${file}"
		logThis "coppied ${file}"
	cp "${sourceDir}${metaFile}" "${destineDir}${logDateTime}-${metaFile}"
		logThis "coppied ${metaFile}"

	if [ -n "$(pgrep NotificationCenter)" ]; then
		logThis "Sending terminal-notifier to NotificationCenter"
		[ -d "${notifier}" ] && { "${notifier}"terminal-notifier -message "There is an update for XProtect!" -title XProtect -subtitle "Click to open ${destineDir}" -execute "open "${destineDir}" "; logThis "Notification sent!"; } || { logThis "Could not find ${notifier}"; }
	else
		logThis "Could not find PID for NotificationCenter"
	fi
} || { logThis "Duplicate .version file.  What are you trying to do?!"; }

exit 0;