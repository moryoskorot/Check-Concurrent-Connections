 # Check concurrent connection script V1.1
# Written by Mor Yosef 

# Receives:
# - A domain name (not full URL), make sure you get all subdomains and not use just the top two.
# - Path/file to write the logs to

# The log will consist of the number of port 443 established connections to addresses which sit behind the specified domain, and the time it was logged.
# You can sort by the amount of concurrent column both to see highest amount but also see the busiest time of day.

# TODO:
# - Create seperate script to work by list of IP addresses, have option to choose between dns name or ip addresses list in the wrapper.


function Get-ConcurrentConnections{
# Get the Target Domain and the LogfilePath
    param (        [string]$TargetDomain ,        [string]$LogfilePath    )
    
    # Get a list of possible addresses using nslookup(ps equivilant) for the target domain
    $Addresses=(Resolve-DnsName  $TargetDomain -erroraction 'silentlycontinue').ipaddress

    # If addresses were found for the target domain name -
    if( $Addresses.Count -ge 1){
    # Write into the logfile the amount of records found by the get-netTcpConnection and the date, the state column was chosen since its 100% to have a value, and we used count to get the number of connections established
    write-output "$(((Get-NetTCPConnection  -RemotePort 443 -State Established  -RemoteAddress $Addresses -erroraction 'silentlycontinue').state).count), $(date)" >> $LogfilePath
    continue
    }

    # If no addresses were found for the target domain name
    else{ 
    # Output to the log file that internet connection might be missing or the dns record is flawed
    write-output "ERROR No Addresses were found for that dns name - Check The TargetDomain, Network-Connectivity and DNS records, $(date)" >> $LogfilePath
    return "ERROR"
    }

}


function Get-ConcurrentConnections-Loop{
# Get the Target Domain and the LogfilePath
    param (        [string]$TargetDomain ,        [string]$LogfilePath   , [int]$MinutesToRun, [int]$IntervalInSeconds )
    
    # This function receives a targt domain, log location, minutes to run , and interval in seconds

    #Calculate the finish time
    [datetime]$finish_time=(Get-Date).AddMinutes($MinutesToRun)

    While([datetime](Get-Date) -lt $finish_time)
    {
        # Get current connections and put them them in a file using our function
        Get-ConcurrentConnections -TargetDomain domain.com -LogfilePath logfile.csv 
        # Wait for the set amount of time
        Start-Sleep -Seconds $IntervalInSeconds

    }
}


Get-ConcurrentConnections-Loop -TargetDomain domain.com -LogfilePath logfile.csv -MinutesToRun 1 -IntervalInSeconds 10

 
