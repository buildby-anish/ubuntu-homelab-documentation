# 11 — Storage and Backups

## Storage model

Separate:

```text
OS
Application configuration
Application persistent data
Media/data
Backups
```

Example:

```text
/srv/
├── docker/
│   ├── compose/
│   └── appdata/
├── media/
├── documents/
└── backups/
```

## Docker data

Do not assume a container image contains your important data.

Use volumes/bind mounts:

```yaml
volumes:
  app_data:
```

or:

```yaml
volumes:
  - /srv/docker/appdata/app:/data
```

## Backup rule

A useful baseline is:

- 3 copies
- 2 different storage types
- 1 off-site copy

## Backup targets

Possible options:

- external HDD/SSD
- another server/NAS
- cloud object storage
- encrypted remote backup

## Test restores

A backup that has never been restored is unverified.

Periodically restore:

- Compose files
- application configuration
- databases
- critical documents

## Database backups

For databases, prefer logical database dumps plus persistent storage backups.

Do not rely solely on copying a live database directory.
