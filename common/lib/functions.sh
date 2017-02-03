# loads defaults and config if any
load_config() {
    local config="$SNAP_DATA/config.sh"

    SONIC_BACKEND=detect

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
        # TODO add lspci autodetection logic
        SONIC_BACKEND=broadcom
      ;;
      *)
        echo "Unsupported backend" >&2
        exit 1
      ;;
    esac
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

