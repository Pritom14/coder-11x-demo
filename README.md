# coder-11x-demo

Test repository for the 11x-style Coder workspace template. It follows the
template's repository convention: lifecycle hooks in `bin/coder/` (or
`scripts/coder/`), run by the template's `repo-dispatch.sh` as `ubuntu` from the
repository root, logging to `~/.coder-logs/<repo>-<phase>.log`.

| Hook | When | What it does here |
| --- | --- | --- |
| `bin/coder/workspace-bootstrap.sh` | first boot, blocks Ready | `make up wait` plus `seed` or `load` per `STARTUP_OPTION` |
| `bin/coder/handle-restart.sh` | every later start, blocks Ready | `make up wait` unless the first boot chose `none` |
| `bin/coder/handle-shutdown.sh` | before the instance stops | `make down` (keeps the data volume) |

`STARTUP_OPTION` comes from the template's Startup Option parameter:
`none`, `containers`, `seed` or `data-load`.

Stack: `postgres:16-alpine` on 127.0.0.1:5433 and a zero-dependency Node app on
127.0.0.1:3000 (also published on 5173, the template's "Alice Frontend" app port).
Override with `DB_PORT`, `WEB_PORT`, `ALICE_FRONTEND_PORT`.

Local try-out: `STARTUP_OPTION=seed bin/coder/workspace-bootstrap.sh`, then
`bin/coder/handle-shutdown.sh`, `bin/coder/handle-restart.sh`, `make clean`.
AO dev-env check 2026-10-11
