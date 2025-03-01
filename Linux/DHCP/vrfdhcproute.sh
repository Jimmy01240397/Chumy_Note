#!/bin/bash

if [ -e /sys/class/net/$interface/master ]
then
        vrf=$(cat /sys/class/net/$interface/master/uevent | grep INTERFACE | awk -F= '{print $2}')
        case "$reason" in
            BOUND|RENEW|REBIND|REBOOT)
                if [ -z "$old_ip_address" ] ||
                   [ "$old_ip_address" != "$new_ip_address" ] ||
                   [ "$reason" = "BOUND" ] || [ "$reason" = "REBOOT" ]; then
                    # if we have $new_rfc3442_classless_static_routes then we have to
                    # ignore $new_routers entirely
                    if [ ! "$new_rfc3442_classless_static_routes" ]; then
                            # set if_metric if IF_METRIC is set or there's more than one router
                            if_metric="$IF_METRIC"
                            if [ "${new_routers%% *}" != "${new_routers}" ]; then
                                if_metric=${if_metric:-1}
                            fi

                            for router in $new_routers; do
                                if [ "$new_subnet_mask" = "255.255.255.255" ]; then
                                    # point-to-point connection => set explicit route
                                    ip -4 route add ${router} dev $interface vrf ${vrf} >/dev/null 2>&1
                                fi

                                # set default route
                                ip -4 route add default via ${router} dev ${interface} vrf ${vrf} \
                                    ${if_metric:+metric $if_metric} >/dev/null 2>&1

                                if [ -n "$if_metric" ]; then
                                    if_metric=$((if_metric+1))
                                fi
                            done
                    fi
                fi

                if [ -n "$alias_ip_address" ] &&
                   [ "$new_ip_address" != "$alias_ip_address" ]; then
                    # separate alias IP given, which may have changed
                    # => flush it, set it & add host route to it
                    ip -4 route add ${alias_ip_address} dev ${interface} vrf ${vrf} >/dev/null 2>&1
                fi
                ;;

            TIMEOUT)
                # if there is no router recorded in the lease or the 1st router answers pings
                if [ -z "$new_routers" ] || ping -q -c 1 "${new_routers%% *}"; then
                    # if we have $new_rfc3442_classless_static_routes then we have to
                    # ignore $new_routers entirely
                    if [ ! "$new_rfc3442_classless_static_routes" ]; then
                            if [ -n "$alias_ip_address" ] &&
                               [ "$new_ip_address" != "$alias_ip_address" ]; then
                                # separate alias IP given => set up the alias IP & add host route to it
                                ip -4 route add ${alias_ip_address} dev ${interface} vrf ${vrf} >/dev/null 2>&1
                            fi

                            # set if_metric if IF_METRIC is set or there's more than one router
                            if_metric="$IF_METRIC"
                            if [ "${new_routers%% *}" != "${new_routers}" ]; then
                                if_metric=${if_metric:-1}
                            fi

                            # set default route
                            for router in $new_routers; do
                                ip -4 route add default via ${router} dev ${interface} vrf ${vrf} \
                                    ${if_metric:+metric $if_metric} >/dev/null 2>&1

                                if [ -n "$if_metric" ]; then
                                    if_metric=$((if_metric+1))
                                fi
                            done
                    fi
                fi
                ;;

        esac

fi
