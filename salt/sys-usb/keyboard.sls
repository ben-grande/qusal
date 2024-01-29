{#
SPDX-FileCopyrightText: 2018 - 2023 Marmarek Marczykowski-Gorecki <marmarek@invisiblethingslab.com>
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: GPL-3.0-or-later
#}

# Based on 'qvm.usb-keyboard', but can't use it because it requires
# 'qvm.sys-usb', which is different from the one we create at create.sls.
# Last known update of 'qvm.usb-keyboard': 2023-08-31

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
