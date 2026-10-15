# vacuula

Helm chart for [Vacuula](https://github.com/vacuula/vacuula), a self-hosted replacement for the Neato cloud.

## Services

- `service`: web UI and API (`http`). Default `ClusterIP`. Ingress and HTTPRoute target it.
- `robotService` (`<fullname>-robots`): robot endpoints, default `LoadBalancer`. Robots verify the CA that Vacuula generates, so expose these ports at L4. Do not put a TLS-terminating or passthrough proxy in front.
  - `gen3` (443) when `vacuula.gen3Enabled`, `gen4` (`vacuula.gen4Port`) when `vacuula.gen4Enabled`.
  - `http` when `robotService.http.enabled`. The Vacuula installer talks only plain HTTP (`/api/cert`, `/api/server`) to the IP that the robot uses later. Enable it while you provision robots, then disable it.

## Gen3 map uploads

Gen3 robots upload maps and logs to `vacuula-local-<ip>.nip.io`. Vacuula takes `<ip>` from `host.docker.internal` if that name resolves, else from the pod IP. Point it at the `robotService` IP:

```yaml
hostAliases:
  - ip: 192.0.2.10
    hostnames:
      - host.docker.internal
```
