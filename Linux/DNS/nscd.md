# nscd

check cache

```bash
strings /var/cache/nscd/hosts
sudo nscd -g
```

flush cache

```bash
nscd -i hosts
```
