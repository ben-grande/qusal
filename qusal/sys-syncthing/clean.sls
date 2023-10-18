"{{ slsdotpath }}-shutdown":
  qvm.shutdown:
    - name: {{ slsdotpath }}
    - flags:
      - force

{% from 'utils/macros/policy.sls' import policy_unset with context -%}
{{ policy_unset(sls_path, '80') }}
