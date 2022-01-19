## 導入 GPG
``` bash
curl -s https://deb.frrouting.org/frr/keys.asc | sudo apt-key add -
```
## 寫入軟體源
``` bash
echo "deb https://deb.frrouting.org/frr bullseye frr-stable" >> /etc/apt/sources.list.d/frr.list
```
## 安裝 FRRouting
``` bash
sudo apt update -y && sudo apt install -y frr frr-pythontools
```
## 啟動 FRRouting 所有功能
``` bash
sudo sed -i "s/=no/=yes/g" /etc/frr/daemons
```
