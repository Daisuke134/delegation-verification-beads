# Announcement posts (launch, 2026-11-25)

Published via the dissemination pipeline (Postiz, through the postiz-safe wrapper):

- **LinkedIn** (Daisuke Narita) — Postiz post `cmwvw8a150nznqd07sgk8s5ep`, scheduled 2026-11-25 17:57 JST. The wrapper read the stored content back and verified the public URL survived verbatim (exit 0).
- **X** (@diceai0) — Postiz post `cmwvw9w7s0o1jqd07o1udry37`, scheduled 2026-11-25 17:58 JST. Link-free by design: Postiz Cloud strips all URLs from X posts server-side (vendor-confirmed), so the X version names the repo as text instead of linking it.

## X (as published, link-free)

Our agents were silently stalling — tasks unanswered for 16–32h while dashboards just reported it.

Fix: prove work, don't report stalls. Beads (bd) is now our delegation ledger: atomic claims, heartbeats, stale reclaim, artifact-verified closes.

Open-sourced: GitHub 'delegation-verification-beads'. First run caught 4 stalled lanes.

## LinkedIn (as published)

We run a multi-agent company, and we had a verification problem: work delegated to named AI agents (Codex, Devin, and others) sat unanswered for up to 32 hours, while our monitoring loops merely reported the stalls.

So we applied our own rule — copy the winners' tool, 100%. The agent community's standard is Beads (gastownhall/beads, 29k stars): a dependency-aware issue tracker for coding agents with atomic claims, leases, heartbeats, and dead-worker recovery.

Now every delegation is a beads issue. Claimed = `bd update --claim`. Alive = `bd heartbeat`. Stopped = `bd stale` / `bd reclaim`, mechanically. Done = `bd close` with an artifact reference the verifier has read back.

First run verdicts, from the tool's own output: four lanes STALLED, one DONE. No narrative overrides the tool.

The full setup — search record, adoption evidence, wiring, and the worked first run — is open source:
https://github.com/Daisuke134/delegation-verification-beads
