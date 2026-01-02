# mojo-testing

Testing utilities, assertions, and mocking for Mojo applications.

## Features

- **Extended Assertions**: Beyond the standard library
- **Mock Tracking**: Record and verify function calls
- **Spy Objects**: Combine tracking with configurable returns
- **Test Fixtures**: Context, data generators, and suite organization

## Installation

Add to your `pixi.toml`:

```toml
[workspace.dependencies]
mojo-testing = { path = "../mojo-libs/mojo-testing" }
```

## Usage

### Extended Assertions

```mojo
from mojo_testing import (
    assert_contains,
    assert_starts_with,
    assert_between,
    assert_approximately_equal,
    fail,
)

# String assertions
assert_contains("hello world", "world")
assert_starts_with("https://example.com", "https://")
assert_ends_with("config.json", ".json")
assert_empty("")
assert_not_empty("data")

# Numeric assertions
assert_between(value, 0, 100)
assert_greater_than(score, 0)
assert_less_equal(count, max_count)
assert_approximately_equal(3.14159, 3.14, 0.01)

# Optional assertions
assert_some(result)
assert_none(error)

# List assertions
assert_list_not_empty(items)
assert_list_length(items, 5)

# Explicit failure
if not valid:
    fail("Custom failure message")
```

### Mock Tracking

```mojo
from mojo_testing import MockTracker

var tracker = MockTracker()

# Record calls in mock functions
fn mock_get_user(user_id: String) -> String:
    tracker.record("get_user", user_id)
    return '{"name": "test"}'

# Verify calls in tests
tracker.assert_called("get_user")
tracker.assert_called_times("get_user", 1)
tracker.assert_not_called("delete_user")

# Check call details
var call = tracker.first_call("get_user")
if call:
    print("Args:", call.value().args)

# Check argument values
tracker.assert_called_with("get_user", ["123"])
```

### Mock Returns

```mojo
from mojo_testing import MockReturn

var returns = MockReturn[String]("")

# Queue up return values
returns.add_return('{"id": 1}')
returns.add_return('{"id": 2}')

# In mock function
fn mock_fetch() -> String:
    return returns.next()

# First call returns '{"id": 1}'
# Second call returns '{"id": 2}'
# Third+ call returns "" (default)
```

### Spy Objects

```mojo
from mojo_testing import Spy

var spy = Spy()

# Configure returns
spy.returns("get_config").add_return("debug=true")
spy.returns("get_config").add_return("debug=false")

# Call and get configured return
var result = spy.call("get_config")  # "debug=true"
var result2 = spy.call("get_config") # "debug=false"

# Verify
spy.assert_called("get_config")
print(spy.call_count("get_config"))  # 2
```

### Test Fixtures

```mojo
from mojo_testing import TestContext, TestData

# Test context for data sharing
var ctx = TestContext("user_creation_test")
ctx.set("user_id", "123")
ctx.set("token", "abc")

# Later in test
var user_id = ctx.get("user_id")

# Cleanup
ctx.cleanup()

# Test data generators
var data = TestData()
var email = data.valid_email()           # "test@example.com"
var url = data.valid_url()               # "https://example.com"
var long = data.long_string(1000)        # 1000 'x' characters
var id1 = data.sequential_int()          # 1
var id2 = data.sequential_int()          # 2
var unique = data.unique_id()            # "id_3"
```

### Temporary Values

```mojo
from mojo_testing import TempValue

var original_config = load_config()
var temp = TempValue[Config](original_config)

# Modify for test
temp.set(test_config)

# ... run test ...

# Restore original
original_config = temp.restore()
```

## API Reference

### Assertions

| Function | Description |
|----------|-------------|
| `assert_equal(a, b)` | Assert equality |
| `assert_not_equal(a, b)` | Assert inequality |
| `assert_true(cond)` | Assert True |
| `assert_false(cond)` | Assert False |
| `assert_none(opt)` | Assert Optional is None |
| `assert_some(opt)` | Assert Optional has value |
| `assert_contains(str, sub)` | Assert substring |
| `assert_not_contains(str, sub)` | Assert no substring |
| `assert_starts_with(str, prefix)` | Assert prefix |
| `assert_ends_with(str, suffix)` | Assert suffix |
| `assert_empty(str)` | Assert empty string |
| `assert_not_empty(str)` | Assert non-empty |
| `assert_length(str, n)` | Assert string length |
| `assert_list_empty(list)` | Assert empty list |
| `assert_list_not_empty(list)` | Assert non-empty list |
| `assert_list_length(list, n)` | Assert list length |
| `assert_greater_than(a, b)` | Assert a > b |
| `assert_greater_equal(a, b)` | Assert a >= b |
| `assert_less_than(a, b)` | Assert a < b |
| `assert_less_equal(a, b)` | Assert a <= b |
| `assert_between(x, min, max)` | Assert min <= x <= max |
| `assert_approximately_equal(a, b, tol)` | Assert floats close |
| `fail(msg)` | Explicit failure |

### MockTracker

| Method | Description |
|--------|-------------|
| `record(method)` | Record call |
| `record(method, args)` | Record call with args |
| `was_called(method)` | Check if called |
| `was_not_called(method)` | Check if not called |
| `call_count(method)` | Get call count |
| `total_calls()` | Get total calls |
| `get_call(method, index)` | Get Nth call |
| `first_call(method)` | Get first call |
| `last_call(method)` | Get last call |
| `get_args(method, index)` | Get call args |
| `clear()` | Reset all |
| `assert_called(method)` | Assert called |
| `assert_not_called(method)` | Assert not called |
| `assert_called_times(method, n)` | Assert call count |
| `assert_called_with(method, args)` | Assert args |

### MockReturn

| Method | Description |
|--------|-------------|
| `set_default(value)` | Set default return |
| `add_return(value)` | Queue return value |
| `next()` | Get next return |
| `reset()` | Reset to start |
| `clear()` | Clear queue |

### TestData

| Method | Description |
|--------|-------------|
| `valid_email()` | Sample email |
| `valid_url()` | Sample URL |
| `valid_phone()` | Sample phone |
| `valid_uuid()` | Sample UUID |
| `empty_string()` | Empty string |
| `whitespace()` | Whitespace |
| `long_string(n)` | N-char string |
| `sequential_int()` | Next integer |
| `unique_id()` | Unique ID |
| `json_object()` | Sample JSON |
| `sample_user()` | User JSON |

## License

MIT

## Part of mojo-contrib

This library is part of [mojo-contrib](https://github.com/atsentia/mojo-contrib), a collection of pure Mojo libraries.
