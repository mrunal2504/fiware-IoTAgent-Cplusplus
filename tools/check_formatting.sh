#!/usr/bin/env python

import subprocess
output = subprocess.check_output(["git", "clang-format", "--diff"])

if output not in ['no modified files to format\n', 'clang-format did not modify any files\n']:
    print "Run git clang-format, then commit.\n"
    exit(1)
else:
    exit(0)

