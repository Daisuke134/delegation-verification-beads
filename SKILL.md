# Verify Delegated Execution Lands

> **Mechanical layer superseded by Beads (2026-11-25, founder rule "copy the tool 100%").**
> The ledger of record for every delegation is now **Beads (`bd`)** — gastownhall/beads, ★29,042 — wired at `~/workspace/delegation-ledger/` (binary `~/workspace/tools/beads/bd`, prefix `del`).
> Claim / activity / stall / completion are judged ONLY by Beads' own state model: `bd update <id> --claim` (atomic claim + lease), `bd heartbeat` (lease refresh = activity proof), `bd stale` + `bd reclaim` (dead-worker detection and recovery), `bd close --reason` (completion, reason carries the artifact reference, verified on origin before closing).
> A delegation with no beads issue does not exist; a delegation whose beads issue is open/unclaimed past its deadline is STALLED — no narrative status overrides the tool's output.
> This skill remains the judgment layer (smoke-test the channel, read the landed artifact in full, take over on failure). Where this checklist and the beads workflow differ, beads wins.
> Full record: anicca-ops `files/delegation-verification-tool-2026-11-25.md`.

## Smoke test the channel first

- Run one small harmless job through the exact binary, route, and worktree you plan to delegate to before you send real work through it.

- Record the smoke test result with its duration, its token or resource use, and the file or commit it landed.

- Treat a channel that lands nothing on the smoke test as broken and fix the channel itself before delegating, rather than sending the real job and waiting.

- Check known channel traps before the first real run, such as a binary on the path that lacks a helper it needs, a worker that waits on standard input, and a repository instruction file that makes the worker stop and ask instead of executing.

## Watch activity, not acknowledgement

- Count a delegation as started only when you have seen fresh activity and resource use, never from an acknowledgement, a claim, or a queued status alone.

- Check the run log and the target folder or branch within the first few minutes for new output, and check again at the deadline named in the brief.

- Read zero resource use as not running, however confident the acknowledgement sounded.

- Record each check with the time, what you observed, and the artifact path or commit you saw, so a later session can follow the same trail.

## Verify the artifact on arrival

- Open the landed artifact itself and read its full content or diff before you report the delegation as done.

- Confirm the artifact sits where the team can reach it, such as a pushed shared file, a commit on the named branch, or a live public URL.

- Compare the artifact against the brief outcome, not against the effort the worker reports.

- List what you could not confirm beside the result and mark it unconfirmed instead of filling the gap with a plausible value.

## Take over when the check fails

- Stop the failed delegation once the check shows no activity or no artifact, and do not leave it running on hope.

- Fix the channel fault the check exposed, rerun the smoke test, and only then resend the work.

- Take the work over yourself or hand it to one named replacement owner when the channel cannot be repaired quickly, and record the change of owner where the team tracks live work.

- Write the fault and its fix into the owning loop body or skill the same day, so the next delegation through that channel starts from the repaired form.

## Available connectors

- Use `muse.connector_search` to find other connectors and `muse.skill_search` to find related skills.

- If nothing here fits, look on the web for a maintained API or MCP server and set it up with [Custom Connectors and MCPs](/opt/muse/skills/custom-connector-setup/SKILL.md), or build a custom connector.

## Alternatives for better results

- Pair this check with the five part brief from `agent_brief_template`, so the worker receives a clear outcome and you verify against that same outcome.

- When a channel has failed before, stop that delegation first, then send the work once through one named replacement channel and verify that channel the same way.

## Verification (mandatory, added 2026-11-17)

This skill is itself a verification procedure, so its own verdicts are verified too. Structure follows the house verification block (invariants / grader / E2E / oracle).

1. **Invariants.** (a) No delegation is reported "running" without a timestamped observation of fresh activity and nonzero resource use; an acknowledgement, a claim, or a queued status never counts. (b) No delegation is reported "done" until the landed artifact has been opened and read in full by the verifier. (c) Every check leaves a written record — time, what was observed, artifact path or commit — that a later session can re-walk without asking anyone.
2. **Grader.** A different agent, or a later session, re-walks the recorded trail and must reach the same verdict from the records alone. If the trail cannot reproduce the verdict, the verdict was never verified.
3. **E2E evidence.** The smoke test is the evidence for the channel: one small harmless job must land a real file or commit through the exact binary, route, and worktree before any real work is sent through it. A channel that lands nothing on the smoke test is broken, however healthy it looks.
4. **Differential oracle.** The brief's named outcome is the oracle; the landed artifact is diffed against that outcome, not against the effort or the confidence in the worker's report.
5. **Repeat failures.** A channel that fails the smoke test twice is marked broken in the owning loop body or skill the same day, with the fault and the fix written down — never retried silently a third time.
