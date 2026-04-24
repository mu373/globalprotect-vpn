# globalprotect-vpn

Dockerized [GlobalProtect](https://github.com/yuezk/GlobalProtect-openconnect) client, exposed over SSH so an SSH client can use it as a jump host or SOCKS proxy.

## Setup

On the docker host:

1. `cp .env.example .env` and set `GP_PORTAL` to your GlobalProtect portal hostname.
2. Put authorized SSH public key(s) in `authorized_keys` (one per line).
3. `docker compose up -d --build`

## Connect / disconnect

Run on the docker host:

```sh
./gp-up      # connect (first run: complete SSO in a browser)
./gp-down    # disconnect
```

On first run, `gp-up` prints an `ssh -L ...` command. Run it from the client, open the printed `http://localhost:PORT/...` URL in a browser, complete SSO, then paste the resulting `globalprotectcallback:...` string back into the `gp-up` terminal. Tokens are cached in the `gp-state` volume, so later runs are silent.

## Using the VPN from a client

Example `~/.ssh/config`:

```ssh-config
# The VPN container (docker host, port 2222).
Host vpn
    HostName docker-host.example.com
    Port 2222
    User vpnuser
    IdentityFile ~/.ssh/id_ed25519

# Same, plus a SOCKS proxy on localhost:1080.
Host vpn-socks
    HostName docker-host.example.com
    Port 2222
    User vpnuser
    IdentityFile ~/.ssh/id_ed25519
    DynamicForward 1080

# A server behind the VPN, jumped through the container.
Host target
    HostName target.internal.example
    User youruser
    ProxyJump vpn
```

Then `ssh vpn`, `ssh vpn-socks`, or `ssh target`.
