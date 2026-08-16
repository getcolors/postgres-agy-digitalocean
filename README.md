# postgres-agy-digitalocean

Desired state for a three-node PostgreSQL 17 failover cluster on DigitalOcean.

- Target: DigitalOcean `ams3`, `s-2vcpu-4gb`, `ubuntu-24-04-x64`
- Quorum store: Colocated etcd v3
- Client endpoint: `postgres-agy.bigconfig.online`
- Backups & continuous WAL: Cloudflare R2 bucket `postgres-agy-backup`
