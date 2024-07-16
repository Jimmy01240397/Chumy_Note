# New ADUser

`New-ADUser -Name IT01 -AccountPassword (ConvertTo-SecureString -String Skills39 -AsPlainText -Force) -DisplayName IT01 -Path "CN=Users,DC=kazan,DC=ru" -Enabled $true -PasswordNeverExpires $true`
