# Get-AzureResourceAssignments
PowerShell script to get all Azure role assignments for all Azure resources

## Description

This script uses the **Az** PowerShell module to get all the Azure role assignments for all Azure resources across all available subscriptions.

Results are exported as a CSV file to the location determined in the script parameters.

## Example Output

| ManagementGroup | Subscription | SubscriptionId | ResourceGroup | ProviderName | ResourceType | ResourceSubType | ResourceName | PrincipalName | UserPrincipalName | PrincipalType | PrincipalId | RoleDefinitionName | RoleDefinitionId | Description |
| - | - | - | - | - | - | - | - | - | - | - | - | - | - | - |
| MgmtGroup01 | Production | b8758966-cdec-4a61-b470-16cb20f3ae3a | - | - | - | - | - | Group01 | - | Group | d912c52d-f0a6-49e9-b333-80eb8821dd32 | Reader | acdd72a7-3385-48ef-bd42-f606fba81ae7 | - |
| MgmtGroup01 | Non-Production | 630bfc91-c5cb-48df-bc05-a7501698c577 | - | - | - | - | - | Group01 | - | Group | d912c52d-f0a6-49e9-b333-80eb8821dd32 | Reader | acdd72a7-3385-48ef-bd42-f606fba81ae7 | - |
| - | Production | b8758966-cdec-4a61-b470-16cb20f3ae3a | - | - | - | - | - | John Smith | John.Smith@corp.com | User | 8b5e71c6-96e7-4fe2-939d-5403edbe9947 | Reader | acdd72a7-3385-48ef-bd42-f606fba81ae7 | - |
| - | Production | b8758966-cdec-4a61-b470-16cb20f3ae3a | rg-app01-prod-01 | - | - | - | - | func-app01-prod-01 | | ServicePrincipal | 18d54fc7-8a3e-4975-b34a-1bc81d6c2e1b | Reader | acdd72a7-3385-48ef-bd42-f606fba81ae7 | - |
| - | Non-Production | 630bfc91-c5cb-48df-bc05-a7501698c577 | rg-app01-nonprod-01 | Microsoft.Compute | virtualMachines | - | vm-app01-nonprod-01 | Jane Smith | Jane.Smith@corp.com | User | 61f7381f-4064-439a-9131-6088f1ed0a5e | Owner | 8e3af657-a8ff-443c-a75c-2fe8c4bcb635 | - |
| - | Non-Production | 630bfc91-c5cb-48df-bc05-a7501698c577 | rg-app01-nonprod-01 | Microsoft.Network | virtualNetworks | vnet-nonprod-01 | vm-app01-nonprod-01 | Group02 | - | Group | 25f88df0-1e76-4c1b-962c-f8663234ebb5 | Network Contributor | 4d97b98b-1d4f-4787-a291-c67834d212e7 | - |
