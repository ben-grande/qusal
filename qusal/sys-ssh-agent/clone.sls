{% from 'utils/macros/clone-template.sls' import clone_template -%}
{{ clone_template('debian-minimal', sls_path) }}
