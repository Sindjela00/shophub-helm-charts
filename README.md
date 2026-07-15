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

## Related repositories

- `shophub-app`, `shophub-shop` — application source
- `shophub-shop-operator` — operator source (CRD definitions and controllers)
- `shophub-kube-state` — pins which chart version + values are applied to the cluster
