#!/bin/bash
# Purpose: Create a user and force password change on first login
# OS     : Ubuntu 22.04 / 24.04

set -e

# READ INPUTS
read -p "Enter username: " USER_NAME
read -p "Enter full name: " FULL_NAME
read -s -p "Enter temporary password: " TEMP_PASSWORD
echo

# CREATE USER
useradd -m -c "$FULL_NAME" "$USER_NAME"
echo "User '$USER_NAME' created."

# SET TEMP PASSWORD
echo "${USER_NAME}:${TEMP_PASSWORD}" | chpasswd
echo "Temporary password set."

# FORCE PASSWORD CHANGE
# -d 0  : force password change at next login
# -E -1 : ensure account never expires (prevents PAM edge cases)
chage -d 0 "$USER_NAME"
echo "Password change enforced at first login."

# VERIFY STATUS
echo
echo "Verification:"
passwd -S "$USER_NAME"
chage -l "$USER_NAME" | grep -E "Last password change|Password expires"
