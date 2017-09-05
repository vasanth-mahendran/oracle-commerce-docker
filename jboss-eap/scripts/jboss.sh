#!/bin/bash

NOK=1
OK=0

function start {
  echo "staring JBOSS"
  export JBOSS_OPTS="${JBOSS_OPTS} -Djboss.server.log.dir=/var/log/jboss"
  export JBOSS_OPTS="${JBOSS_OPTS} -Djboss.bind.address.management=${HOSTNAME}"
  export JBOSS_OPTS="${JBOSS_OPTS} -Datg.dynamo.server.name=atginstance"
  export JBOSS_OPTS="${JBOSS_OPTS} -b ${HOSTNAME}"
  if [ -d "/srv/jboss/config" ]; then
    export JBOSS_OPTS="${JBOSS_OPTS} -Datg.dynamo.data-dir=/srv/jboss/config"
  fi
  ${JBOSS_HOME}/bin/standalone.sh --server-config=standalone.xml ${JBOSS_OPTS}
}

function stop {
  echo "stopping JBOSS"
  ${JBOSS_HOME}/bin/jboss-cli.sh --connect command=:shutdown
}

function usage {
  echo "usage: jboss.sh stop|start|status"
}

function status {
  echo "======================================"
  echo " JBOSS home: ${JBOSS_HOME}"
  echo " JVM: `which java`"
  echo " PROCESS: `ps -ef | grep jboss`"
  echo "======================================"
}

if [ $# -lt 1 ]; then
  usage
  exit ${NOK}
fi

case $1 in
  start)
    start
  ;;

  stop)
    stop
  ;;

  *)
    usage
    exit ${NOK}
  ;;
esac

exit ${OK}
