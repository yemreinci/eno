#!/usr/bin/env python3
import sys
import json

# Read all stdin
stdin_content = sys.stdin.read()

# Create a ConfigMap with the stdin content
configmap = {
    "apiVersion": "v1",
    "kind": "ConfigMap",
    "metadata": {
        "name": "mirror-output",
        "namespace": "default"
    },
    "data": {
        "myStdin": stdin_content
    }
}

# Wrap in ResourceList
resource_list = {
    "apiVersion": "config.kubernetes.io/v1",
    "kind": "ResourceList",
    "items": [configmap]
}

# Output as JSON
print(json.dumps(resource_list))
