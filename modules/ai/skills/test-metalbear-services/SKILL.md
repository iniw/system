---
name: test-metalbear-services
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

## Check the shell environment

mirrord reads some config fields from environment variables, and an environment variable has priority over the
config file. If your shell has one of these variables, mirrord ignores the value in the config file, and it does not
tell you. Before you start `down` or `mirrord`, run `env | grep -iE 'baggage|mirrord|kube'`. Remove each variable that
you did not set on purpose with `env -u <variable>` on the command itself.

Known problems:

- `BAGGAGE`: the `baggage` config field reads it. The Claude app sets it for its own Sentry tracing, for example
  `BAGGAGE=sentry-environment=production,...`. The mirrord CLI then sends the wrong `baggage` header to the operator,
  so the operator HTTP filter does not match. Your sessions go to the staging operator, not to your local operator.
  There is no error: the session starts, but your local operator gets no requests. Start `down`, `mirrord exec` and
  all other mirrord commands with `env -u BAGGAGE`, for example `env -u BAGGAGE down operator`. Do not use `unset
  BAGGAGE` in an earlier command: each command can run in a new shell, so the variable can come back.
- `MIRRORD_*`: many config fields read a `MIRRORD_*` variable (for example `MIRRORD_KEY`,
  `MIRRORD_OPERATOR_ENABLE`, `MIRRORD_AGENT_NAMESPACE`). To find which field reads a variable, search for the
  name of the variable in `mirrord/config/src` of the `mirrord` repository.
- `KUBECONFIG` and the current kube context: `down` and `mirrord` use the current context. It is possibly not the
  staging cluster. Do not change the global current context. Write a separate kubeconfig for staging:

  ```sh
  kubectl config view --raw --minify --context=gke_metalbear-staging_us-central1_metalbear-staging > <scratch-dir>/kubeconfig
  ```

  Set it on each `down` and `mirrord` command, for example
  `env -u BAGGAGE KUBECONFIG=<scratch-dir>/kubeconfig down operator`.

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

## Troubleshoot

If startup or routing fails, inspect the prefixed service output first. Use `--log info` when down's own lifecycle logs
are needed. Re-read the selected service entries in `.mirrord/down.yaml`; do not bypass `down` with manual `mirrord
exec` commands.

If a session does not reach your local process, find which operator or service got the request before you change
code or config:

- Look for the session in the logs of the staging deployment, for example `kubectl -n mirrord logs
  deploy/mirrord-operator | grep "Session Start"`.
- Agent pods and sessions that your local operator creates have the `operator.metalbear.co/owner=<session-key>`
  label. Resources from the staging operator have `operator.metalbear.co/owner=mirrord-operator`.
- The internal proxy of the mirrord CLI prints the config that it really uses (with the final `baggage`) on
  startup. To write its log to a file, set `internal_proxy.log_destination` and `internal_proxy.log_level` in the
  config.
- Run `env | grep -iE 'baggage|mirrord|kube'` again. See [Check the shell environment](#check-the-shell-environment).
