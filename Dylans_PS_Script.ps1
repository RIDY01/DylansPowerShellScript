#Create Log-----------------------------------------------------------------------------------
New-Item -ItemType "directory" $HOME"\Documents\Dylanlogs" -ErrorAction SilentlyContinue 
New-Item -ItemType "file" $HOME"\Documents\Dylanlogs\log.txt" -ErrorAction SilentlyContinue
#---------------------------------------------------------------------------------------------


#Variables------------------------------------------------------------------------------------
$LogFile = $HOME + "\Documents\Dylanlogs\log.txt"
$Version = "1.7"
$date = "21/06/2022"
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
        "2) Check for suspicious activities"
        "3) Some general infos about your PC"
        "4) Configure Start-up folder"
        "5) Remove Cortana"
        "6) Gaming tweaks"
    ""
    
    "If you don't enter a number the script will close itself"
    ""
   
    $MenuSelection = Read-Host "Enter a number"

    switch -Wildcard($MenuSelection) {

        '*Error*'
        {
            Write-Host -ForegroundColor Red "Fatal error: that should not happen, please report this bug to the developer"
            Add-Content -Path $LogFile -Value "Error in switch function"
            StartCode 
        } 

        1 { 
            ""
            "Deleting temp files..."
            Add-Content -Path $LogFile -Value "$(Get-Date) Deleting \Windows\Temp\ Content..."
            Remove-Item $windir'\Windows\Temp\*' -Recurse -ErrorAction SilentlyContinue 
            Add-Content -Path $LogFile -Value "$(Get-Date) Finished Deleting \Windows\Temp\ Content"


            Add-Content -Path $LogFile -Value "$(Get-Date) Deleting \AppData\Local\Temp\ Content..."
            Remove-Item $HOME'\AppData\Local\Temp\*' -Recurse -ErrorAction SilentlyContinue
            Add-Content -Path $LogFile -Value "$(Get-Date) Finished Deleting \AppData\Local\Temp\ Content"
    
            ""
            Write-Host -ForegroundColor Yellow "(!) This following files cannot be removed:"
            Get-ChildItem $windir'\Windows\Temp\*'
            Get-ChildItem $HOME'\AppData\Local\Temp\*'
            ""

            "Finished!"
            "" 

            Read-Host "Press Enter to continue"
            StartCode
        } 
        2 { 
            ""
            Add-Content -Path $LogFile -Value "$(Get-Date) Checking for suspicious services..."
            $Test = Get-Service | Where-Object {$_.Status -eq "Running"} | Select-Object -Property "Name" | Select-String -pattern "emote" 
           
            If ($Test -ne $null)
            {
                Write-Host -ForegroundColor Yellow "(!) $Test is suspicious, please check this service"
                Add-Content -Path $LogFile -Value "$(Get-Date) $Test is suspicious"
            }
            Else
            {
                Write-Host -ForegroundColor Green "(✓) No suspicious services have been found!"
                Add-Content -Path $LogFile -Value "$(Get-Date) Suspicious Service check result: 0"
            }
            ""
            "Query user:" 
            query user /server:$SERVER
            ""
            "netstat:" 
            netstat -b
         
            ""
            Read-Host "Press Enter to continue"
            StartCode
        }
        3 { 
            ""
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
            ""
            Add-Content -Path $LogFile -Value "$(Get-Date) Adding files via prompt..."
            $inputfile = Get-FileName $env:HOMEPATH
            try {
                Add-Content -Path $LogFile -Value "$(Get-Date) Copying $inputfile to the Startup folder..."
                ""
                "Copying..."
                ""
                Copy-Item $inputfile ("$HOME\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup")
                ""
                 Write-Host -ForegroundColor Green "(✓) Successfully copied files!"
                 ""
                 $a = Read-Host "Do you want to open the start-up folder? y/n"

                 if($a -eq "y" -or $a -eq "yes")
                 {
                        explorer 'C:\Users\DLIri\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup'
                 }

            }
            catch{
                Add-Content -Path $LogFile -Value "$(Get-Date) An error occured during the process"
                ""
                Write-Host -ForegroundColor Red "(-) An error occured during the process, aborting..."
            }
            ""
            Get-ChildItem -Path "$HOME\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
            ""
            Read-Host "Press Enter to continue"
            StartCode
        }
        5{
            ""
            Add-Content -Path $LogFile -Value "$(Get-Date) Disabling Cortana..."
            try{
                    Get-AppxPackage -allusers Microsoft.549981C3F5F10 | Remove-AppPackage
                    Add-Content -Path $LogFile -Value "$(Get-Date) Removed Cortana"
                    ""
                    Write-Host -ForegroundColor Green "(✓) successfully removed Cortana"

            }
            catch{
                    Add-Content -Path $LogFile -Value "$(Get-Date) Error: Cortana could not get removed. Aborting..."
                    Write-Host -ForegroundColor Red "(-) Cortana could not get removed. Aborting..."
            }
                ""
                Read-Host "Press Enter to continue"
                StartCode
        
        }
        6{
           ""
           Add-Content -Path $LogFile -Value "$(Get-Date) Applying Gaming tweaks..."
           try{
                ""
                Write-Host "Registry setting..."
                Add-Content -Path $LogFile -Value "$(Get-Date) Changing Alt Tab Settings in Registry..."
                New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer' -Name 'AltTabSettings' -Value '1' -Type DWORD –Force > $null
                Add-Content -Path $LogFile -Value "$(Get-Date) Successfully added Registry Key"
                ""
                Write-Host -ForegroundColor Green "(✓) Alt Tab setting changed!"


           }
           catch{
                ""
                Write-Host "Error applying gaming tweaks. Please run this script as administrator"
                Add-Content -Path $LogFile -Value "$(Get-Date) Error: Gaming Tweaks could not be applied. Aborting..."
               
           }

            ""
            Read-Host "Press Enter to continue"
            StartCode
            6
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

"Welcome $env:UserName and welcome to Dylan's PowerShell Script Version $Version ($date)"

if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {

    ""
    Write-Host -ForegroundColor Red "(-) You didn't run this script as administrator, some functions may not work and the script may crash." 
    ""
}

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
#---------------------------------------------------------------------------------------------

