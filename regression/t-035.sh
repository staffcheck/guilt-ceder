#!/bin/bash
#
# Test the fold code
#

source "$REG_DIR/scaffold"

cmd setup_repo

function fixup_time_info
{
	cmd guilt pop
	touch -a -m -t "$TOUCH_DATE" ".git/patches/master/$1"
	cmd guilt push
}

function test_fold
{
    using_diffstat=$1

    cmd git config guilt.diffstat $using_diffstat

    # Empty message + empty message = empty message.
    echo "%% empty + empty (diffstat=$using_diffstat)"
    cmd guilt new empty-1
    fixup_time_info empty-1
    cmd guilt new empty-2
    fixup_time_info empty-2
    cmd guilt pop
    cmd guilt fold empty-2
    fixup_time_info empty-1
    cmd list_files
    cmd guilt pop
    cmd guilt delete -f empty-1
    cmd list_files

    # Empty message + non-empty message
    echo "%% empty + non-empty (diffstat=$using_diffstat)"
    cmd guilt new empty
    fixup_time_info empty
    cmd guilt new -f -s -m "A commit message." non-empty
    fixup_time_info non-empty
    cmd guilt pop
    cmd guilt fold non-empty
    fixup_time_info empty
    cmd list_files
    cmd guilt pop
    cmd guilt delete -f empty
    cmd list_files

    # Non-empty message + empty message
    echo "%% non-empty + empty (diffstat=$using_diffstat)"
    cmd guilt new -f -s -m "A commit message." non-empty
    fixup_time_info non-empty
    cmd guilt new empty
    cmd guilt pop
    cmd guilt fold empty
    fixup_time_info non-empty
    cmd list_files
    cmd guilt pop
    cmd guilt delete -f non-empty
    cmd list_files

    # Non-empty message + non-empty message
    echo "%% non-empty + non-empty (diffstat=$using_diffstat)"
    cmd guilt new -f -s -m "A commit message." non-empty-1
    fixup_time_info non-empty-1
    cmd guilt new -f -s -m "Another commit message." non-empty-2
    fixup_time_info non-empty-2
    cmd guilt pop
    cmd guilt fold non-empty-2
    fixup_time_info non-empty-1
    cmd list_files
    cmd guilt pop
    cmd guilt delete -f non-empty-1
    cmd list_files
}

test_fold true
test_fold false
