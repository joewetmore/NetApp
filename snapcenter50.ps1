https://library.netapp.com/ecm/ecm_download_file/ECMLP2886895

Open-SmStorageConnection 
Add-SmStorageConnection -Storage test_vs1 -Protocol Https -Timeout 60 

New-SdLun [-StorageSystem] <String> [-LunPath] <String> [-Size] <String> [[-Type] <String>] [-Session <String>] [-Host <String>] [<CommonParameters>] 

New-SdStorage [-Path <String>] -Size <String> -LunPath <String> -StorageSystem <String> [-FileSystemLabel <String>] [-SharedDisk] [-ClusteredSharedVolume] 
[-Igroup <String>] [-InitiatorInfo <HostInitiatorInfo>] [-PortSet <String>] [-AutopickMountPoint] [PartitionStyle <PartitionStyle>] [-ResourceGroup <String>] 
[-Thin] [-AllocationUnitSize <String>] [-RawDeviceMapping] [-Datastore <String>] [-Session <String>] [-Host <String>] [<CommonParameters>] 

Get-SdStorage [-StorageSystem <String[]>] [-ComputerName <String>] [ExcludeStorageFootprint] [-ExcludeSMB] [-ExcludeSAN] [-GetMirrorInfo] 
[GetUnmanagedDisks] [-CloneLevel] [-Session <String>] [-Host <String>] [<CommonParameters>] Get-SdStorage [-Path <Object[]>] [-ComputerName <String>] [
-ExcludeStorageFootprint] [ExcludeSMB] [-ExcludeSAN] [-GetUnmanagedDisks] [-CloneLevel] [-Session <String>] [-Host <String>] [<CommonParameters>] 


