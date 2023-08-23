# HQTWCE (frr)
```
frr version 8.4.2
frr defaults traditional
hostname HQTWCE
service integrated-vtysh-config
!
ip route 192.168.0.0/23 Null0
ipv6 route 2407:9240:3100:100::/63 Null0
!
router bgp 65000
 neighbor 103.69.90.127 remote-as 149423
 neighbor 103.69.90.127 capability extended-nexthop
 neighbor 2407:9240:3100:ffff::ffff remote-as 149423
 neighbor 2407:9240:3100:ffff::ffff capability extended-nexthop
 !
 address-family ipv4 unicast
  network 192.168.0.0/23
  neighbor 103.69.90.127 route-map all in
  neighbor 103.69.90.127 route-map all out
  no neighbor 2407:9240:3100:ffff::ffff activate
 exit-address-family
 !
 address-family ipv6 unicast
  network 2407:9240:3100:100::/63
  neighbor 2407:9240:3100:ffff::ffff activate
  neighbor 2407:9240:3100:ffff::ffff route-map all in
  neighbor 2407:9240:3100:ffff::ffff route-map all out
 exit-address-family
exit
!
route-map all permit 5
exit
!
segment-routing
 traffic-eng
 exit
exit
!
```

# TWPE (frr)
```
frr version 8.4.2
frr defaults traditional
hostname TWPE
log syslog informational
service integrated-vtysh-config
!
ip router-id 10.0.0.4
ip route 103.69.90.126/31 eth1 nexthop-vrf hq
ipv6 route 2407:9240:3100:100::/63 2407:9240:3100:ffff::fffe eth1 nexthop-vrf hq
ipv6 route fccc:0:0:2::/64 Null0
ipv6 route 2407:9240:3100:ffff::fffe/127 eth1 nexthop-vrf hq
!
vrf hq
 ip router-id 10.0.0.4
exit-vrf
!
interface lo
 ip address 10.0.0.4/32
 ip ospf area 0
 ip ospf passive
 ipv6 address 2407:9240:310e::4/128
 ipv6 ospf6 area 0
 ipv6 ospf6 passive
exit
!
interface eth0
 ip ospf area 0
 ip ospf network point-to-point
 ipv6 ospf6 area 0
 ipv6 ospf6 network point-to-point
exit
!
interface eth1
exit
!
interface hq
exit
!
router bgp 149423
 neighbor 10.0.0.6 remote-as 149423
 neighbor 10.0.0.6 update-source lo
 neighbor 10.0.0.6 capability extended-nexthop
 neighbor 2407:9240:310e::6 remote-as 149423
 neighbor 2407:9240:310e::6 update-source lo
 neighbor 2407:9240:310e::6 capability extended-nexthop
 !
 segment-routing srv6
  locator main
 exit
 !
 address-family ipv4 unicast
  neighbor 10.0.0.6 next-hop-self
  no neighbor 2407:9240:310e::6 activate
 exit-address-family
 !
 address-family ipv4 vpn
  neighbor 2407:9240:310e::6 activate
 exit-address-family
 !
 address-family ipv6 unicast
  neighbor 2407:9240:310e::6 activate
  neighbor 2407:9240:310e::6 next-hop-self
 exit-address-family
 !
 address-family ipv6 vpn
  neighbor 2407:9240:310e::6 activate
 exit-address-family
exit
!
router bgp 149423 vrf hq
 bgp router-id 10.0.0.4
 neighbor 103.69.90.126 remote-as 65000
 neighbor 103.69.90.126 capability extended-nexthop
 neighbor 2407:9240:3100:ffff::fffe remote-as 65000
 neighbor 2407:9240:3100:ffff::fffe capability extended-nexthop
 !
 address-family ipv4 unicast
  neighbor 103.69.90.126 route-map all in
  neighbor 103.69.90.126 route-map all out
  no neighbor 2407:9240:3100:ffff::fffe activate
  sid vpn export auto
  rd vpn export 149423:65000
  rt vpn both 149423:65000
  export vpn
  import vpn
 exit-address-family
 !
 address-family ipv6 unicast
  neighbor 2407:9240:3100:ffff::fffe activate
  neighbor 2407:9240:3100:ffff::fffe route-map all in
  neighbor 2407:9240:3100:ffff::fffe route-map all out
  sid vpn export auto
  rd vpn export 149423:65000
  rt vpn both 149423:65000
  export vpn
  import vpn
 exit-address-family
exit
!
router ospf
 redistribute static
exit
!
router ospf6
 redistribute static
exit
!
route-map all permit 5
exit
!
segment-routing
 srv6
  locators
   locator main
    prefix fccc:0:0:2::/64
   exit
   !
  exit
  !
 exit
 !
 traffic-eng
 exit
exit
!
```

