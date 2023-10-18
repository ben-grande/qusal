include:
  - dotfiles.copy-git
  - dotfiles.copy-x11

"{{ slsdotpath }}-updated":
  pkg.uptodate:
    - refresh: True

"{{ slsdotpath }}-installed":
  pkg.installed:
    - refresh: True
    - install_recommends: False
    - skip_suggestions: True
    - pkgs:
      - git

"{{ slsdotpath }}-install-client-git-core-dir":
  file.recurse:
    - source: salt://{{ slsdotpath }}/files/client/git-core
    - name: /usr/lib/git-core
    - file_mode: '0755'
    - dir_mode: '0755'
    - user: root
    - group: root
    - makedirs: True
    - recurse:
      - mode
      - user
      - group
