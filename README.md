Backend
=======

This snap includes two backends, broadcom and p4, which allow selecting which
set of binaries to run. To choose a backend, use:
`sudo snap set sonic-lool backend=p4`

And restart services:
`sudo systemctl restart snap.sonic-lool.syncd.service`


Redis
=====

Redis is used as an in-memory database and for IPC between components.

This snap runs Redis as built by SONiC, overriding some config options.

Redis listens on an unix socket at:
`/var/snap/sonic-lool/current/run/redis.sock`

The included redis-cli client defaults to this socket; e.g.:
```% sudo `which sonic-lool.redis-cli` ping
PONG```

The default config is found at:
`/snap/sonic-lool/current/etc/redis/redis.conf`

To override it, place your config file at:
`/var/snap/sonic-lool/current/conf/redis.conf`

Database snapshots are written under:
`/var/snap/sonic-lool/current/redis-db/`

