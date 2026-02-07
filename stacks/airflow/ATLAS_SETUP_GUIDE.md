# Apache Atlas Container - Fixed Configuration

## Problem Solved
The Apache Atlas container was failing with ZooKeeper connection errors:
```
WARN - ReadOnlyZKClient-localhost:2181 ~ failed for list of /hbase, code = CONNECTIONLOSS
```

## Root Cause
The issue was that ZooKeeper and HBase weren't being started before Apache Atlas. The `sburn/apache-atlas` image requires HBase (with embedded ZooKeeper) to be running before Atlas starts.

## Solution
Created a custom startup script (`atlas-startup.sh`) that:
1. Starts HBase with embedded ZooKeeper
2. Waits 90 seconds for complete initialization
3. Starts Apache Atlas
4. Tails the application logs

## Usage

### Start Apache Atlas
```bash
docker-compose up -d
```

The container will take approximately 2-3 minutes to fully start all services.

### Check Status
```bash
docker logs apache-atlas
```

### Access Apache Atlas
- URL: http://localhost:21000
- Default Username: `admin`
- Default Password: `admin`

### Stop Apache Atlas
```bash
docker-compose down
```

### Stop and Remove Data
```bash
docker-compose down -v
```

## Services Included
- **Apache Atlas** (port 21000) - Data governance and metadata management
- **HBase** - Backend storage
- **ZooKeeper** (embedded) - Coordination service
- **Solr** (embedded) - Search backend
- **Kafka** (embedded) - Event notification

## Files Created
- `docker-compose.yml` - Docker Compose configuration
- `atlas-startup.sh` - Custom startup script that starts services in correct order

## Startup Time
- Total startup time: ~2-3 minutes
- HBase + ZooKeeper initialization: ~90 seconds
- Atlas initialization: ~30-60 seconds

## Health Check
The container includes a health check that monitors the Atlas web server. You can check the health status with:
```bash
docker ps
```
Look for "healthy" in the STATUS column.
