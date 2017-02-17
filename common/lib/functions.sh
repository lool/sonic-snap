# loads defaults and config if any
load_config() {
    local config="$SNAP_DATA/config.sh"

    SONIC_BACKEND=detect
    SONIC_HWSKU=unconfigured
    SONIC_MAC_ADDRESS=detect

    if [ -e "$config" ]; then
        . "$config"
    fi
}

detect_backend() {
    load_config

    case "$SONIC_BACKEND" in
      broadcom|p4)
      ;;
      detect)
        # TODO add autodetection logic
        SONIC_BACKEND=broadcom
      ;;
      *)
        echo "Unsupported backend" >&2
        exit 1
      ;;
    esac
}

detect_hwsku() {
    load_config
    detect_backend

    if [ "$SONIC_HWSKU" = unconfigured ]; then
        echo "Unconfigured hwsku" >&2
        exit 1
    fi
    if [ "$SONIC_HWSKU" = detect ]; then
        # TODO add autodetection logic
        echo "Unimplemented" >&2
        exit 1
    fi
    if ! [ -r "$SNAP/$SONIC_BACKEND/etc/syncd.d/$SONIC_HWSKU.profile" ]; then
        echo "Unsupported hwsku" >&2
        exit 1
    fi
}

detect_mac_address() {
    load_config

    if [ "$SONIC_MAC_ADDRESS" = detect ]; then
	    # should at least be lo there; sort to have somewhat reliable order
	    for dev in $(echo /sys/class/net/* | sort); do
		if ! [ -e "$dev/device" ]; then
		    continue
		fi
		# FIXME this just takes the first PCI ethernet card
		case "$(readlink "$dev/device/subsystem")" in
		  */bus/pci)
		    SONIC_MAC_ADDRESS="$(cat "$dev/address")"
		    break
		  ;;
		esac
	    done
    fi
}

setup_env() {
    detect_backend

    case `uname -m` in
      x86_64)
        triplet="x86_64-linux-gnu"
      ;;
      *)
        echo "Unsupported architecture" >&2
        exit 1
      ;;
    esac

    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$SNAP/$SONIC_BACKEND/lib"
    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$SNAP/$SONIC_BACKEND/usr/lib"
    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$SNAP/$SONIC_BACKEND/lib/$triplet"
    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$SNAP/$SONIC_BACKEND/usr/lib/$triplet"
    export PATH="$PATH:$SNAP/$SONIC_BACKEND/bin"
    export PATH="$PATH:$SNAP/$SONIC_BACKEND/usr/bin"
}

