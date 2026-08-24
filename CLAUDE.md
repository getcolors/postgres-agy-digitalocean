# CLAUDE.md

## What this is

`postgres-agy-digitalocean` is **desired state only**. It holds no source code.
`colors.yml` describes one three-node PostgreSQL failover cluster on
DigitalOcean; everything that acts on it lives in `getcolors/postgres-agy`,
resolved by the immutable Git SHA stamped into `./green`.

The client endpoint is `postgres-agy.bigconfig.online`. Backups and WAL go to the R2
bucket `postgres-agy-backup`.

## Commands

```sh
./green build              # render .colors/ — no provider calls, no credentials
./green create --dry-run   # walk the graph, skip every side effect
./green create             # converge for real
./green delete             # guarded; see below

./green status             # patronictl list
./green switchover         # planned handover
./green failover --node 2  # unplanned promotion via a live node
./green backup             # full backup now, on the leader
./green verify-restore     # verified restore now, on a standby
./green psql               # a session on the current primary
```

`build` and `--dry-run` work on a fresh checkout with an empty environment, so
they are the way to check an edit to `colors.yml`. Exit code 2 means validation
failed and lists every problem at once. The launcher walks up to find
`colors.yml`, so any subdirectory works.

Run `direnv allow` once; the toolchain (OpenTofu, Ansible, `psql`, `doctl`)
comes from `devenv.nix`.

## Rules

- **`colors.yml` is the only file to edit**, and it holds non-secret values
  only. Keys are kebab-case.
- **Credentials are `COLORS_PAR_*`** in the gitignored `.envrc.private`. Never
  read, print, or copy that file. Never put a credential in `colors.yml`, in
  generated output, or in a commit message.
- **Never export `COLORS_PAR_PROFILE`.** It keys both `<profile>/<stage>.tfstate`
  and the backup repository path; overlaying it points this deployment at
  another one's. The package refuses to run when it is set.
- **`.colors/` is generated.** Never edit it, read it as source, or commit it.
- **`compute-prevent-destroy: true` stays.** Lift it for exactly one authorized
  delete with `COLORS_PAR_COMPUTE_PREVENT_DESTROY=false`; never by editing the
  file.
- **`.gitignore` is `.*` with narrow negations.** A new dotfile is invisible to
  git until it is negated — check `git ls-files`, not the working tree.

## The launcher is a copy

`./green` is a **copy** of `.agents/skills/package-postgres-agy-green/green`,
not a symlink. `npx skills update -p` rewrites the payload and leaves the root
file alone, so the project would keep running the old pin while
`skills-lock.json` claimed the new one:

```sh
npx skills update -p
cp .agents/skills/package-postgres-agy-green/green green
```

Compare the two after any update. To develop against a working tree instead of
the pin, set `POSTGRES_AGY_LIB_ROOT=../postgres-agy`.

## Documentation

`index.html` is this repository's landing page and carries two analytics tags:
GA4 measurement ID `G-4VKP1WY4QJ`, whose explicit `page_title` must exactly
equal the decoded HTML `<title>` and stay distinct and stable so one Analytics
property can separate repositories, and the self-hosted Rybbit snippet
`<script src="https://rybbit.getcolors.ai/api/script.js" data-site-id="9fb9c41a6d49" defer></script>`,
which shares one site ID across every page because `getcolors.github.io/<repo>/`
paths already encode the repository. Never add one tag without the other.

## Git

Work on the current branch. Do not commit or push unless explicitly asked.
