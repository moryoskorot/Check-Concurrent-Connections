# Check concurrent connection script V1
# Written by Mor Yosef 

# Receives:
# - A domain name (not full URL), make sure you get all subdomains and not use just the top two.
# - Path/file to write the logs to

# The log will consist of the number of port 443 established connections to addresses which sit behind the specified domain, and the time it was logged.
# You can sort by the amount of concurrent column both to see highest amount but also see the busiest time of day.

# TODO:
# - Turn this into a function 
# - Create a wrapper script which gets both these two parameters but also how frequently and for how long to run this test.
# - Create seperate script to work by list of IP addresses, have option to choose between dns name or ip addresses list in the wrapper.


# Manually provie the Domain you want to check your connections to, and the path/file you want to write your logs to.
$targetdomain="example.domain.com"
$logfile="logfile.csv"

# Get a list of possible addresses using nslookup(ps equivilant) for the target domain
$Addresses=(Resolve-DnsName  $targetdomain -erroraction 'silentlycontinue').ipaddress

# If addresses were found for the target domain name -
if( $Addresses.Count -ge 1){
# Write into the logfile the amount of records found by the get-netTcpConnection and the date, the state column was chosen since its 100% to have a value, and we used count to get the number of connections established
write-output "$(((Get-NetTCPConnection  -RemotePort 443 -State Established  -RemoteAddress $Addresses -erroraction 'silentlycontinue').state).count), $(date)" >> $logfile
}

# If no addresses were found for the target domain name
else{ 
# Output to the log file that internet connection might be missing or the dns record is flawed
write-output "ERROR No Addresses were found for that dns name- Check network connectivity and DNS records, $(date)" >> $logfile
}

 
