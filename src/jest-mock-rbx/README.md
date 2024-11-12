# jest-mock-rbx

*No upstream. Roblox only.*

This package implements Jest's data model mocking capabilities for Roblox:

* `InstanceProxy`, used for constructing objects that act like an existing
  instance, except actions can be intercepted and mocked.
* `DataModelMocker`, provides higher-level proxies that can interact with each
  other as part of a fake data model.

---

### :pencil2: Notes
* Right now, only a limited subset of data model mocking features are
  implemented and available for use.
* `DataModelMocker` should be used for constructing instance mocks, not
  `InstanceProxy`.
	* The `InstanceProxy` class is a minimal, self-contained implementation with
	no special behaviour.
	* The `DataModelMocker` class allows proxies to be reused, and provides
	useful default mock behaviour like returning proxied descendants or ancestry.
* `InstanceProxy` intentionally only implements some of an `Instance`'s
  capabilities.
	* It is assumed that the instance proxy is being used on normal, idiomatic
	code that would correctly function if given an `Instance`.
	* Instance proxies have normal reference-based equality. They are not equal
	to the original instance, nor to any other proxies of that instance.
	* Instance proxies can't be consumed by functions expecting a "proper
	Instance".
		* In particular, calls to C such as `x:IsAncestorOf(InstanceProxy)` will
		  error as these calls are not mockable.
	
