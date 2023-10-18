{% if grains['nodename'] != 'dom0' -%}

include:
  - dev.home-cleanup
  - dotfiles.copy-x11
  - dotfiles.copy-ssh

"{{ slsdotpath }}-client-updated":
  pkg.uptodate:
    - refresh: True

"{{ slsdotpath }}-client-installed":
  pkg.installed:
    - refresh: True
    - install_recommends: False
    - skip_suggestions: True
    - pkgs:
      - qubes-core-agent-networking
      - ca-certificates
      - socat
      {% if grains['os_family']|lower == 'debian' -%}
      - libpam-systemd
      - procps
      - openssh-client
      {% elif grains['os_family']|lower == 'redhat' -%}
      - systemd-pam
      - procps-ng
      - openssh-clients
      {% endif -%}

"{{ slsdotpath }}-client-user-systemd-dir":
  file.recurse:
    - source: salt://{{ slsdotpath }}/files/client/systemd/
    - name: /usr/lib/systemd/user/
    - dir_mode: '0755'
    - file_mode: '0644'
    - user: root
    - group: root

"{{ slsdotpath }}-client-start-systemd-dbus-login-service":
  service.running:
    - name: dbus-org.freedesktop.login1.service

"{{ slsdotpath }}-client-start-systemd-user-services-on-boot":
  cmd.run:
    - require:
      - service: "{{ slsdotpath }}-client-start-systemd-dbus-login-service"
    - name: loginctl enable-linger user

{% endif %}
