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
# Version 1.0.0 - 3/06/2013

# Modified by
# Version 


### Description 
# Goal is install terminal-notifier zipped binary from their git repo.

# Base Variables that I use for all scripts.  Creates Log files and sets date/time info
declare -x SCRIPTPATH="${0}"
declare -x RUNDIRECTORY="${0%/*}"
declare -x SCRIPTNAME="${0##*/}"

logtag="${0##*/}"
debug_log="enable"
logDate=`date +"% Y.% m.% d"`
logDateTime=`date +"% Y.% m.06_% H-% M-% S"`
log_dir="/Library/Logs/${logtag}"
LogFile="${logtag}-${logDate}.log"

# Script Variables
tn="terminal-notifier_1.6.2"
dl="https://github.com/downloads/alloy/terminal-notifier/${tn}.zip"
tnHash="75f860735691002af0d90bd5df0cbda0"
dest="/Applications/"

# Script Functions
download () {
	cd /tmp
	curl -OL "${dl}"
}

unzipTN () {
	cd /tmp
	hash=`openssl md5 /tmp/"${tn}" | awk -F "= " '{print $2}'`

	[ "${hash}" == "${tnHash}" ] && { unzip "${tn}"; mv "/tmp/${tn}/terminal-notifier.app" "${dest}"; } || { logger "hash ${hash} did not match ${tnHash}.  Stopping now."; exit 1; }
}


existing=`which terminal-notifier | awk -F "/" '{print $NF}'`
[[ "${existing}" != "terminal-notifier" ]] && { download; unzipTN; } || { echo "Terminal Notifier is already installed."; }
exit 0
