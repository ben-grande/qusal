#!/usr/bin/env python3

# SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

"""list-extra-tag - List qubes that can be tagged for cacher"""

import argparse
import qubesadmin  # pylint: disable=import-error
import qubesadmin.vm  # pylint: disable=import-error

def get_clients(qubes, wanted_dist, extraneous=False):
    """Get qubes tagged for ACNG"""
    domains = []
    for qube in qubes.domains:  # pylint: disable=invalid-name
        if qube.klass == "TemplateVM" and "whonix-updatevm" not in qube.tags:
            os_dist = qube.features.get("os-distribution")
            os_dist_like = qube.features.get("os-distribution-like")
            if os_dist_like is not None:
                os_dist_like_list = os_dist_like.split()

            if extraneous and "updatevm-sys-cacher" in qube.tags:
                if (os_dist not in wanted_dist \
                    and os_dist_like is None) \
                    or (os_dist_like is not None and
                    not any(domain in os_dist_like_list
                            for domain in wanted_dist
                    )
                ):
                    domains.append(qube.name)
            else:
                if os_dist in wanted_dist:
                    domains.append(qube.name)
                elif os_dist_like is not None:
                    os_dist_like_list = os_dist_like.split()
                    if any(
                        domain in os_dist_like_list
                        for domain in wanted_dist
                    ):
                        domains.append(qube.name)

    return domains


def main():  # pylint: disable=missing-function-docstring
    parser = argparse.ArgumentParser(description="List cacher tagged qubes")
    parser.add_argument("--extraneous", action="store_true",
                        help="List only extraneously tagged qubes")
    args = parser.parse_args()

    wanted_dist = ["debian", "fedora", "arch", "ubuntu", "kicksecure"]
    qubes = qubesadmin.Qubes()
    domains = get_clients(qubes, wanted_dist, extraneous=args.extraneous)
    print("\n".join(domains))


if __name__ == "__main__":
    main()
