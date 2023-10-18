{% if grains['nodename'] != 'dom0' -%}

"{{ slsdotpath }}-core-updated":
  pkg.uptodate:
    - refresh: True

"{{ slsdotpath }}-core-installed":
  pkg.installed:
    - refresh: True
    - install_recommends: False
    - skip_suggestions: True
    - pkgs:
      - qubes-core-agent-networking
      - qubes-core-agent-passwordless-root
      - bash-completion
      - make
      - rpmlint
      - rpm
      - licensecheck
      - devscripts
      {% if grains['os_family']|lower == 'debian' -%}
      - equivs
      - dctrl-tools
      - build-essential
      - debhelper
      - quilt
      - lintian
      - mmdebstrap
      {% elif grains['os_family']|lower == 'redhat' -%}
      - rpmdevtools
      - rpm-sign
      - rpm-build
      - fedora-packager
      - fedora-review
      {% endif -%}

{% endif -%}
