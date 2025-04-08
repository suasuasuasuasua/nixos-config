#!/usr/bin/env bash

# This script is used to generate gpg keys according to GitHub's docs
#
# Source: https://docs.github.com/en/authentication/managing-commit-signature-verification/generating-a-new-gpg-key

# Generate the key
#
# Follow all of the prompts thoroughly
gpg --full-generate-key

# List the keys
#
# For example,
#
# $ gpg --list-secret-keys --keyid-format=long
# /Users/hubot/.gnupg/secring.gpg
# ------------------------------------
# sec   4096R/3AA5C34371567BD2 2016-03-10 [expires: 2017-03-10]
# uid                          Hubot <hubot@example.com>
# ssb   4096R/4BB6D45482678BE3 2016-03-10
gpg --list-secret-keys --keyid-format=long

# Finally, run this!
echo "Run this command 'gpg --armor --export \${KEY_IN_QUESTION}' to get the public key"
