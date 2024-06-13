#!/usr/bin/env python3

# SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

"""list-extra-tag - List qubes that can be tagged for cacher"""

import qubesadmin
import qubesadmin.vm

def main():
    """main"""
    wanted_domains = ['debian', 'fedora', 'arch']
    ## TODO: remove after https://github.com/QubesOS/qubes-core-agent-linux/pull/504
    wanted_domains_extra = wanted_domains + ['kali', 'kicksecure', 'parrot',
                            'ubuntu', 'linuxmint', 'blackarch']
    domains = [
        vm.name
        for vm in qubesadmin.Qubes().domains
        if vm.klass == "TemplateVM"
            and "whonix-updatevm" not in vm.tags
            and (vm.features.get("os-distribution-like") in wanted_domains
                or vm.features.get("os-distribution") in wanted_domains_extra)
    ]
    print("\n".join(domains))


if __name__ == "__main__":
    main()
