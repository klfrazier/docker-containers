# Running Apache Atlas Quick Start

## Issue with bin/quick_start.py

The `bin/quick_start.py` script requires console/TTY input for username and password, which doesn't work well in non-interactive environments or when running via Docker exec. The script calls Java code that uses `System.console()` which returns null in non-TTY contexts.

## Solution: REST API Alternative

Since the Python quick_start script has TTY limitations, I've created alternative scripts that use the Atlas REST API directly to create sample data.

## Available Scripts

### 1. create-sample-data.sh (Recommended)
A comprehensive script that creates a realistic set of sample entities:
- **Databases**: sales_db, analytics_db  
- **Tables**: customers, orders, customer_analytics, sample_table

**Usage:**
```bash
bash create-sample-data.sh
```

**Output:**
```
✓ Sales Database created successfully
✓ Customers Table created successfully
✓ Orders Table created successfully
✓ Analytics Database created successfully
✓ Customer Analytics Table created successfully
```

### 2. add-sample-data.sh (Simple)
A minimal script that creates basic sample entities:
- 1 Database: sample_database
- 1 Table: sample_table

**Usage:**
```bash
bash add-sample-data.sh
```

## What Was Created

After running `create-sample-data.sh`, you now have:

### Databases (3 total)
- `sample_database@primary` - Initial test database
- `sales_db@primary` - Sales database with customer data
- `analytics_db@primary` - Analytics and reporting database

### Tables (4 total)
- `sales_db.customers@primary` - Customer master data
- `sales_db.orders@primary` - Customer orders data  
- `analytics_db.customer_analytics@primary` - Aggregated analytics
- `sample_database.sample_table@primary` - Initial test table

## Accessing the Data

### Via Web UI
1. Navigate to http://localhost:21000
2. Login with `admin` / `admin`
3. Go to the **Search** tab
4. Select entity type (e.g., "hive_table")
5. Browse your sample entities

### Via REST API
```bash
# List all databases
docker exec apache-atlas wget --quiet --header 'Authorization: Basic YWRtaW46YWRtaW4=' \
  --output-document=- 'http://localhost:21000/api/atlas/v2/search/basic?typeName=hive_db'

# List all tables  
docker exec apache-atlas wget --quiet --header 'Authorization: Basic YWRtaW46YWRtaW4=' \
  --output-document=- 'http://localhost:21000/api/atlas/v2/search/basic?typeName=hive_table'
```

## Why quick_start.py Doesn't Work

The original `bin/quick_start.py` script:
1. Uses Python's `input()` function to prompt for credentials
2. Calls Java `org.apache.atlas.examples.QuickStartV2` class
3. The Java code uses `System.console()` which requires a real TTY
4. In Docker exec or non-interactive shells, `System.console()` returns null
5. This causes the "Couldn't get a console object for user input" error

## Benefits of REST API Approach

✅ Works in any environment (Docker, scripts, CI/CD)  
✅ No TTY required  
✅ Easier to customize and extend  
✅ Can be version controlled as JSON files  
✅ More transparent - you see exactly what's being created  

## Next Steps

Now that you have sample data, you can:

1. **Explore Lineage**: View relationships between entities
2. **Add Classifications**: Tag entities with PII, sensitive data, etc.
3. **Create Glossary**: Define business terms and link to entities
4. **Set up Lineage**: Create process entities showing data flow
5. **Configure Security**: Set up authorization and access controls

## Files Created

- `create-sample-data.sh` - Comprehensive sample data script
- `add-sample-data.sh` - Simple sample data script
- `run-quickstart.sh` - Attempted Python wrapper (has TTY issues)
- `QUICK_START_GUIDE.md` - This document
