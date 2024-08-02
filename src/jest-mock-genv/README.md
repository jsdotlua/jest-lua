# jest-mock-genv

*No upstream. Roblox only.*

This module houses the `GlobalMocker` class, the type definitions used for global
mocking utilities, and the `MOCKABLE_GLOBALS` constant which determines the global
environment members that are allowed to be mocked.

## :pencil2: Notes

- **Changing `MOCKABLE_GLOBALS` should be done with care.**
    - By whitelisting a new global to be mocked, you may subtly affect any code
      which uses that global, or allow users to do the same.
        - Jest only generates mock functions for the globals that are
          whitelisted, and doesn't generate anything for globals that are not
          whitelisted. This can subtly change how a global appears to user code.
        - Possible breakage will need to be investigated.
    - Adding a new global to this list is not breaking, but removing a global
      from this list *is* breaking.
        - It is better to be selective than to be generous, because if the
          whitelisting causes breakage, it's might be hard to undo.
        - We also don't want to encourage bad practice, and mocking certain
          globals could lead to unintended use cases which aren't idiomatic or
          cause problems for ourselves later.
    - Certain globals are not safe to mock right now, including task scheduling
      functions and `require()`, because they already have customised
      implementations in Jest that would be bypassed.
        - This can probably be fixed down the line if there's a pressing need to
          do it, but it would introduce more complexity.
    - **Above all else, come talk to us first - we will help you 🙂** 
- The `GlobalMocker` class does not implement any mocking capabilities itself;
  instead, mock functions are stored in `GlobalMocker` by a `ModuleMocker`.
- Globals should *always* be mocked whenever a test is running, because the
  test's sandbox environment redirects to these mock functions at all times -
  even if the user has not used `spyOn`.
    - This ensures that all modules can see mocked implementations, even if they
      are required later than the call to `spyOn` which mocks the global.
