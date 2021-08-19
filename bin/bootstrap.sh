#!/bin/bash

# Usage: bootstrap.sh module
# Creates the boilerplate files for a module and updates jest.project.json.

mod_path="src/Submodules/$1"
pkg_name=$(echo $1 | sed 's/-/ /g' | awk '{for (i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2)} 1' | sed 's/ //g' )
mkdir -p $mod_path/src/__tests__
touch $mod_path/src/init.lua
cat > $mod_path/README.md << EOF
# $1

Status: :hammer: In Progress

Source: 

Version: 

---

### :pencil2: Notes

### :x: Excluded
\`\`\`
\`\`\`

### :package: [Dependencies]()
| Package | Version | Status | Notes |
| - | - | - | - |
EOF
cat > $mod_path/default.project.json << EOF
{
    "name": "$pkg_name",
    "tree": {
        "\$path": "src"
    }
}
EOF
cat > $mod_path/rotriever.toml << EOF
[package]
name = "$pkg_name"
version = { workspace = true }
license = { workspace = true }
author = "Roblox"
content_root = "src"
files = ["*", "!**/__tests__/**"]

[dependencies]

[dev_dependencies]
EOF