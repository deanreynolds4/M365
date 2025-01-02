<#
    .SYNOPSIS
        Creates 50 test users in M365 and provisions 10 test channels in a single Microsoft Team.

    .DESCRIPTION
        This script will:
        1. Create 50 test user accounts in Azure AD (Microsoft 365).
        2. Create a new Team (named “TestTeam”) in Microsoft Teams.
        3. Create 10 channels within that newly created team.

    .NOTES
        - Ensure you have installed and imported the necessary modules:
            Install-Module AzureAD
            Install-Module MicrosoftTeams
        - Run Connect-AzureAD and Connect-MicrosoftTeams before executing this script.
        - Update variables (like domain, password, UsageLocation, etc.) before running in production.
#>

# ------------------ Configuration Variables ------------------
$domainName      = "<YourTenant>.onmicrosoft.com"
$passwordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
$passwordProfile.Password = "P@ssw0rd!"  # Update with a secure password
$usageLocation   = "US"                # Update to your two-letter country code
$displayNameBase = "TestUser"
$userNameBase    = "TestUser"
$testTeamName    = "TestTeam"
$testTeamDesc    = "A team for testing bulk channel creation"

# ------------------ 1. Create 50 Test Users ------------------
Write-Host "Creating 50 test users in Microsoft 365..."

For ($i = 1; $i -le 50; $i++) {
    $userPrincipalName = "$($userNameBase)$i@$domainName"
    $displayName       = "$($displayNameBase)$i"
    
    # Create the user in Azure AD
    New-AzureADUser -DisplayName $displayName `
                    -PasswordProfile $passwordProfile `
                    -UserPrincipalName $userPrincipalName `
                    -AccountEnabled $true `
                    -MailNickName $displayName `
                    -UsageLocation $usageLocation
    
    Write-Host "Created user: $displayName ($userPrincipalName)"
}

Write-Host "`nSuccessfully created 50 test users."

# ------------------ 2. Create a Test Team --------------------
Write-Host "`nCreating the test team..."

# Create a new Team
$newTeam = New-Team -DisplayName $testTeamName -Description $testTeamDesc -Visibility Private
Write-Host "Created Team: $($newTeam.DisplayName) with GroupId: $($newTeam.GroupId)"

# ------------------ 3. Create 10 Test Channels ----------------
Write-Host "`nCreating 10 channels in the test team..."

For ($i = 1; $i -le 10; $i++) {
    $channelName = "TestChannel$i"
    New-TeamChannel -GroupId $newTeam.GroupId -DisplayName $channelName
    Write-Host "Created channel: $channelName"
}

Write-Host "`nScript complete. 50 users and 10 channels have been created."
