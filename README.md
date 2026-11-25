# delegation-verification-beads

**Verify that an agent you delegated a task to is actually doing it — and has not stopped.**

Built by [Anicca](https://aniccaai.com). We run a multi-agent company (Claude, Codex, Devin, Gemini, OpenCode, Command Code, and more). Our delegations to named agents sat unanswered for 16–32 hours while monitoring loops merely *reported* the stalls. The fix was not a better report. It was adopting the tool the winners already standardize on, 100%, with no custom wrapper:

## The tool: Beads (`bd`)

[Beads](https://github.com/gastownhall/beads) — ★29,042, 1,959 forks (2026-11-25) — is a dependency-aware issue tracker for coding agents with atomic claims, leases, heartbeats, and dead-worker recovery, synced through git/Dolt. We evaluated it against every alternative we could find on the web, GitHub, and the skills CLI (full search record in [docs/first-run-2026-11-25.md](docs/first-run-2026-11-25.md)) and adopted its workflow completely.

## How the verification works (Beads' own state model, nothing custom)

Every delegation is one beads issue. Four proofs, all mechanical:

| Proof | Command | Meaning |
|---|---|---|
| **Claimed** | `bd update <id> --claim` | Atomic claim: sets the assignee to the claiming actor, status → in_progress, starts a lease. A second actor's claim is refused by the tool. |
| **Actively working** | `bd heartbeat <id>` | The holder refreshes the lease. Lease freshness is the activity signal — no heartbeat, no proof of life. |
| **Not stopped** | `bd stale` + `bd reclaim` | Stale issues are listed mechanically; `bd reclaim` reverts stale-lease in_progress issues to ready so another agent can pick them up. Open-and-unclaimed past deadline = STALLED, by definition. |
| **Artifact landed** | `bd close <id> --reason="<commit/URL>"` | The reason must cite the artifact, and the verifier reads that artifact back before the close counts. |

A delegation with no beads issue does not exist. A narrative status never overrides the tool's output.

## What's in this repo

- [`SKILL.md`](SKILL.md) — the verification skill (judgment layer: smoke-test the channel, read the landed artifact in full, take over on failure) rewritten on top of Beads' state model.
- [`bootstrap.sh`](bootstrap.sh) — installs the pinned `bd` binary, initializes the delegation ledger, and installs Beads' own per-agent integrations (`bd setup` for Claude Code, Codex, Gemini, OpenCode).
- [`templates/lane-delegation-issue.md`](templates/lane-delegation-issue.md) — the issue template we register every delegation with.
- [`docs/first-run-2026-11-25.md`](docs/first-run-2026-11-25.md) — the full worked example: the search record (web / GitHub / skills CLI), the adoption evidence for every serious candidate, the 100%-adoption wiring table, and the first run's per-lane verdicts (four lanes STALLED, one DONE — from the tool's own output).
- [`ANNOUNCEMENT.md`](ANNOUNCEMENT.md) — the launch posts.

## Quick start

```bash
./bootstrap.sh            # installs bd v1.3.4, runs bd init, bd setup for your agents
bd create --title="Lane: <job>" --type=task --priority=0 --assignee=<agent>
bd ready                  # work that can be claimed now
bd update <id> --claim    # the assignee claims (starts the lease)
bd heartbeat <id>         # the assignee proves life while working
bd stale && bd reclaim    # the verifier reclaims dead workers
bd close <id> --reason="Artifact: <commit sha / URL, read back and verified>"
```

## Why we open-sourced this

We are a research lab company: we copy what the winners use, we connect the dots, and we publish what we prove. If your agents are also silently stalling, this is the exact setup that caught ours.

## License

MIT (our skill, scripts, and docs). Beads itself is distributed under its own license — see [gastownhall/beads](https://github.com/gastownhall/beads).
