#!/bin/bash
## Setting Global Variables
PARENT=${0%/*}
# Color Variables
  msgNormal='\033[1;33m'
  msgSuccess='\033[1;32m'
  msgError='\033[1;31m'
  msgReset='\033[0m'
echo -e "\e[32mElevation started\e[39m"
  [ "$UID" -eq 0 ] || exec sudo -t bash "$0" "$@"
echo -e "\e[33mNIC Name:\e[39m"
read nic
printf "${msgNormal} Setting up Firewall.sh ${msgReset}\n"
cat > /firewall.sh << EOL
#!/bin/bash
#<---GLOBAL RULES--->
IPT=/sbin/iptables
IP6T=/sbin/ip6tables

# IPv6
## IPv6 Disable
$IP6T -F
$IP6T -X
$IP6T -t nat -F
$IP6T -t nat -X
$IP6T -t mangle -F
$IP6T -t mangle -X
$IP6T -A OUTPUT -j REJECT
$IP6T -A INPUT -j DROP
$IP6T -A FORWARD -j DROP
## /IPv6

# IPv4
## IPv4 Setup
$IPT -F
$IPT -X
$IPT -t nat -F
$IPT -t nat -X
$IPT -t mangle -F
$IPT -t mangle -X

## IPv4 Configure
### Devices
$IPT -A INPUT -p icmp --icmp-type echo-request -m limit --limit 5/second --limit-burst 10 -j ACCEPT
$IPT -A FORWARD -j DROP
### lo
$IPT -A INPUT -i lo -j ACCEPT
$IPT -A OUTPUT -o lo -j ACCEPT

#<---GLOBAL RULES--->
EOL
printf "${msgNormal} Creating Executable ${msgReset}\n"
chmod +x /firewall.sh
