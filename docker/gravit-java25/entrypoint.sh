#!/bin/bash
# Default the TZ environment variable to UTC.
TZ=${TZ:-UTC}
export TZ

# Set environment variable that holds the Internal Docker IP
INTERNAL_IP=$(ip route get 1 | awk '{print $(NF-2);exit}')
export INTERNAL_IP

# Switch to the container's working directory
cd /home/container || exit 1

# Gradle-generated bin/launchserver reads JAVA_OPTS. Compose it from Pterodactyl
# memory limit and terminal flags. Any user-provided JAVA_OPTS wins (appended last).
export JAVA_OPTS="-Xms128M -Xmx${SERVER_MEMORY}M -Dterminal.jline=false -Dterminal.ansi=true ${JAVA_OPTS:-}"

printf "\033[1m\033[33mcontainer@gravitlauncher~ \033[0mjava home\n"
echo "$JAVA_HOME"
printf "\033[1m\033[33mcontainer@gravitlauncher~ \033[0mjava -version\n"
java -version
printf "\033[1m\033[33mcontainer@gravitlauncher~ \033[0mJAVA_OPTS\n"
echo "$JAVA_OPTS"

# Convert all of the "{{VARIABLE}}" parts of the command into the expected shell
# variable format of "${VARIABLE}" before evaluating the string and automatically
# replacing the values.
PARSED=$(echo "${STARTUP}" | sed -e 's/{{/${/g' -e 's/}}/}/g' | eval echo "$(cat -)")

printf "\033[1m\033[33mcontainer@gravitlauncher~ \033[0m%s\n" "$PARSED"
# shellcheck disable=SC2086
exec ${PARSED}
