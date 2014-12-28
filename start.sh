#!/bin/bash

function handle_signal {
  PID=$!
  echo "received signal. PID is ${PID}"
  kill -s SIGHUP $PID
}

trap "handle_signal" SIGINT SIGTERM SIGHUP

echo "* checking mumble-server.ini"
if [ ! -f /config/mumble-server.ini ]; then
	echo "    * mumble-server.ini doesn't exist."
	echo "    * creating default mumble-server.ini"
	cp -f /assets/mumble-server.ini /config/mumble-server.ini
	echo "    * Setting Default password."
	/usr/sbin/murmurd -ini /config/mumble-server.ini -supw $SUPER_PASSWORD
	sleep 3
	echo
	echo "# ------------------------------------------------------------------------------"
	echo "# SuperUser Password"
	echo "#"
	echo "# Password: $SUPER_PASSWORD"
	echo "#"
	echo "# Connect to the server as SuperUser and setup an admin user."
	echo "# ------------------------------------------------------------------------------"
	echo
fi

echo "* starting mumble-server"
/usr/sbin/murmurd -fg -ini /config/mumble-server.ini & wait
echo "* stopping mumble-server"
