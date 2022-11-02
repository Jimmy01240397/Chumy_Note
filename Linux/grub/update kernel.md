# 安裝Kernel：
## 搜尋(檢查)想要安裝的kernel版本是否存在
``` bash
$ sudo apt-cache search linux-image-*
```
或者填入版本號搜尋，將X.X.XX填入版本號
``` bash
$ sudo apt-cache search linux-image-X.X.XX-generic
```
## 開始安裝kernel
``` bash
$ sudo apt-get install linux-image-X.X.XX-generic
```
如果有其他需求，像是編譯模組，可以連headers都裝上
``` bash
$ sudo apt-get install linux-headers-X.X.XX-generic
```    
## 安裝後,更新initramfs image，詳細man update-initramfs
``` bash
$ sudo update-initramfs -u -k all
```
或者使用
``` bash
$ sudo update-initramfs -u -k `uname -r`
```
## 接著更新grub清單
``` bash
$ sudo update-grub
```
## 重開機
``` bash
$ sudo reboot   #按ESC鍵進入GRUB選單,選擇安裝的Kernel開機
```

# 移除Kernel：
## 檢查目前正在用哪個kernel
``` bash
$ uname -a
```
## 或者列出目前系統中已安裝哪些kernel
``` bash
$ dpkg --get-selections | grep linux-image
```
## 移除不要的Kernel，會自動將相關版本的 linux-image-extra-* 也一併移除
``` bash
$ sudo apt-get purge linux-image-X.X.XX-XX-generic
```
