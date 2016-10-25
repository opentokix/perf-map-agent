#!/bin/bash
set -e
#set -x

CUR_DIR=`pwd`
PID=$1
OPTIONS=$2
ATTACH_JAR=attach-main.jar
PERF_MAP_DIR=$(dirname $(readlink -f $0))/..
ATTACH_JAR_PATH=$PERF_MAP_DIR/out/$ATTACH_JAR
PERF_MAP_FILE=/tmp/perf-$PID.map

USERNAME=$(cat /proc/${1}/status |grep Uid|cut -f 2)

if [ -z "$JAVA_HOME" ]; then
  JAVA_HOME=/usr/lib/jvm/default-java
fi

[ -d "$JAVA_HOME" ] || JAVA_HOME=/etc/alternatives/java_sdk
[ -d "$JAVA_HOME" ] || (echo "JAVA_HOME directory at '$JAVA_HOME' does not exist." && false)

rm $PERF_MAP_FILE -f
(cd $PERF_MAP_DIR/out && sudo -u $USERNAME java -cp $ATTACH_JAR_PATH:$JAVA_HOME/lib/tools.jar net.virtualvoid.perf.AttachOnce $PID "$OPTIONS")
chown root:root $PERF_MAP_FILE
