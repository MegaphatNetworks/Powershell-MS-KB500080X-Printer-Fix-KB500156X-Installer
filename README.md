### MS KB500080X Printer Fix KB500156X Installer
 Auto detect and patch MS KB500080X printer error

So it seems that Microsoft has issued an update to Windows 10 and of course, they done broke it!
We have customers with various printers from Brother, Canon, Kyocera and HP.  The hotfix is as follows:

# KB5000802 (Windows 10 version 2004/20H2)
# KB5000808 (Windows 10 version 1909)
# KB5000809 (Windows 10 version 1809)
# KB5000822 (Windows 10 version 1803).
# KB5000803 (Windows Server 2016/2019)

What this hotfix does, well in short it screws up your Type 3 printer drivers.  Type 3?  Yes!
A Type 3 printer driver is an OEM driver, or a driver published by the hardware manufacturer.
A Type 4 printer driver is a Microsoft driver pre-built by Microsoft.  Those still work fine.
However Type 3 drivers offer more features specific to your printer.  Now of course it's nice to have extra features.  
I mean, you DID pay for it, so wh did MS break it?  Because.  They can.  And they did!

So if you try to print and you get a screen like this:
https://www.windowslatest.com/wp-content/uploads/2021/03/Windows-10-Win32kfull-BSOD.jpg

Then you want to fix it of course.  They force the update on you but make the FIX a lesser known "optional" install.
So instead of banging your head against the wall trying to figure it all out, I made this script.  Originally it would uninstall the problematic hotfix and hide it to prevent your system from ever installing it again, but as I was finishing it, MS came out with the fix, so then I changed direction and made my script automate the fix install.

To use it, you click your START button, type in POWERSHELL but..  but...  right click on RUN-ME.bat and select Run As Administrator.
Once completed, it will restart your computer and everything should (should being the operative word) be fine.
If you are affected by this KB and my script fails to identify and patch the issue, please send me a screen shot of the script executing so I can determine the reason why your computer is misbehaving and we can whack it into being a good lil PC.

The actual downloaded patch files are:

KB5001567 2004
==============
http://www.catalog.update.microsoft.com/Search.aspx?q=kb5001567
W10-2004-x64
http://download.windowsupdate.com/d/msdownload/update/software/updt/2021/03/windows10.0-kb5001567-x64_e3c7e1cb6fa3857b5b0c8cf487e7e16213b1ea83.msu
W10-2004-x86
http://download.windowsupdate.com/d/msdownload/update/software/updt/2021/03/windows10.0-kb5001567-x86_bafeb1bea06a5f39976de3406d3e33fb3cc2c6fe.msu
Svr-2004-x64
http://download.windowsupdate.com/d/msdownload/update/software/updt/2021/03/windows10.0-kb5001567-x64_e3c7e1cb6fa3857b5b0c8cf487e7e16213b1ea83.msu

KB5001567 20H2
==============
W10-20H2-x64
http://download.windowsupdate.com/d/msdownload/update/software/updt/2021/03/windows10.0-kb5001567-x64_e3c7e1cb6fa3857b5b0c8cf487e7e16213b1ea83.msu
W10-20H2-x86
http://download.windowsupdate.com/d/msdownload/update/software/updt/2021/03/windows10.0-kb5001567-x86_bafeb1bea06a5f39976de3406d3e33fb3cc2c6fe.msu
Svr-20H2-x64
http://download.windowsupdate.com/d/msdownload/update/software/updt/2021/03/windows10.0-kb5001567-x64_e3c7e1cb6fa3857b5b0c8cf487e7e16213b1ea83.msu

KB5001566 1909
==============
http://www.catalog.update.microsoft.com/Search.aspx?q=kb5001566
W10-1909-x64
http://download.windowsupdate.com/d/msdownload/update/software/updt/2021/03/windows10.0-kb5001566-x64_b52b66b45562d5a620a6f1a5e903600693be1de0.msu
W10-1909-x86
http://download.windowsupdate.com/c/msdownload/update/software/updt/2021/03/windows10.0-kb5001566-x86_d0134617d527f736cb73e2073b4269642c68d4a4.msu
Svr-1909-x64
http://download.windowsupdate.com/d/msdownload/update/software/updt/2021/03/windows10.0-kb5001566-x64_b52b66b45562d5a620a6f1a5e903600693be1de0.msu

KB5001568 W10 1809
==============
http://www.catalog.update.microsoft.com/Search.aspx?q=kb5001568
Svr-1809-x64
http://download.windowsupdate.com/d/msdownload/update/software/updt/2021/03/windows10.0-kb5001568-x64_cbfb9504eda6bf177ad678c64b871a3e294514ce.msu
W10-1809-x64
http://download.windowsupdate.com/d/msdownload/update/software/updt/2021/03/windows10.0-kb5001568-x64_cbfb9504eda6bf177ad678c64b871a3e294514ce.msu
W10-1809-x86
http://download.windowsupdate.com/c/msdownload/update/software/updt/2021/03/windows10.0-kb5001568-x86_ac43cdb614bfc2b4692ab2503efddc041a5b0c02.msu

KB5001565 W10 1803
==============
http://www.catalog.update.microsoft.com/Search.aspx?q=kb5001565
W10-1803-x64
http://download.windowsupdate.com/d/msdownload/update/software/updt/2021/03/windows10.0-kb5001565-x64_18a2f1393a135d9c3338f35dedeaeba5a2b88b19.msu
W10-1803-x86
http://download.windowsupdate.com/d/msdownload/update/software/updt/2021/03/windows10.0-kb5001565-x86_f87e104677d8b32eda140b953205ac8bb8dda1eb.msu
