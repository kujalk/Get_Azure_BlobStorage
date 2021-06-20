<#
Purpose - To collect blob name and blod last modified time across all storage account in all subscriptions
Date - 20/6/2021
Developer - K.Janarthanan
#>

try 
{
    Write-Host "Started the script`n" -ForegroundColor Green

    Import-Module -Name Az.Accounts -ErrorAction Stop
    Import-Module -Name Az.Resources -ErrorAction Stop
    Import-Module -Name Az.Storage -ErrorAction Stop

    Connect-AzAccount

    $All_Objects = @()
    $All_Subscriptions = Get-AzSubscription -EA Stop

    foreach($Sub in $All_Subscriptions)
    {
        Write-Host "Working on Subscription - $($Sub.Name)" -ForegroundColor Magenta
        Select-AzSubscription -SubscriptionName $Sub.Name -EA Stop | Out-Null

        $All_Storage = Get-AzStorageAccount -EA Stop

        if($All_Storage.Count -gt 0)
        {
            foreach($SA in $All_Storage)
            {
                $Context = (Get-AzStorageAccount -AccountName $SA.StorageAccountName -ResourceGroupName $SA.ResourceGroupName -EA Stop).context
                
                $Containers = Get-AzStorageContainer -Context $Context -EA Stop

                if($Containers.Count -gt 0)
                {
                    foreach($Container in $Containers)
                    {
                        $Allfiles = Get-AzStorageBlob -Container $Container.Name -Context $Context

                        if($Allfiles.Count -gt 0)
                        {
                            foreach($File in $Allfiles)
                            {
                                Write-Host "File found and it is - $($File.Name)" -ForegroundColor Green
                                $File_Object = New-Object psobject
                                $File_Object | Add-Member -membertype noteproperty -name Subscription -value $Sub.Name
                                $File_Object | Add-Member -membertype noteproperty -name ResourceGroup -value $SA.ResourceGroupName
                                $File_Object | Add-Member -membertype noteproperty -name StorageAccount -value $SA.StorageAccountName
                                $File_Object | Add-Member -membertype noteproperty -name Region -value $SA.PrimaryLocation
                                $File_Object | Add-Member -membertype noteproperty -name Container -value $Container.Name
                                $File_Object | Add-Member -membertype noteproperty -name BlobStorage -value $File.Name
                                $File_Object | Add-Member -membertype noteproperty -name LastModifiedTime -value $File.LastModified

                                $All_Objects += $File_Object
                            }
                        }
                        else 
                        {
                            Write-Host "No any files found in the container $($Container.Name) inside the storage account $($SA.StorageAccountName) in resource group $($SA.ResourceGroupName)" -ForegroundColor Yellow  
                        }
                    }
                }
                else 
                {
                    Write-Host "No any Storage container found inside the storage account $($SA.StorageAccountName) in resource group $($SA.ResourceGroupName)" -ForegroundColor Yellow  
                }              
            }      
        }
        else 
        {
            Write-Host "Subscription $($Sub.Name) does not have Storage Account" -ForegroundColor Yellow 
        }
    }

    if($All_Objects.Count -gt 0)
    {
        $All_Objects | Export-Csv -NoTypeInformation -Path "All_Blobs.csv"
        Write-Host "`nCreated the CSV"
    }
}
catch 
{
    Write-Host "Error - $_" -ForegroundColor Red
}