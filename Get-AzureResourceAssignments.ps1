[CmdletBinding()]
param (
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    $FolderPath = "$env:USERPROFILE\Downloads",

    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    $FileName = "$(Get-Date -f 'yyyy-MM-dd')-AzureResourceAssignments.csv"
) 

function Get-ScopeIdentifiers {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string] $Scope
    )

    <#
        .SYNOPSIS
        Formats the scope string into the proper identifiers
    #>

    $Scope_Split = $Scope.Split("/")

    # If the role assignmnet is for a management group
    if ($scope_Split[3] -eq "managementGroups") {
        $managementGroup = $scope_Split[4]
    }

    # If the role assignment is for a resource group
    elseif ($scope_Split[3] -eq "resourceGroups") {
        $resourceGroup = $scope_Split[4]

        # If the role assignment is for a resource
        if ($scope_Split[5] -eq "providers") {        
            $providerName = $scope_Split[6]
            $resourceType = $scope_Split[7]
            $resourceName = $scope_Split[-1]
                
            # If the role assignmnet resource type has a subtype(s)
            if ($scope_Split.Count -ge 10) {
                $resourceSubType = ($scope_Split[ 8..($scope_Split.Count - 2) ] ) -Join ("/")
            }
        }
    }

    return $managementGroup, $resourceGroup, $providerName, $resourceType, $resourceSubType, $resourceName
}

# Connect to Azure PowerShell
Connect-AzAccount

# Add all available subscriptions into the current context
Get-AzSubscription | Set-AzContext

# Get the subscription names and IDs now in the current context
$azSubscriptions = Get-AzSubscription

$output = foreach ($sub in $azSubscriptions) {

    # Get all role assignments for the subscription
    $azRoles = Get-AzRoleAssignment -Scope "/subscriptions/$($sub.Id)"

    foreach ($role in $azRoles) {

        $managementGroup, $resourceGroup, $providerName, $resourceType, $resourceSubType, $resourceName = Get-ScopeIdentifiers -Scope $role.Scope

        [PSCustomObject] @{
            ManagementGroup      = $managementGroup
            Subscription         = $sub.Name
            SubscriptionId       = $sub.Id
           # RoleAssignmentId    = $role.RoleAssignmentId
           # Scope               = $role.Scope
            ResourceGroup        = $resourceGroup
            ProviderName         = $providerName
            ResourceType         = $resourceType
            ResourceSubType      = $resourceSubType
            ResourceName         = $resourceName
            PrincipalName        = $role.DisplayName
            UserPrincipalName    = $role.SignInName
            PrincipalType        = $role.ObjectType
            PrincipalId          = $role.ObjectId
            RoleDefinitionName   = $role.RoleDefinitionName
            RoleDefinitionId     = $role.RoleDefinitionId
            Description          = $role.Description
        }
    }
}

# Export the results as a CSV file
$filePath = Join-Path $FolderPath -ChildPath $FileName

try
{
    $output | Sort-Object ManagementGroup | Export-CSV -NoTypeInformation -Path $filePath
    Write-Host "Export to $filePath succeeded" -ForegroundColor Cyan
}
catch
{
    Write-Error "Export to $filePath failed | $_ "
}
