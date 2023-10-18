{% from 'utils/macros/clone-template.sls' import clone_template -%}
{{ clone_template('fedora-minimal', sls_path) }}