# MAINGW (frr)
```
frr version 8.4.2
frr defaults traditional
hostname MAINGW
log syslog informational
service integrated-vtysh-config
!
ip router-id 10.0.0.6
ipv6 route fccc:0:0:1::/64 Null0
!
interface lo
 ip address 10.0.0.6/32
 ip ospf area 0
 ip ospf passive
 ipv6 address 2407:9240:310e::6/128
 ipv6 ospf6 area 0
 ipv6 ospf6 passive
exit
!
interface eth0
 ip ospf area 0
 ip ospf network point-to-point
 ipv6 ospf6 area 0
 ipv6 ospf6 network point-to-point
exit
!
interface eth1
 ip ospf area 0
 ip ospf network point-to-point
 ipv6 ospf6 area 0
 ipv6 ospf6 network point-to-point
exit
!
interface eth2
 ip ospf area 0
 ip ospf network point-to-point
 ipv6 ospf6 area 0
 ipv6 ospf6 network point-to-point
exit
!
interface eth3
 ip ospf area 1
 ip ospf network point-to-point
 ipv6 ospf6 area 1
 ipv6 ospf6 network point-to-point
exit
!
interface eth4
 ip ospf area 0
 ip ospf network point-to-point
 ipv6 ospf6 area 0
 ipv6 ospf6 network point-to-point
exit
!
router bgp 149423
 no bgp default ipv4-unicast
 neighbor v4 peer-group
 neighbor v4 remote-as 149423
 neighbor v4 update-source lo
 neighbor v4 capability extended-nexthop
 neighbor v6 peer-group
 neighbor v6 remote-as 149423
 neighbor v6 update-source lo
 neighbor v6 capability extended-nexthop
 neighbor vpn peer-group
 neighbor vpn remote-as 149423
 neighbor vpn update-source lo
 neighbor vpn capability extended-nexthop
 neighbor 10.0.0.1 peer-group v4
 neighbor 10.0.0.2 peer-group v4
 neighbor 10.0.0.3 peer-group v4
 neighbor 10.0.0.4 peer-group v4
 neighbor 10.0.0.5 peer-group v4
 neighbor 2407:9240:310e::1 peer-group v6
 neighbor 2407:9240:310e::2 peer-group v6
 neighbor 2407:9240:310e::3 peer-group v6
 neighbor 2407:9240:310e::4 peer-group vpn
 neighbor 2407:9240:310e::5 peer-group vpn
 !
 segment-routing srv6
  locator main
 exit
 !
 address-family ipv4 unicast
  neighbor v4 activate
  neighbor v4 route-reflector-client
 exit-address-family
 !
 address-family ipv4 vpn
  neighbor vpn activate
  neighbor vpn route-reflector-client
 exit-address-family
 !
 address-family ipv6 unicast
  neighbor v6 activate
  neighbor v6 route-reflector-client
  neighbor vpn activate
  neighbor vpn route-reflector-client
 exit-address-family
 !
 address-family ipv6 vpn
  neighbor vpn activate
  neighbor vpn route-reflector-client
 exit-address-family
exit
!
router ospf
 area 1 stub
exit
!
router ospf6
 redistribute static
 area 1 stub
exit
!
segment-routing
 srv6
  locators
   locator main
    prefix fccc:0:0:1::/64
   exit
   !
  exit
  !
 exit
 !
 traffic-eng
 exit
exit
!
```

