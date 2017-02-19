# Installation

On an Ubuntu 16.04 or later system with all updates, check you have snapd
installed and run a test snap:
```shell
snap version
sudo snap install hello-world
hello-world
```

To install SONiC:
```shell
sudo snap install --devmode --edge sonic-lool
```

## HWSKU

The switch model and port layout aren't automatically detected; to set the
SONiC "HWSKU", use `snap set` and restart the services:
```shell
sudo snap set sonic-lool hwsku=wedge100-32x100G
sudo systemctl restart snap.sonic-lool.swss
```

These are the profiles currently available and their support status:

| Switch               | SONiC HWSKUs        | Snap status    |
|----------------------|---------------------|----------------|
| Arista 7050X         | `arista_a7050_qx32` | untested       |
| Dell S6000           | `dell_s6000`        | untested       |
| Dell S6100           | `dell_s6100`        | untested       |
| Dell S6100           | `dell_s6100`        | untested       |
| Mellanox SN2700      | `mlnx_2700`         | untested       |
| Wedge 100-32X        | `wedge100`          | segfaults      |
| Wedge 100-32X        | `wedge100-128x25G`  | doesn't crash  |
| Wedge 100-32X        | `wedge100-32x100G`  | works!         |
| Wedge 100-32X        | `wedge100-32x40G`   | doesn't crash  |
| Wedge-16X (Wedge 40) | `wedge40`           | errors out     |
| Wedge-16X (Wedge 40) | `wedge40-16x40G`    | errors out     |
| Wedge-16X (Wedge 40) | `wedge40-64x10G`    | untested       |

## MAC address

The default MAC address is the one of the management interface; to override it:
```shell
sudo snap set sonic-lool mac-address=xx:yy:zz:aa:bb:cc
```

# Operations and debugging
## SWSS output

To see the output of the various daemons, run:
```shell
sudo journalctl -u snap.sonic-lool.swss  -f
```

## Redis access

The included redis-cli wrapper sets up the proper socket connection; note that
SONiC uses DB 1:
```shell
sudo sonic-lool.redis-cli PING
sudo sonic-lool.redis-cli -n 1 HLEN HIDDEN
```

## Clean restart

To clear all of SONiC's state and start afresh:
```shell
sudo systemctl stop snap.sonic-lool.swss
sudo sonic-lool.redis-cli FLUSHALL
sudo systemctl start snap.sonic-lool.swss
```

# Experimental P4 backend

This snap includes two backends, broadcom and p4, which allow selecting which
set of binaries to run. To chose the p4 backend and restart the services:
```shell
sudo snap set sonic-lool backend=p4
sudo systemctl restart snap.sonic-lool.swss
```

