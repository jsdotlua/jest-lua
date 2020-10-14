<h1 align="center">TestEZ</h1>
<div align="center">
	<a href="https://github.com/Roblox/testez/actions?query=workflow%3ACI">
		<img src="https://github.com/Roblox/testez/workflows/CI/badge.svg" alt="GitHub Actions Build Status" />
	</a>
	<a href="https://roblox.github.io/testez">
		<img src="https://img.shields.io/badge/docs-website-green.svg" alt="Documentation" />
	</a>
</div>

<div align="center">
	BDD-style Roblox Lua testing framework
</div>

<div>&nbsp;</div>

TestEZ can run within Roblox itself, as well as inside [Lemur](https://github.com/LPGhatguy/Lemur) for testing on CI systems.

We use TestEZ at Roblox for testing our apps, in-game core scripts, built-in Roblox Studio plugins, as well as libraries like [Roact](https://github.com/Roblox/roact) and [Rodux](https://github.com/Roblox/rodux).

It provides an API that can run all of your tests with a single method call as well as a more granular API that exposes each step of the pipeline.

## Inspiration and Prior Work
The `describe` and `it` syntax in TestEZ is based on the [Behavior-Driven Development](https://en.wikipedia.org/wiki/Behavior-driven_development) methodology, notably as implemented in RSpec (Ruby), busted (Lua), Mocha (JavaScript), and Ginkgo (Go).

The `expect` syntax is based on Chai, a JavaScript assertion library commonly used with Mocha. Similar expectation systems are also used in RSpec and Ginkgo, with slightly different syntax.

---

## Running Lest tests
You need to create a GitHub Access Token:
* GitHub.com -> Settings -> Developer Settings -> Personal Access Tokens
* On that same page, you then need to click Enable SSO
* BE SURE TO COPY THE ACCESS TOKEN SOMEWHERE 

```
npm login --registry=https://npm.pkg.github.com/ --scope=@roblox
```
For your password here, you will enter the GitHub Access Token from the instructions above.

```
npm install --global @roblox/rbx-aged-cli
```

Before you can use rbx-aged-cli, you need to be logged into the VPN so the Artifactory repository is accessible.

```
mkdir ~/bin
rbx-aged-cli download roblox-cli --dst ~/bin
export PATH=$PATH:~/bin
roblox-cli --help
git clone git@github.com:Roblox/roact-alignment.git
cd roact-alignment
roblox-cli analyze modules/scheduler/lest.project.json
```

Foreman uses Rust, so you'll have to install Rust first.

```
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
export PATH=$PATH:$HOME/.cargo/bin
cargo install foreman
foreman github-auth  # your auth token should be in your ~/.npmrc
foreman install
export PATH=$PATH:~/.foreman/bin/
```

Now you can run the tests, edit code, and contribute!

```
rotrieve install
rojo build lest.project.json --output model.rbxmx
roblox-cli run --load.model model.rbxmx --run bin/spec.lua
```

---

## Contributing
Contributions are welcome! See [CONTRIBUTING.md](CONTRIBUTING.md) for information.

This is a disconnected fork of [Roblox/testez](https://github.com/Roblox/testez). Changes should be reviewed and tested here. [raymondnumbergenerator/testez](https://github.com/raymondnumbergenerator/testez) serves as an intermediary between this repo and the master fork. To push changes to the master fork of TestEZ, first add [raymondnumbergenerator/testez](https://github.com/raymondnumbergenerator/testez) as upstream and push changes there.

## License
TestEZ is available under the Apache 2.0 license. See [LICENSE](LICENSE) for details.
