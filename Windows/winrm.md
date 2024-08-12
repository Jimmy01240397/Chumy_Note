# winrm

## get winrm config
``` batch
winrm get winrm/config
```

## remote server

### setup
``` batch
winrm quickconfig
```
or
``` powershell
Enable-PSRemoting -Force
```

### firewall
wf.msc => tcp 5985(http),5986(https)

## client

### set trust server
``` batch
winrm s winrm/config/client @{TrustedHosts="<server host>"}
```

### set auth
``` batch
winrs -r:NSC-HQ-WS -u:Administrator -p:Skills39 cmd
```
``` powershell
Enter-PSSession -ComputerName NSC-HQ-WS -Credential admin
```
