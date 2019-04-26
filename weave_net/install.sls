---

{% from "weave_net/map.jinja" import lookup, weave_net with context %}

fetch latest weave-net release:
  file.managed:
    - source: https://github.com/weaveworks/weave/releases/download/{{ weave_net.version }}/weave
    - name: /usr/local/bin/weave
    - skip_verify: true
    - user: root
    - group: root
    - mode: 0755

write systemd weave.service:
  file.managed:
    - source: salt://weave_net/templates/weave.service.j2
    - name: /lib/systemd/system/weave.service
    - user: root
    - group: root
    - mode: 0640
    - template: jinja
    - context:
        env_file: {{ lookup.env_file | yaml_squote }}
        weave_net: {{ weave_net | tojson }}
  module.run:
    - name: service.systemctl_reload
    - onchanges:
      - file: write systemd weave.service

systemd drop-in weave.service.d:
  file.directory:
    - name: /lib/systemd/system/weave.service.d
    - user: root
    - group: root
    - mode: 0644
