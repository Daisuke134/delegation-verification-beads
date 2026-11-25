# Announcement posts (launch, 2026-11-25)

## X

Our agents were silently stalling — delegations sat unanswered for 16–32 hours while dashboards just reported it.

The fix: stop reporting stalls, start proving work. We adopted Beads (bd) 100% as our delegation ledger: every task is claimed atomically, heartbeats prove life, stale leases get reclaimed, and nothing counts as done without a verified artifact.

We open-sourced our exact setup — skill, bootstrap, and the first run that caught 4 stalled lanes:
https://github.com/Daisuke134/delegation-verification-beads

## LinkedIn

We run a multi-agent company, and we had a verification problem: work delegated to named AI agents (Codex, Devin, and others) sat unanswered for up to 32 hours, while our monitoring loops merely reported the stalls.

So we applied our own rule — copy the winners' tool, 100%. The agent community's standard is Beads (gastownhall/beads, 29k stars): a dependency-aware issue tracker for coding agents with atomic claims, leases, heartbeats, and dead-worker recovery.

Now every delegation is a beads issue. Claimed = `bd update --claim`. Alive = `bd heartbeat`. Stopped = `bd stale` / `bd reclaim`, mechanically. Done = `bd close` with an artifact reference the verifier has read back.

First run verdicts, from the tool's own output: four lanes STALLED, one DONE. No narrative overrides the tool.

The full setup — search record, adoption evidence, wiring, and the worked first run — is open source:
https://github.com/Daisuke134/delegation-verification-beads
