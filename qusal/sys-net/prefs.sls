include:
  - .create

{% set default_netvm = salt['cmd.shell']('qubes-prefs default_netvm') -%}
"{{ slsdotpath }}-set-{{ default_netvm }}-netvm":
  qvm.vm:
    - require:
      - qvm: {{ slsdotpath }}
    - name: {{ default_netvm }}
    - prefs:
      - netvm: {{ slsdotpath }}

"{{ slsdotpath }}-clockvm":
  cmd.run:
    - require:
      - qvm: {{ slsdotpath }}
    - name: qubes-prefs clockvm {{ slsdotpath }}

{% from 'utils/macros/policy.sls' import policy_set with context -%}
{{ policy_unset(sls_path, '80') }}
