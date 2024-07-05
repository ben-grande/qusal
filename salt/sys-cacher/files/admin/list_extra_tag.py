#!/usr/bin/env python3

# SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

"""list-extra-tag - List qubes tagged for cacher incorrectly"""

import qubesadmin  # pylint: disable=import-error
import qubesadmin.vm  # pylint: disable=import-error

def main():  # pylint: disable=missing-function-docstring
    wanted_domains = ['debian', 'fedora', 'arch', 'ubuntu', 'kicksecure']
    domains = [
        vm.name
        for vm in qubesadmin.Qubes().domains
        if "updatevm-sys-cacher" in vm.tags
            and vm.features.check_with_template("os-distribution-like")
                not in wanted_domains
            and vm.features.check_with_template("os-distribution")
                not in wanted_domains
    ]
    print("\n".join(domains))


if __name__ == "__main__":
    main()
