#!/bin/bash
#
# Test the graph code
#

function fixup_time_info
{
	cmd guilt pop
	touch -a -m -t "$TOUCH_DATE" ".git/patches/a,graph/$1"
	cmd guilt push
}

source "$REG_DIR/scaffold"

cmd setup_repo

shouldfail guilt graph

cmd git checkout -b a,graph master

cmd guilt init

cmd guilt new a.patch

fixup_time_info a.patch
cmd guilt graph

cmd echo a >> file.txt
cmd git add file.txt
cmd guilt refresh
fixup_time_info a.patch
cmd guilt graph

# An unrelated file. No deps.
cmd guilt new b.patch
cmd echo b >> file2.txt
cmd git add file2.txt
cmd guilt refresh
fixup_time_info b.patch
cmd guilt graph

# An change to an old file. Should add a dependency.
cmd guilt new c.patch
cmd echo c >> file.txt
cmd git add file.txt
cmd guilt refresh
fixup_time_info c.patch
cmd guilt graph
