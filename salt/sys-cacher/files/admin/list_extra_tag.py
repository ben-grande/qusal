#!/usr/bin/env python3

# SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

"""list-extra-tag - List qubes tagged for cacher incorrectly"""

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
        if "updatevm-sys-cacher" in vm.tags
            and vm.features.check_with_template("os-distribution-like")
                not in wanted_domains
            and vm.features.check_with_template("os-distribution")
                not in wanted_domains_extra
    ]
    print("\n".join(domains))


if __name__ == "__main__":
    main()
