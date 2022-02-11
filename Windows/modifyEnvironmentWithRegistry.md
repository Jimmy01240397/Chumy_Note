modify user Environment:
```
HKEY_CURRENT_USER\Environment
```

modify system Environment:
```
HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment
```

run win32 script:
``` c
#include<windows.h>
int main()
{
    SendMessage(HWND_BROADCAST,WM_SETTINGCHANGE,0,(LPARAM)TEXT("Environment"));
}

```
