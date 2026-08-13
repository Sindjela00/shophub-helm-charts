# shophub-helm-charts

Helm charts authored for the ShopHub project. Required by spec 5.3 to live in their own
repository, separate from the application source repos.

## Structure

```
shophub-helm-charts
├── README.md
└── charts/
    ├── shop-operator/       # deploys the Shop operator + installs its CRDs
    │   ├── Chart.yaml
    │   ├── values.yaml
    │   └── templates/
    │       ├── crds/        # Shop/Wallet/DiscordChannel CRDs (see charts/shop-operator's own note on why
    │       │                # these live under templates/ instead of Helm's crds/ directory)
    │       ├── NOTES.txt
    │       ├── _helpers.tpl
    │       ├── clusterrole.yaml
    │       ├── clusterrolebinding.yaml
    │       ├── deployment.yaml
    │       ├── discord-secret.yaml
    │       └── serviceaccount.yaml
    └── shophub/             # deploys ShopHub, wired to the operator's CRDs and kube-prometheus-stack
        ├── Chart.yaml
        ├── values.yaml
        ├── charts/          # subchart dependencies (e.g. kube-prometheus-stack)
        └── templates/
            ├── NOTES.txt
            ├── _helpers.tpl
            ├── deployment.yaml
            ├── hpa.yaml
            ├── ingress.yaml
            ├── service.yaml
            └── serviceaccount.yaml
```

## Charts

- **shop-operator** — installs the operator Deployment/RBAC and the `Shop`, `DiscordChannel`,
  and `Wallet` CRDs (spec 3.2).
- **shophub** — installs the ShopHub app and depends on
  [kube-prometheus-stack](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack)
  for the observability stack (spec 3.3).

Individual Shop app instances are not deployed via a static chart in this repo — they are
created dynamically at runtime through the `Shop` CRD from the `shop-operator` chart.

## Versioning

Each chart's `version` (in `Chart.yaml`) follows [Semantic Versioning](https://semver.org/),
independently of the app/operator's own release version and of the other chart in this repo —
a fix to `shophub`'s ingress template doesn't bump `shop-operator`'s version. What counts as a
change:

- **Patch** (`0.1.0` → `0.1.1`): template-only fixes that don't change the chart's public
  contract — a wrong label, a missing `nindent`, a bug in rendering — where existing
  `values.yaml` files continue to work unchanged.
- **Minor** (`0.1.0` → `0.2.0`): backward-compatible additions — a new value with a sensible
  default, a new optional template, a new CRD field. Existing `values.yaml` files still work;
  new capabilities are opt-in.
- **Major** (`0.1.0` → `1.0.0`): breaking changes — a renamed or removed value, a value whose
  meaning changed, a template whose output changed in a way that could break an existing
  release on `helm upgrade` (e.g. changing an immutable field, renaming a resource that other
  things reference).

`appVersion` (also in `Chart.yaml`) is independent of chart `version` — it tracks the
default image tag the chart deploys (`ghcr.io/sindjela00/shophub-shop-operator` /
`ghcr.io/sindjela00/shophub-shop`) and is bumped whenever that default changes, regardless of
whether the chart's own templates changed at all.

## Related repositories

- `shophub-app`, `shophub-shop` — application source
- `shophub-shop-operator` — operator source (CRD definitions and controllers)
- `shophub-kube-state` — pins which chart version + values are applied to the cluster
