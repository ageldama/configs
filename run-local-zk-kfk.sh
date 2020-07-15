#!/bin/sh
SESSION=local-kafka

KAFKA_BASE=/home/jhyun/local/kafka

tmux new-session -s ${SESSION} -d

tmux split-window -t ${SESSION}:0 ${KAFKA_BASE}/bin/zookeeper-server-start.sh ${KAFKA_BASE}/config/zookeeper.properties

tmux split-window -t ${SESSION}:0 ${KAFKA_BASE}/bin/kafka-server-start.sh ${KAFKA_BASE}/config/server.properties

tmux select-pane -t ${SESSION}:0 -U
tmux select-pane -t ${SESSION}:0 -U

echo ${SESSION}
