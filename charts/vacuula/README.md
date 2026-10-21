# vacuula

Helm chart for [Vacuula](https://github.com/vacuula/vacuula), a self-hosted replacement for the Neato cloud.

Requires robots provisioned with Vacuula installer 1.1.0 or later. Re-install robots that an older installer set up.

## Services

- `service`: web UI and API (`http`). Default `ClusterIP`. Ingress and HTTPRoute target it.
- `robotService` (`<fullname>-robots`): robot endpoints, default `LoadBalancer`. Robots verify the CA that Vacuula generates, so expose these ports at L4. Do not put a TLS-terminating or passthrough proxy in front.
  - `gen3` (`vacuula.gen3Port`, default 335) when `vacuula.gen3Enabled`, `gen4` (`vacuula.gen4Port`) when `vacuula.gen4Enabled`.
  - `http` when `robotService.http.enabled`. The Vacuula installer talks only plain HTTP (`/api/cert`, `/api/server`) to the IP that the robot uses later. Enable it while you provision robots, then disable it.
