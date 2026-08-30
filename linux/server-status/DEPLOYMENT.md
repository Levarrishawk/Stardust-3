# Public Core3 server status

This directory contains a privacy-safe public status feed and a small status page.
Do not copy Core3's `log/who.json` into the nginx document root: it includes account
IDs, IP addresses, character names, positions, and administrative information.

`publish_status` converts the private `who.json` into this stable public contract:

```json
{
  "schemaVersion": 1,
  "server": "TC",
  "status": "online",
  "playersOnline": 12,
  "uptimeSeconds": 12345,
  "updatedAt": "2026-08-30T12:34:56Z",
  "sourceUpdatedAt": "2026-08-30T12:34:48Z"
}
```

Valid states are `offline`, `loading`, `locked`, `online`, and `shutting_down`.
Consumers should treat a request failure, invalid response, or unknown state as
offline/unavailable.

## Core3 configuration

Set the following in the VPS copy of `MMOCoreORB/bin/conf/config.lua` so that the
private source is newer than the publisher's 120-second stale threshold:

```lua
OnlineLogSeconds = 30,
LogOnlineOnSessionChange = 1,
```

Core3 defaults `OnlineLogSeconds` to 300 when it is absent. A 300-second interval
would require a much longer stale threshold and make crash detection slow.

## VPS installation

The included systemd files use example paths. Adjust them to match the actual VPS
checkout and nginx document root before installing them.

1. Copy `publish_status` to `/opt/stardust/server-status/`.
2. Copy `index.html` to `/var/www/stardust/status/`.
3. Ensure `www-data` can traverse and read the Core3 `bin/log` directory and can
   write `/var/www/stardust/status/`.
4. Copy `core3-status.service` and `core3-status.timer` to `/etc/systemd/system/`.
5. Run `systemctl daemon-reload` and enable `core3-status.timer`.

An nginx location can serve the page and JSON with caching disabled for the feed:

```nginx
location /status/ {
    alias /var/www/stardust/status/;
    index index.html;
}

location = /status/status.json {
    alias /var/www/stardust/status/status.json;
    default_type application/json;
    add_header Cache-Control "no-store" always;
    add_header Access-Control-Allow-Origin "*" always;
}
```

Only enable `Access-Control-Allow-Origin: *` if browser-based consumers on other
origins need it. Native launcher and Discord integrations do not require CORS.

The timer continues running when Core3 stops. Once `who.json` is older than the
configured threshold, the publisher emits `offline` with zero players. This makes
shutdown and crash detection independent of the game-server process.

## Consumer guidance

The website, launcher, and Discord integration should all consume `status.json`,
not scrape the HTML page. Discord should retain its previous state and post only
when the state changes, which avoids repeatedly announcing the same condition.
