---
name: test-metalbear-services
description: Runs services locally with mirrord against their live deployments. Use to validate your changes and when asked to test them.
---

# Testing Metalbear services

To test the services in the operator repository, use the `down` tool.

`down` is a mirrord session orchestrator. It reads one declarative config, starts the selected services with a shared
session key and manages them together as one session.

## Prepare

From the root of the operator repository, do both of these before starting a session:

1. Read all of `.mirrord/down.yaml`. It is the source of truth for the available service names, startup order,
   readiness checks, commands and mirrord settings.
2. Run `down --help`. It is the source of truth for the CLI arguments, environment variables and how services are
   selected.

Refer back to both while you work.

Check that the staging Kubernetes context and any credentials that the selected services need are available. Don't
change shared staging resources by hand.

## Find information about mirrord

The local `docs` and `mirrord` repositories have what you need:

- For an overview of how to use a mirrord feature, read the documentation in the `docs/` folder of the `docs`
  repository, starting with `SUMMARY.md` to find the right page.
- For the mirrord config schema, read `mirrord-schema.json` at the root of the `mirrord` repository. It is the source of
  truth for config fields, their types and their descriptions.

## Check the shell environment

mirrord reads some config fields from environment variables, and an environment variable takes priority over the
config file. So if your shell has one of these variables set, mirrord silently ignores the value in the config file.
Before you start `down` or `mirrord`, run `env | grep -iE 'baggage|mirrord|kube'`, and remove each variable that you
didn't set on purpose by adding `env -u <variable>` to the command itself.

These variables are known to cause problems:

- `BAGGAGE`, which the `baggage` config field reads. The Claude app sets it for its own Sentry tracing, for example
  `BAGGAGE=sentry-environment=production,...`. The mirrord CLI then sends the wrong `baggage` header to the operator,
  so the operator's HTTP filter doesn't match and your sessions go to the staging operator instead of your local one.
  Nothing reports an error, because the session starts normally and your local operator simply gets no requests.

  Start `down`, `mirrord exec` and every other mirrord command with `env -u BAGGAGE`, for example
  `env -u BAGGAGE down operator`. Running `unset BAGGAGE` in an earlier command doesn't help, because each command can
  run in a new shell where the variable is back.
- `MIRRORD_*`, which many config fields read, for example `MIRRORD_KEY`, `MIRRORD_OPERATOR_ENABLE` and
  `MIRRORD_AGENT_NAMESPACE`. To find which field reads a variable, search for the variable's name in
  `mirrord/config/src` of the `mirrord` repository.
- `KUBECONFIG` and the current kube context. `down` and `mirrord` use the current context, which might not be the
  staging cluster. Rather than changing the global current context, write a separate kubeconfig for staging:

  ```sh
  kubectl config view --raw --minify --context=gke_metalbear-staging_us-central1_metalbear-staging > <scratch-dir>/kubeconfig
  ```

  Then set it on each `down` and `mirrord` command, for example
  `env -u BAGGAGE KUBECONFIG=<scratch-dir>/kubeconfig down operator`.

## Run a session

1. Choose a unique session key, and use that exact key for the whole test.
2. Identify every locally changed service in the request path.
3. Start `down` from the root of the operator repository, passing the selected service names. Leave them out only when
   the test needs every configured service.
4. Keep `down` running while you send test traffic, and wait for its configured readiness output before you start.
5. Send requests through the external staging endpoint with this header:

   ```text
   baggage: mirrord-session=<session-key>
   ```

   Don't use localhost or in-cluster service DNS for an end-to-end test. Baggage propagates through the calls between
   our services, which keeps the request in the same mirrord session.
6. When testing is done, stop `down` with `SIGTERM` and let it clean up all its child processes by itself.

## CLI-created Kubernetes resources

Most mirrord CLI calls go through the operator's APIService, where the baggage header and the HTTP filter keep
concurrent operators apart.

Database branching and preview environments work differently. The CLI creates custom resources that an operator then
reconciles, and the operators select these resources by the `operator.metalbear.co/owner` label, so HTTP filtering is
not enough.

When you test either feature with `down operator`, use the session key as `OPERATOR_ISOLATION_MARKER` in both places:

- `down` already sets the marker on the local operator from `{{key}}`.
- Set the same marker in the shell that runs the CLI command, such as `mirrord preview start` or a session that creates
  database branches.

Take extra care when one `down` command starts the operator together with another service. For example, the
operator-only override doesn't reach the `crm` process in `down operator crm`. If the local operator must handle CRM's
database branch, set `OPERATOR_ISOLATION_MARKER` to the session key on the outer `down` process, so that every service
process inherits it.

The values must match exactly. Without the marker, the CLI creates an unlabeled resource that the staging operator
picks up, and with a different marker, the local operator doesn't select the resource.

## Troubleshoot

If startup or routing fails:

1. Look at the prefixed service output first.
2. Add `--log info` if you need `down`'s own lifecycle logs.
3. Read the selected service entries in `.mirrord/down.yaml` again.

Don't work around `down` with manual `mirrord exec` commands.

If a session doesn't reach your local process, find out which operator or service got the request before you change
any code or config:

- Look for the session in the logs of the staging deployment, for example
  `kubectl -n mirrord logs deploy/mirrord-operator | grep "Session Start"`.
- Agent pods and sessions that your local operator creates have the `operator.metalbear.co/owner=<session-key>` label,
  while resources from the staging operator have `operator.metalbear.co/owner=mirrord-operator`.
- The internal proxy of the mirrord CLI prints the config it actually uses, including the final `baggage`, on startup.
  To write its log to a file, set `internal_proxy.log_destination` and `internal_proxy.log_level` in the config.
- Run `env | grep -iE 'baggage|mirrord|kube'` again, as described in
  [Check the shell environment](#check-the-shell-environment).
