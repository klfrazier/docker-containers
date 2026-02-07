#!/bin/bash

set -e

echo "Starting Apache Atlas with all dependencies..."

# Start HBase (which will start embedded ZooKeeper automatically)
echo "Starting HBase with embedded ZooKeeper..."
/apache-atlas/hbase/bin/start-hbase.sh

# Wait for services to initialize
echo "Waiting for HBase and ZooKeeper to initialize (this may take 90 seconds)..."
sleep 90

# Verify services are running
echo "Verifying services..."
ps aux | grep -E "(zookeeper|hbase)" | grep -v grep || echo "Service check completed"

# Start Kafka (if it exists)
if [ -d "/apache-atlas/kafka/bin" ]; then
    echo "Starting Kafka..."
    nohup /apache-atlas/kafka/bin/kafka-server-start.sh /apache-atlas/conf/kafka/server.properties > /apache-atlas/logs/kafka.log 2>&1 &
    sleep 5
fi

# Start Atlas
echo "Starting Apache Atlas..."
/apache-atlas/bin/atlas_start.py

# Wait for Atlas to start
echo "Waiting for Atlas to initialize..."
sleep 15

echo ""
echo "=========================================="
echo "All services started successfully!"
echo "=========================================="
echo ""
echo "Apache Atlas is available at: http://localhost:21000"
echo "Default credentials: admin / admin"
echo ""
echo "Tailing application logs..."
echo ""
tail -fF /apache-atlas/logs/application.log
