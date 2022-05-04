#Create Log-----------------------------------------------------------------------------------
New-Item -ItemType "directory" $HOME"\Documents\Dylanlogs" -ErrorAction SilentlyContinue 
New-Item -ItemType "file" $HOME"\Documents\Dylanlogs\log.txt" -ErrorAction SilentlyContinue
#---------------------------------------------------------------------------------------------


#Variables------------------------------------------------------------------------------------
$LogFile = $HOME + "\Documents\Dylanlogs\log.txt"
$Version = "1.4"
#---------------------------------------------------------------------------------------------

#Functions------------------------------------------------------------------------------------
  function StartCode{

    Clear-Host
    "    ____        __                    ____                          _____ __         ____   _____           _       __ 
   / __ \__  __/ /___ _____  _____   / __ \____ _      _____  _____/ ___// /_  ___  / / /  / ___/__________(_)___  / /_
  / / / / / / / / __ `/ __ \/ ___/  / /_/ / __ \ | /| / / _ \/ ___/\__ \/ __ \/ _ \/ / /   \__ \/ ___/ ___/ / __ \/ __/
 / /_/ / /_/ / / /_/ / / / (__  )  / ____/ /_/ / |/ |/ /  __/ /   ___/ / / / /  __/ / /   ___/ / /__/ /  / / /_/ / /_  
/_____/\__, /_/\__,_/_/ /_/____/  /_/    \____/|__/|__/\___/_/   /____/_/ /_/\___/_/_/   /____/\___/_/  /_/ .___/\__/  
      /____/                                                                                             /_/           "

      ""
      "Version: $Version"
    ""
        "1) Delete temp files" 
        "2) Check for suspicious Services [BETA]"
        "3) Some general infos about your PC"
        "4) Configure Start-up folder"
    ""
    
    "If you don't enter 1, 2, 3 or 4 the script will close itself"
    ""
   
    $MenuSelection = Read-Host "Enter 1,2,3,4 or 5"

    switch -Wildcard($MenuSelection) {

        '*Error*'
        {
            Write-Error "Oops that should'nt be happen"
            Add-Content -Path $LogFile -Value "Error in switch function"
            StartCode 
        } 

        1 { 
            Add-Content -Path $LogFile -Value "$(Get-Date) Deleting \Windows\Temp\ Content..."
            Remove-Item $windir'\Windows\Temp\*' -Recurse -ErrorAction SilentlyContinue 
            Add-Content -Path $LogFile -Value "$(Get-Date) Finished Deleting \Windows\Temp\ Content"


            Add-Content -Path $LogFile -Value "$(Get-Date) Deleting \AppData\Local\Temp\ Content..."
            Remove-Item $HOME'\AppData\Local\Temp\*' -Recurse -ErrorAction SilentlyContinue
            Add-Content -Path $LogFile -Value "$(Get-Date) Finished Deleting \AppData\Local\Temp\ Content"
    
            ""
            "This files cannot be removed:"
            Get-ChildItem $windir'\Windows\Temp\*'
            Get-ChildItem $HOME'\AppData\Local\Temp\*'
            ""

            "Finished!"
            "" 

            Read-Host "Press Enter to continue"
            StartCode
        } 
        2 { 
            Add-Content -Path $LogFile -Value "$(Get-Date) Checking for suspicious services..."
            $Test = Get-Service | Where-Object {$_.Status -eq "Running"} | Select-Object -Property "Name" | Select-String -pattern "*emote*" 
           
            If ($Test -ne $null)
            {
                "Warning $Test is suspicious"
                Add-Content -Path $LogFile -Value "$(Get-Date) $Test is suspicious"
            }
            Else
            {
                "Nice, no suspicious services have been found!"
                Add-Content -Path $LogFile -Value "$(Get-Date) Suspicious Service check result: 0"
            }
          
            Read-Host "Press Enter to continue"
            StartCode
        }
        3 { 
            Add-Content -Path $LogFile -Value "$(Get-Date) Showing up some general information..."
            "Loading..."
            Get-ComputerInfo 
            ""
            Add-Content -Path $LogFile -Value "$(Get-Date) Finished showing up some general information"
            ""
            Read-Host "Press Enter to continue"
            StartCode
        }
        4 { 
            Add-Content -Path $LogFile -Value "$(Get-Date) Adding files via prompt..."
            $inputfile = Get-FileName $env:HOMEPATH
            try {
                Add-Content -Path $LogFile -Value "$(Get-Date) Copying $inputfile to the Startup folder..."
                ""
                "Copying..."
                ""
                Copy-Item $inputfile ("$HOME\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup")
                "Successfully copied files!"
            }
            catch{
                Add-Content -Path $LogFile -Value "$(Get-Date) An error occured during the process"
                ""
                "An error occured during the process, aborting..."
            }
            ""
            Get-ChildItem -Path "$HOME\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
            ""
            Read-Host "Press Enter to continue"
            StartCode
        }
        5{
            try{
                    Add-Content -Path $LogFile -Value "$(Get-Date) Disabling Cortana..."
                    Get-AppxPackage -allusers Microsoft.549981C3F5F10 | Remove-AppxPackage
                    Add-Content -Path $LogFile -Value "$(Get-Date) Fins"

            }
            catch{
            
            }
                Read-Host "Press Enter to continue"
                StartCode
        
        }
    }
 
}


  function finishCode{
    ""
    "Thanks for using my Script"
    ""
    "-----------------------------------------------"
    Read-Host "Press any key to close this window"
  }

Function Get-FileName($initialDirectory)
{
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.initialDirectory = $initialDirectory
    $OpenFileDialog.filter = "All files (*.*)|*.*"
    $OpenFileDialog.ShowDialog() | Out-Null
    $OpenFileDialog.filename
}
#---------------------------------------------------------------------------------------------


#Start ---------------------------------------------------------------------------------------
Clear-Host

#Set Window Setting
Add-Type -AssemblyName System.Windows.Forms
$host.ui.RawUI.WindowTitle = “Dylan's PowerShell Script”

"Welcome $env:UserName and welcome to Dylan's PowerShell Script Version $Version (25.03.2022)"

#Window Alert
$msgBoxInput =  [System.Windows.Forms.MessageBox]::Show('!WARNING! This script is still early access, bugs and failures may occur during the execution of the script, would you like to continue?','Dylans PowerShell Script WARNING','YesNoCancel','Error')

  switch  ($msgBoxInput) {

  'Yes' {
    Add-Content -Path $LogFile -Value "---------------------------------------------------------------------"
    Add-Content -Path $LogFile -Value "$(Get-Date) Starting Code..."
    
    StartCode


  }

  'No' {

    finishCode
  }

  'Cancel' {

  }
  
  }

