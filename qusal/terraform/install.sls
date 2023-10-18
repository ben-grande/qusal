{% if grains['nodename'] != 'dom0' -%}

{% from 'utils/macros/install-repo.sls' import install_repo -%}
{{ install_repo(sls_path, 'terraform') }}

"{{ slsdotpath }}-updated":
  pkg.uptodate:
    - refresh: True

"{{ slsdotpath }}-installed":
  pkg.installed:
    - refresh: True
    - install_recommends: False
    - skip_suggestions: True
    - pkgs:
      - qubes-core-agent-networking
      - terraform
      - openssh-client
      - vim
      - man-db

{% endif -%}
