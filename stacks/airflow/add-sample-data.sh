#!/bin/bash

# Script to add sample data to Apache Atlas via REST API

ATLAS_URL="http://localhost:21000"
USERNAME="admin"
PASSWORD="admin"

echo "Adding sample data to Apache Atlas..."
echo ""

# Create sample database entity
echo "Creating sample database..."
docker exec apache-atlas bash -c "cat > /tmp/sample_db.json << 'EOF'
{
  \"entity\": {
    \"typeName\": \"hive_db\",
    \"attributes\": {
      \"name\": \"sample_database\",
      \"clusterName\": \"primary\",
      \"qualifiedName\": \"sample_database@primary\",
      \"description\": \"Sample database created by quick start\"
    }
  }
}
EOF"

# Create sample table entity  
echo "Creating sample table..."
docker exec apache-atlas bash -c "cat > /tmp/sample_table.json << 'EOF'
{
  \"entity\": {
    \"typeName\": \"hive_table\",
    \"attributes\": {
      \"name\": \"sample_table\",
      \"qualifiedName\": \"sample_database.sample_table@primary\",
      \"db\": {
        \"typeName\": \"hive_db\",
        \"uniqueAttributes\": {
          \"qualifiedName\": \"sample_database@primary\"
        }
      },
      \"description\": \"Sample table created by quick start\",
      \"owner\": \"admin\",
      \"createTime\": $(date +%s)000,
      \"lastAccessTime\": $(date +%s)000,
      \"retention\": 0
    }
  }
}
EOF"

# Post the entities using wget (curl not available in container)
echo "Posting database entity..."
docker exec apache-atlas bash -c "wget --no-check-certificate --quiet \
  --method POST \
  --timeout=30 \
  --header 'Content-Type: application/json' \
  --header 'Authorization: Basic YWRtaW46YWRtaW4=' \
  --body-file=/tmp/sample_db.json \
  --output-document=/tmp/db_result.json \
  '${ATLAS_URL}/api/atlas/v2/entity' 2>&1"

echo "Database creation result:"
docker exec apache-atlas cat /tmp/db_result.json 2>/dev/null | head -20

echo ""
echo "Posting table entity..."
docker exec apache-atlas bash -c "wget --no-check-certificate --quiet \
  --method POST \
  --timeout=30 \
  --header 'Content-Type: application/json' \
  --header 'Authorization: Basic YWRtaW46YWRtaW4=' \
  --body-file=/tmp/sample_table.json \
  --output-document=/tmp/table_result.json \
  '${ATLAS_URL}/api/atlas/v2/entity' 2>&1"

echo "Table creation result:"
docker exec apache-atlas cat /tmp/table_result.json 2>/dev/null | head -20

echo ""
echo "Sample data creation completed!"
echo "Access Atlas UI at: ${ATLAS_URL}"
echo "Login with: ${USERNAME} / ${PASSWORD}"
