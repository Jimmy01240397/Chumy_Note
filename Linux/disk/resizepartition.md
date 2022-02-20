# add
see [擴充VM硬碟與系統分割區容量](擴充VM硬碟與系統分割區容量.txt)
``` bash
resize2fs /dev/sda
```

# reduce 
100G -> 90G
``` bash
resize2fs /dev/sda 89G
```
set partition size 90G see [擴充VM硬碟與系統分割區容量](擴充VM硬碟與系統分割區容量.txt)
``` bash
resize2fs /dev/sda
```
