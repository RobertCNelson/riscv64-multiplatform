#!/bin/sh -e

DIR=$PWD

config_enable () {
	ret=$(./scripts/config --state ${config})
	if [ ! "x${ret}" = "xy" ] ; then
		echo "Setting: ${config}=y"
		./scripts/config --enable ${config}
	fi
}

config_disable () {
	ret=$(./scripts/config --state ${config})
	if [ ! "x${ret}" = "xn" ] ; then
		echo "Setting: ${config}=n"
		./scripts/config --disable ${config}
	fi
}

config_enable_special () {
	test_module=$(cat .config | grep ${config} || true)
	if [ "x${test_module}" = "x# ${config} is not set" ] ; then
		echo "Setting: ${config}=y"
		sed -i -e 's:# '$config' is not set:'$config'=y:g' .config
	fi
	if [ "x${test_module}" = "x${config}=m" ] ; then
		echo "Setting: ${config}=y"
		sed -i -e 's:'$config'=m:'$config'=y:g' .config
	fi
}

config_module_special () {
	test_module=$(cat .config | grep ${config} || true)
	if [ "x${test_module}" = "x# ${config} is not set" ] ; then
		echo "Setting: ${config}=m"
		sed -i -e 's:# '$config' is not set:'$config'=m:g' .config
	else
		echo "$config=m" >> .config
	fi
}

config_module () {
	ret=$(./scripts/config --state ${config})
	if [ ! "x${ret}" = "xm" ] ; then
		echo "Setting: ${config}=m"
		./scripts/config --module ${config}
	fi
}

config_string () {
	ret=$(./scripts/config --state ${config})
	if [ ! "x${ret}" = "x${option}" ] ; then
		echo "Setting: ${config}=\"${option}\""
		./scripts/config --set-str ${config} "${option}"
	fi
}

config_value () {
	ret=$(./scripts/config --state ${config})
	if [ ! "x${ret}" = "x${option}" ] ; then
		echo "Setting: ${config}=${option}"
		./scripts/config --set-val ${config} ${option}
	fi
}

cd ${DIR}/KERNEL/

#BeagleV
config="CONFIG_NVDLA" ; config_enable

#Docker.io:
config="CONFIG_NAMESPACES" ; config_enable
config="CONFIG_NET_NS" ; config_enable
config="CONFIG_PID_NS" ; config_enable
config="CONFIG_IPC_NS" ; config_enable
config="CONFIG_UTS_NS:" ; config_enable
config="CONFIG_CGROUPS" ; config_enable
config="CONFIG_CGROUP_CPUACCT" ; config_enable
config="CONFIG_CGROUP_DEVICE" ; config_enable
config="CONFIG_CGROUP_FREEZER" ; config_enable
config="CONFIG_CGROUP_SCHED" ; config_enable
config="CONFIG_CPUSETS" ; config_enable
config="CONFIG_MEMCG" ; config_enable
config="CONFIG_KEYS" ; config_enable
config="CONFIG_VETH" ; config_module
config="CONFIG_BRIDGE" ; config_module
config="CONFIG_BRIDGE_NETFILTER" ; config_module
config="CONFIG_IP_NF_FILTER" ; config_module
config="CONFIG_IP_NF_TARGET_MASQUERADE" ; config_module
config="CONFIG_NETFILTER_XT_MATCH_ADDRTYPE" ; config_module
config="CONFIG_NETFILTER_XT_MATCH_CONNTRACK:" ; config_module
config="CONFIG_NETFILTER_XT_MATCH_IPVS" ; config_module
config="CONFIG_NETFILTER_XT_MARK" ; config_module
config="CONFIG_IP_NF_NAT" ; config_module
config="CONFIG_NF_NAT" ; config_module
config="CONFIG_POSIX_MQUEUE" ; config_enable


cd ${DIR}/
