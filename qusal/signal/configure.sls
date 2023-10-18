{% if grains['nodename'] != 'dom0' -%}

"{{ slsdotpath }}-create-autostart-dir":
  cmd.run:
    - name: mkdir -p ~/.config/autostart
    - runas: user

"{{ slsdotpath }}-desktop-autostart":
  cmd.run:
    - name: ln -sf /usr/share/applications/signal-desktop.desktop ~/.config/autostart/
    - runas: user

{% endif -%}
