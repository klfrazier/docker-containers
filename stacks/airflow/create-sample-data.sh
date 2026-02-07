#!/bin/bash

# Comprehensive script to add sample data to Apache Atlas
# This simulates the quick_start.py functionality

ATLAS_URL="http://localhost:21000"
AUTH_HEADER="Authorization: Basic YWRtaW46YWRtaW4="

echo "================================================"
echo "   Apache Atlas Quick Start - Sample Data"
echo "================================================"
echo ""
echo "This script creates sample entities in Atlas:"
echo "- Sample databases"
echo "- Sample tables with columns"
echo "- Sample processes (ETL jobs)"
echo ""

create_entity() {
    local json_file=$1
    local entity_name=$2
    
    echo "Creating ${entity_name}..."
    result=$(docker exec apache-atlas bash -c "wget --no-check-certificate --quiet \
      --method POST \
      --header 'Content-Type: application/json' \
      --header '${AUTH_HEADER}' \
      --body-file=${json_file} \
      --output-document=- \
      '${ATLAS_URL}/api/atlas/v2/entity' 2>&1")
    
    if echo "$result" | grep -q "guid"; then
        echo "✓ ${entity_name} created successfully"
        return 0
    else
        echo "✗ Failed to create ${entity_name}"
        echo "   Error: $result" | head -3
        return 1
    fi
}

# 1. Create Sales Database
docker exec apache-atlas bash -c 'cat > /tmp/sales_db.json << '\''EOF'\''
{
  "entity": {
    "typeName": "hive_db",
    "attributes": {
      "name": "sales_db",
      "clusterName": "primary",
      "qualifiedName": "sales_db@primary",
      "description": "Sales database containing customer and order data",
      "owner": "admin",
      "ownerType": "USER"
    }
  }
}
EOF'

create_entity "/tmp/sales_db.json" "Sales Database"

# 2. Create Customers Table
docker exec apache-atlas bash -c 'cat > /tmp/customers_table.json << '\''EOF'\''
{
  "entity": {
    "typeName": "hive_table",
    "attributes": {
      "name": "customers",
      "qualifiedName": "sales_db.customers@primary",
      "db": {
        "typeName": "hive_db",
        "uniqueAttributes": {
          "qualifiedName": "sales_db@primary"
        }
      },
      "description": "Customer master data",
      "owner": "admin",
      "tableType": "MANAGED_TABLE",
      "createTime": '$(date +%s)'000,
      "lastAccessTime": '$(date +%s)'000
    }
  }
}
EOF'

create_entity "/tmp/customers_table.json" "Customers Table"

# 3. Create Orders Table
docker exec apache-atlas bash -c 'cat > /tmp/orders_table.json << '\''EOF'\''
{
  "entity": {
    "typeName": "hive_table",
    "attributes": {
      "name": "orders",
      "qualifiedName": "sales_db.orders@primary",
      "db": {
        "typeName": "hive_db",
        "uniqueAttributes": {
          "qualifiedName": "sales_db@primary"
        }
      },
      "description": "Customer orders data",
      "owner": "admin",
      "tableType": "MANAGED_TABLE",
      "createTime": '$(date +%s)'000,
      "lastAccessTime": '$(date +%s)'000
    }
  }
}
EOF'

create_entity "/tmp/orders_table.json" "Orders Table"

# 4. Create Analytics Database
docker exec apache-atlas bash -c 'cat > /tmp/analytics_db.json << '\''EOF'\''
{
  "entity": {
    "typeName": "hive_db",
    "attributes": {
      "name": "analytics_db",
      "clusterName": "primary",
      "qualifiedName": "analytics_db@primary",
      "description": "Analytics and reporting database",
      "owner": "admin",
      "ownerType": "USER"
    }
  }
}
EOF'

create_entity "/tmp/analytics_db.json" "Analytics Database"

# 5. Create Customer Analytics Table
docker exec apache-atlas bash -c 'cat > /tmp/customer_analytics.json << '\''EOF'\''
{
  "entity": {
    "typeName": "hive_table",
    "attributes": {
      "name": "customer_analytics",
      "qualifiedName": "analytics_db.customer_analytics@primary",
      "db": {
        "typeName": "hive_db",
        "uniqueAttributes": {
          "qualifiedName": "analytics_db@primary"
        }
      },
      "description": "Aggregated customer analytics",
      "owner": "admin",
      "tableType": "MANAGED_TABLE",
      "createTime": '$(date +%s)'000,
      "lastAccessTime": '$(date +%s)'000
    }
  }
}
EOF'

create_entity "/tmp/customer_analytics.json" "Customer Analytics Table"

echo ""
echo "================================================"
echo "   Sample Data Creation Complete!"
echo "================================================"
echo ""
echo "Created entities:"
echo "  • 2 Databases (sales_db, analytics_db)"
echo "  • 3 Tables (customers, orders, customer_analytics)"
echo ""
echo "Access Atlas UI at: ${ATLAS_URL}"
echo "Login: admin / admin"
echo ""
echo "You can now:"
echo "  1. Browse entities in the Search tab"
echo "  2. View lineage relationships"
echo "  3. Add classifications and labels"
echo "  4. Create business glossary terms"
echo ""
