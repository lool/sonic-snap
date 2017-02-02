Redis configuration

Redis is used as an in-memory database and for IPC between components.

The snap includes Redis binaries and config coming from the Ubuntu .deb.

Redis listens on localhost on the default port (6379). It would be better to
use an unix socket as to avoid conflicts between multiple redis instances.

The Redis launcher defaults to using the read-only config from the snap, but will prefer an override config from the snap's writable path, under redis/redis.conf, if present.

Database snapshots are written to redis/redis

