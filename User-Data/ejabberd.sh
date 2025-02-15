# Ivan Humara Miranda
#!/bin/bash

# Descargar los repositorios de ejabberd
sudo curl -o /etc/apt/sources.list.d/ejabberd.list https://repo.process-one.net/ejabberd.list
sudo curl -o /etc/apt/trusted.gpg.d/ejabberd.gpg https://repo.process-one.net/ejabberd.gpg

# Actualizar el sistema e instalar ejabberd
apt update
apt install ejabberd

sudo rm -rf /opt/ejabberd/conf/ejabberd.yml
sudo touch /opt/ejabberd/conf/ejabberd.yml

# Escribir la configuracion de el archivo
cat > "/opt/ejabberd/conf/ejabberd.yml" <<EOL

---
###
###              ejabberd configuration file
###
### The parameters used in this configuration file are explained at
###
###       https://docs.ejabberd.im/admin/configuration
###
### The configuration file is written in YAML.
### *******************************************************
### *******           !!! WARNING !!!               *******
### *******     YAML IS INDENTATION SENSITIVE       *******
### ******* MAKE SURE YOU INDENT SECTIONS CORRECTLY *******
### *******************************************************
### Refer to http://en.wikipedia.org/wiki/YAML for the brief description.
###

hosts:
  - "ivanhumara.duckdns.org"

loglevel: info

ca_file: /opt/ejabberd/conf/cacert.pem

certfiles:
  - /opt/ejabberd/conf/fullchain.pem
  - /opt/ejabberd/conf/privkey.pem
## If you already have certificates, list them here
# certfiles:
#  - /etc/letsencrypt/live/domain.tld/fullchain.pem
#  - /etc/letsencrypt/live/domain.tld/privkey.pem

listen:
  -
    port: 5222
    ip: "::"
    module: ejabberd_c2s
    max_stanza_size: 262144
    shaper: c2s_shaper
    access: c2s
    starttls_required: true
  -
    port: 5223
    ip: "::"
    module: ejabberd_c2s
    max_stanza_size: 262144
    shaper: c2s_shaper
    access: c2s
    tls: true
  -
    port: 5269
    ip: "::"
    module: ejabberd_s2s_in
    max_stanza_size: 524288
    shaper: s2s_shaper
    tls: true
  -
    port: 5270
    ip: "::"
    module: ejabberd_s2s_in
    max_stanza_size: 524288
    shaper: s2s_shaper
    tls: true
  -
    port: 5443
    ip: "::"
    module: ejabberd_http
    tls: true
    request_handlers:
      /admin: ejabberd_web_admin
      /api: mod_http_api
      /bosh: mod_bosh
      /captcha: ejabberd_captcha
      /upload: mod_http_upload
      /ws: ejabberd_http_ws
  -
    port: 5280
    ip: "::"
    module: ejabberd_http
    request_handlers:
      /admin: ejabberd_web_admin
      /.well-known/acme-challenge: ejabberd_acme
  -
    port: 5478
    ip: "::"
    transport: udp
    module: ejabberd_stun
    use_turn: true
    ## The server's public IPv4 address:
    turn_ipv4_address: "50.19.132.195"
    ## The server's public IPv6 address:
    # turn_ipv6_address: "2001:db8::3"
  -
    port: 1883
    ip: "::"
    module: mod_mqtt
    backlog: 1000

s2s_use_starttls: optional
acl:
  admin:
    user:
      - "admin@ivanhumara.duckdns.org"
  local:
    user_regexp: ""
  loopback:
    ip:
      - 127.0.0.0/8
      - ::1/128

access_rules:
  local:
    allow: local
  upload:
    - allow: all
  c2s:
    deny: blocked
    allow: all
  announce:
    allow: admin
  configure:
    allow: admin
  muc_create:
    allow: local
  pubsub_createnode:
    allow: local
  trusted_network:
    allow: loopback

