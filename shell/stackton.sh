#! /bin/bash

SERVICES_FILE="$HOME/Projects/StackTon/config.yml"

if [ ! -f "$SERVICES_FILE" ]; then
    docker-compose up -d
    exit 0
fi

if ! command -v yq &> /dev/null; then
    echo "you need to install yq to run this script"
    exit 1
fi

start_services() {
    execute_command "up -d"
}

stop_services() {
    execute_command "stop"
}

restart_services() {
    execute_command "restart"
}

execute_command() {
    enabled_services=$(yq e '.services | to_entries | .[] | select(.value == true) | .key' "$SERVICES_FILE")

    docker-compose $1 $enabled_services
}

case "$1" in
  up)
    start_services
    ;;
  stop)
    stop_services
    ;;
  restart)
    restart_services
    ;;
  *)
    echo "Usage: $0 {start|stop|restart}"
    exit 1
esac