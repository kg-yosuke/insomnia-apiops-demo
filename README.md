# Insomnia APIOps Demo — KongAir Flights API

A sample APIOps pipeline with **Insomnia / Inso CLI**, **decK** and **Kong Konnect** on GitHub Actions.

```
Pull Request ─▶ inso lint spec ─▶ inso run collection (mock) ─▶ deck openapi2kong + add-plugins
             ─▶ deck file lint (governance) ─▶ deck gateway diff ─▶ PR comment

main         ─▶ (same build) ─▶ deck gateway sync (staging) ─▶ inso run collection (staging)
             ─▶ approval ─▶ deck gateway sync (production) ─▶ inso run collection (smoke)
```

## Files

| Path | Purpose |
|---|---|
| `openapi.yaml` | API spec (source of truth). Upstream = Insomnia Cloud Mock |
| `.spectral.yaml` | API design rules used by Insomnia and `inso lint spec` |
| `insomnia/flights-tests.yaml` | Insomnia collection with after-response tests and environments (`mock` / `staging` / `production`). Import it into Insomnia to edit |
| `kong/plugins.yaml` | Gateway policies added to the generated config (rate-limiting, correlation-id) |
| `kong/governance.yaml` | `deck file lint` rules (HTTPS upstream, rate-limiting required) |
| `.github/workflows/apiops.yaml` | The pipeline |

## Setup

Secrets: `KONNECT_PAT`

Variables: `KONNECT_ADDR` (e.g. `https://us.api.konghq.com`), `STAGING_CP`, `PRODUCTION_CP`, `STAGING_PROXY_URL`, `PRODUCTION_PROXY_URL`

Environments: `staging`, `production` (add required reviewers to `production`)

## Run locally

```bash
inso lint spec ./openapi.yaml
inso run collection wrk_flights_tests -w insomnia/flights-tests.yaml --env env_mock
deck file openapi2kong -s openapi.yaml | deck file add-plugins kong/plugins.yaml | deck file add-tags flights-api -o kong.yaml
deck file lint -s kong.yaml kong/governance.yaml
```
