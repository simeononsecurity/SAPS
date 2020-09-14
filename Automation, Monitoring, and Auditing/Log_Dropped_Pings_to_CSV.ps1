##Pings IPs and Logs Errors to CSV File. 
#https://github.com/simeononsecurity/SAPS
#Major thanks to Lee_Dailey for assiting in the development of this script

# save the current InformationPreference
$Old_I_Pref = $InformationPreference
# enable Information output
$InformationPreference = 'Continue'


$GatewayList = @"
127.0.0.1
192.168.1.1
1.1.1.1
$env:COMPUTERNAME
"@ -split [environment]::NewLine

## Set Environment Variables ##
$computername = "$env:computername"
$timestamp = "$(((get-date).ToUniversalTime()).ToString("yyyyMMddTHHmmssZ"))"
$scriptname = "Log_Dropped_Pings_to_CSV"
$file = "$scriptname-$computername-$timestamp.csv"
$outputpath = "C:\temp\Scripts\$scriptname"
$csvoutfile = "$path\$file"
$TestIntervalSeconds = 15
$TestDurationMinutes = 2
$EndTestTime = [datetime]::Now.AddMinutes($TestDurationMinutes)

## Creates Output Folder Structure if it Doesn't Exist ##
If(!(test-path $outputpath))
{
      New-Item -ItemType Directory -Force -Path $outputpath
}

while ([datetime]::Now -le $EndTestTime)
    {
    $Results = foreach ($GL_Item in $GatewayList)
        {
        $Response = Test-Connection -ComputerName $GL_Item -Count 1 -Quiet
        $TempObject = [PSCustomObject]@{
            Gateway = $GL_Item
            Reachable = $Response
            TimeStamp = [datetime]::Now.ToString('yyyy-MM-dd HH:mm:ss')
            }

        if ($TempObject.Reachable)
            {
            Write-Information ('{0} is reachable at this time.' -f $TempObject.Gateway)
            # if you want to also send success to the CSV, uncomment the next line
            #$TempObject
            }
            else
            {
            Write-Warning ('    Unable to reach {0}' -f $TempObject.Gateway)
            # send the object to the current result set for saving to a CSV
            $TempObject
            }
        } # end >> $Results = foreach ($GL_Item in $GatewayList)

    if ([datetime]::Now -le $EndTestTime)
        {
        Write-Information ''
        Write-Information ('    Minutes remaining = {0,8}' -f [math]::Round(($EndTestTime - [datetime]::Now).TotalMinutes, 3))
        Write-Information ('    Waiting {0} seconds between test cycles ...' -f $TestIntervalSeconds)
        Write-Information ''
        Start-Sleep -Seconds $TestIntervalSeconds
        }
        
    # send to CSV
    $Results |
        Export-Csv -LiteralPath $csvoutfile -NoTypeInformation -Append
    } # end >> while ([datetime]::Now -le $EndTestTime)

# restore the old InformationPreference
$InformationPreference = $Old_I_Pref
