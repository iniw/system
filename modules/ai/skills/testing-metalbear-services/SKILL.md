---
name: testing-metalbear-services
description: Runs services locally with mirrord against their live deployments. Use to validate your changes and when asked to test them.
---

# Testing Metalbear Services

To test the services in the operator repository, the `down` tool should be used.

`down` is a mirrord session orchestrator. It reads one declarative config, starts the selected services with a
shared session key and manages them as one session.

## Prepare

From the operator repository root, do both of these before starting a session:

1. Read all of `.mirrord/down.yaml`. It is the source of truth for available service names, startup order, readiness
checks, commands, and mirrord settings.
2. Run `down --help`. It is the source of truth for CLI arguments, environment variables and service selection behavior.

Use the contents of these as references.

Confirm that the staging Kubernetes context and any service-specific credentials needed by the selected commands are
available. Do not change shared staging resources by hand.

## Find information about mirrord

Use the local `docs` and `mirrord` repositories:

- For an overview of how to use a specific mirrord feature, read the documentation in the `docs/` folder of the `docs`
  repository. Start with `SUMMARY.md` to find the correct page.
- For the mirrord config schema, read `mirrord-schema.json` at the root of the `mirrord` repository. It is the source of
  truth for config fields, their types and their descriptions.

## Run a session

1. Choose a unique session key. Reuse the exact key for the full test.
2. Identify every locally changed service in the request path.
3. Start `down` from the operator repository root. Pass the selected service names, or omit them only when the test
needs every configured service.
4. Keep `down` running while sending test traffic. Wait for its configured readiness output before testing.
5. Send requests through the external staging endpoint with this header:

   ```text
   baggage: mirrord-session=<session-key>
   ```

   Do not use localhost or in-cluster service DNS for an end-to-end test. Baggage propagates through calls between our
services, which keeps the request in the same mirrord session.
6. Stop `down` with `SIGTERM` when testing is complete. Let it clean up all child processes by itself.

If startup or routing fails, inspect the prefixed service output first. Use `--log info` when down's own lifecycle logs
are needed. Re-read the selected service entries in `.mirrord/down.yaml`; do not bypass `down` with manual `mirrord
exec` commands.

## CLI-created Kubernetes resources

Most mirrord CLI calls use the operator's APIService. The baggage header and HTTP filter isolate these calls between
concurrent operators.

Database branching and preview environments are different. The CLI creates custom resources that an operator then
reconciles. The operators use the `operator.metalbear.co/owner` label to select these resources, so HTTP filtering is
not sufficient.

When testing either feature with `down operator`, use the session key as `OPERATOR_ISOLATION_MARKER` in both places:

- `down` already sets the marker on the local operator from `{{key}}`.
- Set the same marker in the shell that runs the CLI command, such as `mirrord preview start` or a session that creates
  database branches.

This needs extra care when one `down` command starts the operator and another service. For example, the operator-only
override does not reach the `crm` process in `down operator crm`. If the local operator must handle CRM's database
branch, set `OPERATOR_ISOLATION_MARKER` to the session key on the outer `down` process. All service processes then
inherit it.

The values must match exactly. Without the marker, the CLI creates an unlabeled resource for the staging operator.
With a different marker, the local operator does not select the resource.
