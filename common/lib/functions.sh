get_backend() {
    local backend="$(snapctl get backend)"

    # TODO add lspci autodetection logic
    if [ -z "$backend" ] || [ "$backend" = detect ]; then
        backend=broadcom
    fi

    echo "$backend"
}

setup_env() {
    local backend=$(get_backend)

    case `uname -m` in
      x86_64)
        triplet="x86_64-linux-gnu"
      ;;
      *)
        echo "Unsupported architecture" >&2
        exit 1
      ;;
    esac
    
    
    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$SNAP/$backend/lib"
    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$SNAP/$backend/usr/lib"
    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$SNAP/$backend/lib/$triplet"
    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$SNAP/$backend/usr/lib/$triplet"
    export PATH="$PATH:$SNAP/$backend/bin"
    export PATH="$PATH:$SNAP/$backend/usr/bin"
}

