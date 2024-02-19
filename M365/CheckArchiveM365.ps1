#Check mailbox size and run archive (+troubleshooting)
Connect-ExchangeOnline

#Mailbox size status
Get-MailboxFolderStatistics "example_user@example.com" | Select Name, FolderAndSubfolderSize ,ItemsInFolderAndSubfolders
Get-MailboxFolderStatistics "example_user@example.com" | Select Name,FolderSize,ItemsinFolder

#Retention Policy check
Get-Mailbox "example_user@example.com" | FL RetentionPolicy

#Start archive with new policy and check status.
Start-ManagedFolderAssistant -Identity "example_user@example.com"
Get-Mailbox -Identity "example_user@example.com"  | Select ArchiveStatus, ArchiveDatabase

# If archive not start, check RetentionHold is enabled. If status is true set it to false.
Get-Mailbox "example_user@example.com" | Select RetentionHoldEnabled
Set-Mailbox  "example_user@example.com" -RetentionHoldEnabled $false

#If archive don't have free space set auto expand for it.
Get-Mailbox "example_user@example.com" | FL AutoExpandingArchiveEnabled
Enable-Mailbox "example_user@example.com" -AutoExpandingArchive
