#!/bin/bash
#
# Test the graph code
#

source "$REG_DIR/scaffold"

cmd setup_repo

shouldfail guilt graph

