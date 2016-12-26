XProtectWatch
=============

XProtectWatch
-------------
This a tool to copy the XProtect.plist file whenever it changes via a User LaunchAgents.  This is not a management system for XProtect.

Copy the files as needed:

*	/usr/local/bin/watchProtect.sh
*	~/Library/LaunchAgents/com.xprotectwatch.XProtect.plist

Be sure to chmod +x /usr/local/bin/watchProtect.sh so it's an executable script and that the plist permissions are ```rwxr-xr-x  1 username  staff```

Once the files are copied to your computer in the correct locations you can load the LaunchDaemon via:

```sudo launchctl load ~/Library/LaunchAgents/com.xprotectwatch.XProtect.plist```

Debug
-----
You can enable debug mode by changing the value of the following line on watchProtect.sh
```debug_log="disabled"							#	Change to "enable" to start debug logs```

RollBack
--------
### rollBack.sh ###
THIS IS A HACK SCRIPT!  I just created this to help me test terminal-notifier to force a new update by copping the old data and removing some archives.  Not a true management solution.

terminal-notifier
-----------------
If you want to be notified of updates via Notification Center, I've enabled some small validation items to utilize [terminal-notifier][terminal-notifier].  You can run the terminal-notifier.sh script from this repo which will download, verify md5 hash, unzip, and install to your /Applications folder.

![Terminal Notifier Example](http://f.cl.ly/items/0U2X3o2U1F0i2g172l1Y/XProtectWatch-Notification.png "Terminal Notifier Example") 

[terminal-notifier]: https://github.com/alloy/terminal-notifier