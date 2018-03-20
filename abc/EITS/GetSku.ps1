

Import-AzureRmContext -Path "c:\temp\azureprofile.json"
Get-AzureRmSubscription
Select-AzureRmSubscription -SubscriptionName "Provider Solutions Development"

#( Get-AzureVMImage | where-object { $_.Label -like "SQL Server 2017 Enterprise Windows Server 2016*" } ) 

$loc = 'eastus2' 

Get-AzureRmVMImagePublisher -Location $loc #check all the publishers available
Get-AzureRmVMImageOffer -Location $loc -PublisherName "MicrosoftSQLServer" #look for offers for a publisher
Get-AzureRmVMImageSku -Location $loc -PublisherName "MicrosoftSQLServer" -Offer "SQL2017-WS2016" #view SKUs for an offer
Get-AzureRmVMImage -Location $loc -PublisherName "MicrosoftSQLServer" -Offer "SQL2017-WS2016" -Skus "Enterprise" #pick one!
