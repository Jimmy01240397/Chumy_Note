# Set5GHz

[ref](https://tildearrow.org/?p=post&month=7&year=2022&item=lar)

1. Clone hostapd source

```
git clone https://w1.fi/hostap.git
git reset --hard hostap_2_10
```

2. Use build [config](.config)

3. Apply [patch](hostapd-2.10-lar.patch)

```
patch -p1 < hostapd-2.10-lar.patch
```

4. `make`

5. Use hostapd [config](wlan0.conf)


