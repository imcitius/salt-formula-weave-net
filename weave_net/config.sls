---

{% from "weave_net/map.jinja" import lookup, weave_net with context %}

{% if weave_net.peers.addresses is not none %}
{% set peer_ipaddrs = weave_net.peers.addresses %}
{% else %}
{% set peer_ipaddrs = salt["mine.get"](
  weave_net.peers.target,
  weave_net.peers.mine_name,
  tgt_type=weave_net.peers.target_type
) %}
{% endif %}

write envfile weave:
  file.managed:
    - source: salt://weave_net/templates/weave.j2
    - name: {{ lookup.env_file }}
    - user: root
    - group: root
    - mode: 0750
    - template: jinja
    - context:
        log_level: {{ weave_net.log_level }}
        peers: {{ peer_ipaddrs | tojson }}
        secrets: {{ weave_net.secrets | tojson }}