# Example Project

This is an example of how to use Jest-Lua to create unit tests for a library.

For a setup guide, see the [Getting Started](https://jsdotlua.github.io/jest-lua/) documentation page.

## Running Tests

This example has [run-in-roblox](https://github.com/rojo-rbx/run-in-roblox) setup to allow you to run tests from the CLI.
To do so, run the `scripts/test.sh` script and it will open up studio and run your tests.

If you do not wish to use `run-in-roblox`, you can serve the project with Rojo by running the `scripts/dev.sh`.
Your tests will run and output the results when you run the server in Studio.

## Project Structure

You can find our `run-tests.luau` script in the `scripts` folder.
This is where we define our runCLI Options and our project directories for Jest.

The `jest.config.luau` file can be found in `src`, this is where we tell Jest what should be considered a test and other options.

The rest of the project has been setup for use with Darklua and String Requires, and provides scripts to make it simple to use.
The structure is based on [roblox-project-template](https://github.com/grilme99/roblox-project-template),
which provides a setup for a Roblox experience with Darklua and more.