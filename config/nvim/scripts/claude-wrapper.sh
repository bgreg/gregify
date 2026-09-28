#!/bin/bash
# Claude Code wrapper script for Neovim
# Adds --dangerously-skip-permissions flag to Claude Code CLI

exec claude --dangerously-skip-permissions "$@"