# USPE (Cisco IOS XR 9000)
```
!! IOS XR Configuration 7.6.1
!! Last configuration change at Wed Aug 23 16:55:12 2023 by root
!
hostname USPE
username root
 group root-lr
 group cisco-support
 secret 10 $6$oIz2LpDl3HQ/L...$5TfXaWZIZ6qSc2rcX8Ak5.xWxNeLJJ6X4S3qC32T8jhjMJ0MK420Z1/MhlDHMUgN6UTDIiSE8U1L7oVNyToPD0
!
vrf hq
 address-family ipv4 unicast
  import route-target
   149423:65000
  !
  export route-target
   149423:65000
  !
 !
 address-family ipv6 unicast
  import route-target
   149423:65000
  !
  export route-target
   149423:65000
  !
 !
!
call-home
 service active
 contact smart-licensing
 profile CiscoTAC-1
  active
  destination transport-method email disable
  destination transport-method http
 !
!
interface Loopback0
 ipv4 address 10.0.0.5 255.255.255.255
 ipv6 address 2407:9240:310e::5/128
!
interface MgmtEth0/RP0/CPU0/0
 shutdown
!
interface GigabitEthernet0/0/0/0
 ipv4 address 103.69.91.134 255.255.255.252
 ipv6 address 2407:9240:310f:ffff::6/126
!
interface GigabitEthernet0/0/0/1
 vrf hq
 ipv4 address 103.69.90.254 255.255.255.252
 ipv6 address 2407:9240:3101:ffff::fffe/126
!
prefix-set all
  0.0.0.0/0 le 32,
  ::/0 le 128
end-set
!
route-policy all
  pass
end-policy
!
router static
 address-family ipv4 unicast
  103.69.90.252/30 vrf hq GigabitEthernet0/0/0/1
 !
 address-family ipv6 unicast
  2407:9240:3101:100::/64 vrf hq GigabitEthernet0/0/0/1 2407:9240:3101:ffff::fffd
  2407:9240:3101:ffff::fffc/126 vrf hq GigabitEthernet0/0/0/1
  fccc:0:0:3::/64 Null0
 !
 vrf hq
  address-family ipv4 unicast
   0.0.0.0/0 vrf default
  !
  address-family ipv6 unicast
   ::/0 vrf default
  !
 !
!
router ospf 1
 router-id 10.0.0.5
 redistribute static
 area 0
  interface Loopback0
   passive enable
  !
  interface GigabitEthernet0/0/0/0
   network point-to-point
  !
 !
!
router ospfv3 1
 router-id 10.0.0.5
 redistribute static
 area 0
  interface Loopback0
   passive
  !
  interface GigabitEthernet0/0/0/0
   network point-to-point
  !
 !
 address-family ipv6 unicast
!
router bgp 149423
 address-family ipv4 unicast
 !
 address-family vpnv4 unicast
  segment-routing srv6
   locator main
  !
 !
 address-family ipv6 unicast
 !
 address-family vpnv6 unicast
  segment-routing srv6
   locator main
  !
 !
 neighbor 10.0.0.6
  remote-as 149423
  update-source Loopback0
  address-family ipv4 unicast
  !
 !
 neighbor 2407:9240:310e::6
  remote-as 149423
  update-source Loopback0
  address-family vpnv4 unicast
   route-policy all in
   route-policy all out
  !
  address-family ipv6 unicast
   route-policy all in
   route-policy all out
  !
  address-family vpnv6 unicast
   route-policy all in
   route-policy all out
  !
 !
 vrf hq
  rd 149423:65000
  address-family ipv4 unicast
   segment-routing srv6
    alloc mode per-vrf
   !
  !
  address-family ipv6 unicast
   segment-routing srv6
    alloc mode per-vrf
   !
  !
  neighbor 103.69.90.253
   remote-as 65000
   address-family ipv4 unicast
    route-policy all in
    route-policy all out
   !
  !
  neighbor 2407:9240:3101:ffff::fffd
   remote-as 65000
   address-family ipv6 unicast
    route-policy all in
    route-policy all out
   !
  !
 !
!
segment-routing
 srv6
  locators
   locator main
    prefix fccc:0:0:3::/64
   !
  !
 !
!
crypto key generate rsa the_default general-keys 1024
ssh server v2
end
```

# HQUSCE (frr)
```
frr version 8.4.2
frr defaults traditional
hostname HQUSCE
service integrated-vtysh-config
!
ip route 192.168.100.0/24 Null0
ipv6 route 2407:9240:3101:100::/64 Null0
!
router bgp 65000
 neighbor 103.69.90.254 remote-as 149423
 neighbor 103.69.90.254 capability extended-nexthop
 neighbor 2407:9240:3101:ffff::fffe remote-as 149423
 neighbor 2407:9240:3101:ffff::fffe capability extended-nexthop
 !
 address-family ipv4 unicast
  network 192.168.100.0/24
  neighbor 103.69.90.254 route-map all in
  neighbor 103.69.90.254 route-map all out
  no neighbor 2407:9240:3101:ffff::fffe activate
 exit-address-family
 !
 address-family ipv6 unicast
  network 2407:9240:3101:100::/64
  neighbor 2407:9240:3101:ffff::fffe activate
  neighbor 2407:9240:3101:ffff::fffe route-map all in
  neighbor 2407:9240:3101:ffff::fffe route-map all out
 exit-address-family
exit
!
route-map all permit 5
exit
!
segment-routing
 traffic-eng
 exit
exit
!
```
