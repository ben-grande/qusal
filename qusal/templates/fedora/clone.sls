{%- import "templates/fedora.jinja" as template -%}

"{{ template.template }}-template-installed":
  qvm.template_installed:
    - name: {{ template.template }}
    - fromrepo: {{ template.repo }}
