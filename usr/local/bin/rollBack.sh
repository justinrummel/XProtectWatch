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
# Version 1.0.0 - 2013-3-22

# Modified by
# Version 


### Description 
# Goal is to 

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
#rm=`ls -al /Users/Shared/XProtect/ | tail -1 | awk '{print $9}'`
#meta=`echo "${lastX}" | sed 's/plist/meta.plist/'`

# Script Functions
verifyRoot () {
    #Make sure we are root before proceeding.
    [ `id -u` != 0 ] && { echo "$0: Please run this as root."; exit 0; }
}

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

stop () {
	logThis "Stopping com.apple.xprotectupdater"
	launchctl unload /System/Library/LaunchDaemons/com.apple.xprotectupdater.plist
	launchctl unload /Library/LaunchDaemons/com.xprotectwatch.XProtect.plist
}

clean () {
	# remove the .version file 
	logThis "removing ${destineDir}${XPath}${version}"
	rm "${destineDir}${XPath}${version}"

	# remove the last two plist files in the destination folder /Users/Shared/XProtect
	logThis "removing last two files in ${destineDir}"
	last1=`ls -al /Users/Shared/XProtect/ | tail -1 | awk '{print $9}'`
	rm "${destineDir}${last1}"
	last2=`ls -al /Users/Shared/XProtect/ | tail -1 | awk '{print $9}'`
	rm "${destineDir}${last2}"
}

replace () {
	logThis "Begin replacing old data to be 'current'"

	last3=`ls -al /Users/Shared/XProtect/ | grep -v meta | tail -1 | awk '{print $9}'`
	logThis "copping ${last3} to it's old house"
	cp "${destineDir}${last3}" /System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/XProtect.plist

	meta3=`echo "${last3}" | sed 's/plist/meta.plist/'`
	logThis "copping ${meta3} to it's old house"
	cp "${destineDir}${meta3}" /System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/XProtect.meta.plist
}

start () {
	logThis "Starting com.apple.xprotectupdater"
	launchctl load /Library/LaunchDaemons/com.xprotectwatch.XProtect.plist
	launchctl load /System/Library/LaunchDaemons/com.apple.xprotectupdater.plist
}

verifyRoot
init
stop
clean
replace
start

exit 0;
