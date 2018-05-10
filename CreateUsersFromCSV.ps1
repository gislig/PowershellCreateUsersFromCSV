#Import the values for the users
$UserValues = Import-Csv -Path c:\UserCreation\Users.csv -Delimiter ";"#Create the user function so I will not repeat myselffunctioncreateUsers($FirstName, $LastName, $Password, $Department){
    #The path for the user to be placed, in this scenario I put them in a department OU and Users
    $OUPath = "OU=Users,OU=$Department,OU=Departments,DC=TSTDOMAIN,DC=COM"

    #Convert the password to securestring
    $AccountPassword = (ConvertTo-SecureString -AsPlainText $Password -Force)

    #Create the Displayname, samaccountname, userprincipal name
    $DisplayName =  $FirstName+" "+$LastName
    $SamAccountName = $FirstName+"."+$LastName
    $UserPrincipalName = $SamAccountName+"@tstdomain.com"

    #Create the profile and home directory based
    $ProfilePath = "\\tstdomain.com\Users\$Department\$SamAccount\Profile"
    $HomeDirectory = "\\tstdomain.com\Users\$Department\$SamAccount\Home"

    #Set the HomeDrive letter
    $HomeDrive = "H:"

    #Try to create the user
    try{
        New-ADUser -Surname $Name -GivenName $Name -DisplayName $DisplayName -SamAccountName $SamAccount -Name $DisplayName -AccountPassword $AccountPassword -Path $OU -Enabled $true -UserPrincipalName $UserPrincipalName -ProfilePath $ProfilePath -HomeDirectory $HomeDirectory -Department $Department -HomeDrive $HomeDrive
    }catch{
        #If there is an error, capture it and display the error
        $ErrorMessage = $_.Exception.Message
        Write-Host $ErrorMessage -ForegroundColor Red
    }
}

#Notice that I use single instead of plural variable in the foreachforeach($UserValue in $UserValues){
    #call the createUsers function to create the user
    createUsers -FirstName $UserValue.FirstName -LastName $UserValue.LastName -Password $UserValue.Password -Department $UserValue.Department
}