api_permissions:
  "console commands":
    from: ejabberd_ctl
    who: all
    what: "*"
  "webadmin commands":
    from: ejabberd_web_admin
    who: admin
    what: "*"
  "admin access":
    who:
      access:
        allow:
          - acl: loopback
          - acl: admin
      oauth:
        scope: "ejabberd:admin"
        access:
          allow:
            - acl: loopback
            - acl: admin
    what:
      - "*"
      - "!stop"
      - "!start"
  "public commands":
    who:
      ip: 127.0.0.1/8
    what:
      - status
      - connected_users_number

shaper:
  normal:
    rate: 3000
    burst_size: 20000
  fast: 100000

shaper_rules:
  max_user_sessions: 10
  max_user_offline_messages:
    5000: admin
    100: all
  c2s_shaper:
    none: admin
    normal: all
  s2s_shaper: fast

modules:
  mod_adhoc: {}
  mod_admin_extra: {}
  mod_announce:
    access: announce
  mod_avatar: {}
  mod_blocking: {}
  mod_bosh: {}
  mod_caps: {}
  mod_carboncopy: {}
  mod_client_state: {}
  mod_configure: {}
  mod_disco: {}
  mod_fail2ban: {}
  mod_http_api: {}
  mod_http_upload:
    docroot: /opt/ejabberd_uploads
    put_url: "https://ivanhumara.duckdns.org/upload"
    access: all
    custom_headers:
      "Access-Control-Allow-Origin": "*"
      "Access-Control-Allow-Methods": "GET,HEAD,PUT,OPTIONS"
      "Access-Control-Allow-Headers": "Content-Type"
    max_size: 524288000
#  mod_http_upload:
#    docroot: /var/lib/ejabberd/upload
#    put_url: https://@HOST@:5443/upload
#    custom_headers:
#      "Access-Control-Allow-Origin": "https://@HOST@"
#      "Access-Control-Allow-Methods": "GET,HEAD,PUT,OPTIONS"
#      "Access-Control-Allow-Headers": "Content-Type"
  mod_last: {}
  mod_mam:
    ## Mnesia is limited to 2GB, better to use an SQL backend
    ## For small servers SQLite is a good fit and is very easy
    ## to configure. Uncomment this when you have SQL configured:
    ## db_type: sql
    assume_mam_usage: true
    default: always
  mod_mqtt: {}
  mod_muc:
    access:
      - allow
    access_admin:
      - allow: admin
    access_create: muc_create
    access_persistent: muc_create
    access_mam:
      - allow
    default_room_options:
      mam: true
  mod_muc_admin: {}
  mod_offline:
    access_max_user_messages: max_user_offline_messages
  mod_ping: {}
  mod_privacy: {}
  mod_private: {}
  mod_proxy65:
    access: all
    max_connections: 5
  mod_pubsub:
    access_createnode: pubsub_createnode
    plugins:
      - flat
      - pep
    force_node_config:
      ## Avoid buggy clients to make their bookmarks public
      storage:bookmarks:
        access_model: whitelist
  mod_push: {}
  mod_push_keepalive: {}
  mod_register:
    ## Only accept registration requests from the "trusted"
    ## network (see access_rules section above).
    ## Think twice before enabling registration from any
    ## address. See the Jabber SPAM Manifesto for details:
    ## https://github.com/ge0rg/jabber-spam-fighting-manifesto
    ip_access: trusted_network
  mod_roster:
    versioning: true
  mod_s2s_bidi: {}
  mod_s2s_dialback: {}
  mod_shared_roster: {}
  mod_stream_mgmt:
    resend_on_timeout: if_offline
  mod_stun_disco: {}
  mod_vcard: {}
  mod_vcard_xupdate: {}
  mod_version:
    show_os: false

### Local Variables:
### mode: yaml
### End:
### vim: set filetype=yaml tabstop=8
## Configuración de PostgreSQL
sql_type: pgsql
sql_server: "10.212.3.30"
sql_database: "ejabberd_db"
sql_username: "ejabberd"
sql_password: "Admin1"
sql_port: 5432
default_db: sql
EOL

sudo systemctl restart ejabberd
sudo systemctl status ejabberd