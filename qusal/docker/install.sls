{% if grains['nodename'] != 'dom0' -%}

{% from 'utils/macros/install-repo.sls' import install_repo -%}
{{ install_repo(sls_path, 'docker') }}

"{{ slsdotpath }}-updated":
  pkg.uptodate:
    - refresh: True

{#
"{{ slsdotpath }}-removed":
  pkg.removed:
    - pkgs:
      {% if grains['os_family']|lower == 'debian' -%}
      - docker.io
      - docker-doc
      - docker-compose
      - podman-docker
      - containerd
      - runc
      {% elif grains['os_family']|lower == 'redhat' -%}
      - docker
      - docker-client
      - docker-client-latest
      - docker-common
      - docker-latest
      - docker-latest-logrotate
      - docker-logrotate
      - docker-selinux
      - docker-engine-selinux
      - docker-engine
      {% endif -%}
#}

"{{ slsdotpath }}-installed":
  pkg.installed:
    - refresh: True
    - install_recommends: False
    - skip_suggestions: True
    - pkgs:
      - qubes-core-agent-networking
      - man-db
      - docker-ce
      - docker-ce-cli
      - containerd.io
      - docker-buildx-plugin
      - docker-compose-plugin

"{{ slsdotpath }}-user-in-docker-group":
  user.present:
    - name: user
    - groups:
      - user
      - qubes
      - docker

{% endif -%}
