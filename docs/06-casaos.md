# 06 — CasaOS

## What CasaOS does

CasaOS is a web-based home cloud/server interface designed to make self-hosted applications easier to manage.

It is primarily a management layer around containerized applications.

## Official site

https://casaos.io/

## Installation

Before installing, confirm the current installation command from the official CasaOS documentation/repository because installation commands can change between releases.

Official project:
https://github.com/IceWhaleTech/CasaOS

## Post-install checklist

1. Open the CasaOS web interface.
2. Change/default secure credentials as applicable.
3. Confirm storage locations.
4. Confirm Docker is healthy.
5. Install only trusted applications/images.
6. Prefer Tailscale for private admin access.
7. Avoid exposing the CasaOS admin interface publicly.

## Docker relationship

```text
CasaOS
   |
   +-- Docker Engine
         |
         +-- container 1
         +-- container 2
         +-- container 3
```

Do not assume every CasaOS application is safe merely because it appears in an app store. Review the image publisher, update history, permissions, volumes and exposed ports.

## Backup

Back up:

- CasaOS configuration if applicable
- Docker Compose files
- persistent application data
- databases
- important media/documents

Do not back up only the containers; containers are disposable, data is not.
