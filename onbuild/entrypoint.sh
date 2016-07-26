#!/usr/bin/env bash

if [ "$1" == "bootstrap" ] ; then
    echo "You can replace this entrypoint.sh script and customize it to fire eventstore and run"
    echo "some commands on it to configure streams, projections and subscriptions thus having"
    echo "a virgin eventstore instance ready to deploy with the right setup for your needs."
    echo ""
    echo ""
    echo "Basicaly you just have to wrap you es-cli and/or curl setup commands around that "
    echo "kind of script template:"
    echo ""
cat <<EOF
#!/usr/bin/env bash
set -e
BASIC_AUTH=admin:changeit

eventstored -SkipDbVerify 0<&- &>/dev/null &
PID=$!
NB_TRY=0;
echo -n "INFO: wait for eventstore to be available"
while ! curl -o /dev/null -sf http://localhost:2113/projections/continuous
do
    NB_TRY=\$((NB_TRY+1));
    if [ \$NB_TRY -gt 100 ]
    then
        echo >&2 "ERROR: eventore never started correctly after \$NB_TRY trials."
        kill -9 \$PID || exit 2
    fi
    sleep 0.05 && echo -n .
done;
echo "INFO: eventstore is available, configuring it."

# YOU SETUP COMMANDS HERE

curl -sqfL -u \${BASIC_AUTH} -H 'Accept: application/json' -H 'Content-Length: 0' -X POST 'http://localhost:2113/admin/shutdown'
wait \$PID
sync
set +x
echo "INFO: eventstore successfully bootstraped and shutdown."
EOF
else
    echo "NOTE:"
    echo "THIS CONTAINER IS FOR DEVELOPMENT PURPOSES ONLY AND SHOULD NOT BE USED IN PRODUCTION"
    echo ""

    exec eventstored
fi
