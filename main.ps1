# Set where you want your logs to be moved to.
#$destinationpath = "C:\WindowsEventLogs\"
$destinationpath = "C:\temp\"

# Event logs to roll
$logArray = @("Application","System","Security")

# hostname- used in naming the logs
$servername = $env:computername

# making sure $destination path is a directory, not a file 
if ($destinationpath -notmatch '.+?\\$')
{
    $destinationpath += '\'
}

# #makes sure the destination path is real
if (!(Test-Path -Path $destinationpath))
{
    New-Item -ItemType directory -Path $destinationpath
}

# get the time for the resulting log file
$logdate = Get-Date -format yyyyMMddHHmm


# Start Code
Clear-Host

Foreach($log in $logArray)
{
    # backs up each log requested
    $destination = $destinationpath + $servername + "-" + $log + "-" + $logdate + ".evtx"
    Write-Host "Copying the $log file now."

    wevtutil epl $log $destination

    #running this script manually, and want to review the logs?
    #uncomment this next line to get the results in gridview
    #they are MUCH easier to read here than in event viewer

    #Get-WinEvent -Path $destination | Out-GridView -Title $log



#running the script as a scheduled task?
#uncomment the next two lines to clear each log after they've been copied.
  #  Write-Host "Clearing the $log file now."

    # Clear the log and backup to file.
  #  WevtUtil cl $log

} 
exit