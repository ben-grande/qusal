#!/usr/bin/env python3

# SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

"""list-extra-tag - List qubes that can be tagged for cacher"""

import qubesadmin  # pylint: disable=import-error
import qubesadmin.vm  # pylint: disable=import-error

def main():  # pylint: disable=missing-function-docstring
    wanted_domains = ['debian', 'fedora', 'arch', 'ubuntu', 'kicksecure']
    domains = [
        vm.name
        for vm in qubesadmin.Qubes().domains
        if vm.klass == "TemplateVM"
            and "whonix-updatevm" not in vm.tags
            and (vm.features.get("os-distribution-like") in wanted_domains
                or vm.features.get("os-distribution") in wanted_domains)
    ]
    print("\n".join(domains))


if __name__ == "__main__":
    main()
