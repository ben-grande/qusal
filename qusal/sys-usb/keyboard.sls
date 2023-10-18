# Based on 'qvm.usb-keyboard'.

include:
  - .create

"{{ slsdotpath }}-updated-dom0":
  pkg.uptodate:
    - refresh: True

"{{ slsdotpath }}-installed-dom0":
  pkg.installed:
    - pkg:
      - qubes-input-proxy

"{{ slsdotpath }}-input-proxy-keyboard":
  file.managed:
    - require:
      - qvm: {{ slsdotpath }}
      - pkg: installed-dom0
    - name: /etc/qubes/policy.d/80-{{ slsdotpath }}.policy
    - source: salt://{{ slsdotpath }}/files/policy/default.policy
    - user: root
    - group: qubes
    - mode: '0664'

{% set uefi_xen_cfg = '/boot/efi/EFI/qubes/xen.cfg' %}
{% if grains['boot_mode'] == 'efi' %}
{% set grub_cfg = '/boot/efi/EFI/qubes/grub.cfg' %}
{% else %}
{% set grub_cfg = '/boot/grub2/grub.cfg' %}
{% endif %}

"{{ slsdotpath }}-unhide-usb-from-dom0-uefi":
  file.replace:
    - name: {{ uefi_xen_cfg }}
    - pattern: ' rd.qubes.hide_all_usb'
    - repl: ' usbcore.authorized_default=0'
    - onlyif: test -f {{ uefi_xen_cfg }}

"{{ slsdotpath }}-unhide-usb-from-dom0-grub":
  file.replace:
    - name: /etc/default/grub
    - pattern: ' rd.qubes.hide_all_usb'
    - repl: ' usbcore.authorized_default=0'
    - onlyif: test -f /etc/default/grub

"{{ slsdotpath }}-grub-regenerate-unhide":
  cmd.run:
    - name: grub2-mkconfig -o {{ grub_cfg }}
    - onchanges:
      - file: unhide-usb-from-dom0-grub
    - onlyif: test -f {{ grub_cfg }}
