#!/usr/bin/python2.7

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
# Version 1.0.0 - 2/20/2013

# Modified by
# Version 

# Script Variables
import xml.dom.minidom
import os
import plistlib
import urllib2

sourceDir = "/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/"
destineDir = "/Users/Shared/XProtect/"
xPath = ".version/"
file = "XProtect.plist"
metaFile = "XProtect.meta.plist"
apple3 = "http://configuration.apple.com/configurations/macosx/xprotect/3/clientConfiguration.plist"

# Print the Version of the local XProtect.meta.plist
xmeta = (os.path.join(sourceDir, metaFile))
if os.path.isfile(xmeta):
	info = plistlib.readPlist(xmeta)
	if info.get('Version'):
            print info['Version']

