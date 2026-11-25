# Lane delegation issue template

Register every delegation as a beads issue BEFORE the work is sent:

```bash
bd create \
  --title="<Lane> lane: <job summary>" \
  --description="Delegated via <channel> at <timestamp>. Evidence of the delegation: <link/path>. Real-world status at registration: <last landing / silence duration / known fault>. Claim in beads + land the artifact on GitHub, or this delegation is mechanically STALLED." \
  --type=task --priority=0 --assignee=<lane-actor-name>
```

Rules (from the tool's own workflow — `bd prime`):

1. The assignee claims with `bd update <id> --claim` (atomic; starts the lease).
2. While working, the assignee refreshes the lease with `bd heartbeat <id>`.
3. The verifier runs `bd stale` + `bd reclaim` on cadence; stale leases return to ready and are re-issued to a live lane.
4. Completion is `bd close <id> --reason="Artifact: <commit sha / file / URL>"` — and only after the verifier has read that artifact back at its source.
5. An issue that stays open and unclaimed past its deadline is STALLED. No narrative status overrides the tool's output.
