#!/bin/bash

# Script to run Apache Atlas Quick Start
# This loads sample data into Atlas

echo "Running Apache Atlas Quick Start..."
echo "This will load sample data into Atlas."
echo ""

# Copy the script into the container and run it
docker exec -i apache-atlas bash << 'CONTAINER_EOF'
cd /apache-atlas/bin

# Create a Python wrapper that provides credentials automatically
cat > /tmp/run_quickstart.py << 'PYTHON_EOF'
#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import os

# Mock the console input by replacing sys.stdin
class MockStdin:
    def __init__(self, inputs):
        self.inputs = inputs
        self.index = 0
    
    def readline(self):
        if self.index < len(self.inputs):
            result = self.inputs[self.index] + '\n'
            self.index += 1
            return result
        return ''

# Replace stdin with mock that provides credentials
sys.stdin = MockStdin(['admin', 'admin'])

# Import and run the actual quick_start module
sys.path.insert(0, '/apache-atlas/bin')

try:
    import atlas_config as mc
    import atlas_client_cmdline as cmdline
    
    conf_dir = cmdline.setup_conf_dir()
    jvm_opts_list = cmdline.setup_jvm_opts_list(conf_dir, 'quick_start.log')
    atlas_classpath = cmdline.get_atlas_classpath(conf_dir)
    
    # Add stdin redirect for Java process
    os.environ['ATLAS_USERNAME'] = 'admin'
    os.environ['ATLAS_PASSWORD'] = 'admin'
    
    process = mc.java("org.apache.atlas.examples.QuickStartV2", [], atlas_classpath, jvm_opts_list)
    returncode = process.wait()
    
    if returncode == 0:
        print("\nSample data added to Apache Atlas Server successfully!")
    else:
        print("\nFailed to add sample data to Apache Atlas Server.")
        
    sys.exit(returncode)
    
except Exception as e:
    print("Exception: %s " % str(e))
    import traceback
    traceback.print_exc()
    sys.exit(-1)
PYTHON_EOF

# Run the wrapper script
python /tmp/run_quickstart.py

CONTAINER_EOF

echo ""
echo "Quick Start completed."
echo "You can now access Atlas at http://localhost:21000 with admin/admin"
