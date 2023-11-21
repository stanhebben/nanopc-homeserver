# Change the password
echo "Please choose a new password for the root user:"
passwd

# Get tencent out of the package source
sed -i -e 's/mirrors.cloud.tencent.com\/openwrt/downloads.openwrt.org/g' /etc/opkg/distfeeds.conf

# set timezone
# see https://github.com/openwrt/luci/blob/master/modules/luci-lua-runtime/luasrc/sys/zoneinfo/tzdata.lua
uci set system.@system[0].timezone='CET-1CEST,M3.5.0,M10.5.0/3'
uci set system.@system[0].zonename='Europe/Brussels'
uci commit system

# install packages
opkg update
opkg install nano hdparm lscpu htop sudo diffutils patch block-mount kmod-usb-storage
opkg install restic

# mount SSD drive
mkdir /mnt/ssd
mount /dev/nvme0n1p1 /mnt/ssd
block detect | uci import fstab
FSTAB_LINE=`uci show fstab | grep /mnt/ssd`
uci set ${FSTAB_LINE/target=\'\/mnt\/ssd\'/enabled='1'}
uci commit fstab

# setup docker
service dockerd stop
mv /opt/docker /mnt/ssd/docker
uci set dockerd.globals.data_root=/mnt/ssd/docker
uci commit dockerd
# see https://forum.openwrt.org/t/internet-access-of-docker-container/160826
echo "        option extra_iptables_args '--match conntrack ! --ctstate RELATED,ESTABLISHED' # allow outbound connections" >> /etc/config/dockerd
echo "79a80" >> dockerd.patch
echo ">               uci_quiet set network.@device[-1].bridge_empty='1'" >> dockerd.patch
echo "104a106" >> dockerd.patch
echo ">       ifup docker" >> dockerd.patch
patch /etc/init.d/dockerd dockerd.patch
rm dockerd.patch

DOCKER_FORWARD=`uci add firewall forwarding`
uci set firewall.$DOCKER_FORWARD.src='docker'
uci set firewall.$DOCKER_FORWARD.dest='wan'
uci commit firewall

service dockerd start
opkg install docker-compose

# install b2 to sync with BackBlaze
#opkg install python3
#wget https://bootstrap.pypa.io/get-pip.py
#python3 get-pip.py
#git clone https://github.com/Backblaze/B2_Command_Line_Tool.git
#cd B2_Command_Line_Tool/
#python3 setup.py install
#b2 authorize-account

# generate ssh key
ssh-keygen -f /root/.ssh/id_ed25519 -t ed25519 -N ''

# move uhttpd to another port so we can setup nginx as http server
uci del_list uhttpd.main.listen_http='0.0.0.0:80'
uci del_list uhttpd.main.listen_http='[::]:80'
uci add_list uhttpd.main.listen_http='0.0.0.0:8000'
uci add_list uhttpd.main.listen_http='[::]:8000'
uci del_list uhttpd.main.listen_https='0.0.0.0:443'
uci del_list uhttpd.main.listen_https='[::]:443'
uci add_list uhttpd.main.listen_https='0.0.0.0:4430'
uci add_list uhttpd.main.listen_https='[::]:4430'
uci commit uhttpd
service uhttpd restart
