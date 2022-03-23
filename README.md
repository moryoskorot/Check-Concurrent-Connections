# Check-Concurrent-Connections
Check https concurrent connections to a specific domain name

From the 2nd answer here by JoeG
https://stackoverflow.com/questions/6016436/in-powershell-how-do-i-define-a-function-in-a-file-and-call-it-from-the-powersh

So first, rename the .ps1 file that has all your functions in it to MyFunctions.psm1 (you've just created a module!). Now for a module to load properly, you have to do some specific things with the file. First for Import-Module to see the module (you use this cmdlet to load the module into the shell), it has to be in a specific location. The default path to the modules folder is $home\Documents\WindowsPowerShell\Modules.

In that folder, create a folder named MyFunctions, and place the MyFunctions.psm1 file into it (the module file must reside in a folder with exactly the same name as the PSM1 file).

Once that is done, open PowerShell, and run this command:

Get-Module -listavailable
If you see one called MyFunctions, you did it right, and your module is ready to be loaded (this is just to ensure that this is set up right, you only have to do this once).

To use the module, type the following in the shell (or put this line in your $profile, or put this as the first line in a script):

Import-Module MyFunctions
You can now run your functions. The cool thing about this is that once you have 10-15 functions in there, you're going to forget the name of a couple. If you have them in a module, you can run the following command to get a list of all the functions in your module:

Get-Command -module MyFunctions
It's pretty sweet, and the tiny bit of effort that it takes to set up on the front side is WAY worth it.
