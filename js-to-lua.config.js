module.exports = {
    lastSync: {
        ref: "63e506b5d1558a9132a8fa65151407b0a40be3a5",
        conversionToolVersion: "ee85735b8dcec492526c85830d5d9fc6fc42f2a0"
    },
    upstream: {
        owner: "facebook",
        repo: "jest",
        primaryBranch: "main"
    },
    downstream: {
        owner: "roblox",
        repo: "jest-roblox",
        primaryBranch: "master",
        patterns: [
            "src/**/*.lua"
        ]
    },
    renameFiles: [
        [
            (filename) => filename.includes("output/packages/"),
            (filename) => filename.replace("output/packages/", "output/src/")

        ],
        [
            (filename) => filename.endsWith(".test.lua"),
            (filename) => filename.replace(".test.lua", ".spec.lua")

        ],
        [
            (filename) => filename.endsWith(".test.ts.lua"),
            (filename) => filename.replace(".test.ts.lua", ".spec.snap.lua")
        ],
        [
            (filename) => filename.endsWith(".ts.lua") && !filename.endsWith(".test.ts.lua"),
            (filename) => filename.replace(".ts.lua", ".spec.snap.lua")
        ],
        [
            (filename) => filename.endsWith("index.lua") && !filename.endsWith("jest-globals/src/index.lua"),
            (filename) => filename.replace("index.lua", "init.lua")
        ],
        [
            (filename) => filename.endsWith(".snap.lua") && !filename.endsWith(".spec.snap.lua"),
            (filename) => filename.replace(".snap.lua", ".spec.snap.lua")
        ],
        [
            (filename) => filename.endsWith("init.spec.lua") || filename.endsWith("init.spec.snap.lua"),
            (filename) => filename.replace("/init.spec", "/index.spec")
        ],
    ]
}
