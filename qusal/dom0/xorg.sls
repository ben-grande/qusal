{% if grains['nodename'] == 'dom0' -%}

"{{ slsdotpath }}-xorg-updated":
  pkg.uptodate:
    - refresh: True

"{{ slsdotpath }}-xorg-allow-custom-xsession-login":
  pkg.installed:
    - pkgs:
      - xorg-x11-xinit-session

"{{ slsdotpath }}-xorg-tap-to-touch":
  file.managed:
    - name: /etc/X11/xorg.conf.d/30-touchpad.conf
    - source: salt://{{ slsdotpath }}/files/xorg.conf.d/30-touchpad.conf
    - user: root
    - group: root
    - mode: '0644'

{% endif -%}
