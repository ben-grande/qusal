# SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

## Load all rules
all

## List indentation
rule "MD007", :indent => 4

## Line length
rule "MD013", :line_length => 78, :ignore_code_blocks => true, :tables => false

## List order
rule "MD029", :style => :ordered

## Space after list markers
rule "MD030", :ul_single => 3, :ol_single => 2, :ul_multi => 3, :ol_multi => 2

## In-line HTML
exclude_rule "MD033"
