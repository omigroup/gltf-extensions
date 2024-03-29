#!/usr/bin/env bash

# This script ensures proper POSIX text file formatting and a few other things.

# We need dos2unix and isutf8.
if [ ! -x "$(command -v dos2unix)" -o ! -x "$(command -v isutf8)" ]; then
    printf "Install 'dos2unix' and 'isutf8' (moreutils package) to use this script.\n"
    exit 1
fi

set -uo pipefail
IFS=$'\n\t'

# Loops through all text files tracked by Git.
git grep -zIl '' |
while IFS= read -rd '' f; do
    # Ensure that files are UTF-8 formatted.
    isutf8 "$f" >> utf8-validation.txt 2>&1
    # Ensure that files have LF line endings and do not contain a BOM.
    dos2unix "$f" 2> /dev/null
    # Remove trailing space characters and ensures that files end
    # with newline characters. -l option handles newlines conveniently.
    perl -i -ple 's/\s*$//g' "$f"
    # Disallow empty lines after the opening brace.
    sed -z -i 's/\x7B\x0A\x0A/\x7B\x0A/g' "$f"
    # Disallow some empty lines before the closing brace.
    sed -z -i 's/\x0A\x0A\x7D/\x0A\x7D/g' "$f"
done

diff=$(git diff --color)

if [ ! -s utf8-validation.txt ] && [ -z "$diff" ] ; then
    # If no UTF-8 violations were collected (the file is empty) and
    # no diff has been generated all is OK, clean up, and exit.
    printf "\e[1;32m*** Files in this commit comply with the file formatting rules.\e[0m\n"
    rm -f utf8-validation.txt
    exit 0
fi

if [ -s utf8-validation.txt ]
then
    # If the file has content and is not empty, violations
    # detected, notify the user, clean up, and exit.
    printf "\n\e[1;33m*** The following files contain invalid UTF-8 character sequences:\e[0m\n\n"
    cat utf8-validation.txt
fi

rm -f utf8-validation.txt

if [ ! -z "$diff" ]
then
    # A diff has been created, notify the user, clean up, and exit.
    printf "\n\e[1;33m*** The following changes must be made to comply with the formatting rules:\e[0m\n\n"
    # Perl commands replace trailing spaces with `·` and tabs with `<TAB>`.
    printf "$diff\n" | perl -pe 's/(.*[^ ])( +)(\e\[m)$/my $spaces="·" x length($2); sprintf("$1$spaces$3")/ge' | perl -pe 's/(.*[^\t])(\t+)(\e\[m)$/my $tabs="<TAB>" x length($2); sprintf("$1$tabs$3")/ge'
fi

printf "\n\e[1;91m*** Please fix your commit(s) with 'git commit --amend' or 'git rebase -i <hash>'\e[0m\n"
exit 1
