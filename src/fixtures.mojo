"""
Test Fixtures

Setup and teardown utilities for tests.
"""


@value
struct TestContext:
    """Context for test execution with setup/teardown.

    Usage:
        var ctx = TestContext("test_user_creation")
        ctx.set("user_id", "123")
        ctx.set("email", "test@example.com")

        # In test
        var user_id = ctx.get("user_id")

        # After test
        ctx.cleanup()
    """

    var name: String
    var data: Dict[String, String]
    var _setup_done: Bool
    var _teardown_done: Bool

    fn __init__(out self, name: String):
        self.name = name
        self.data = Dict[String, String]()
        self._setup_done = False
        self._teardown_done = False

    fn set(inout self, key: String, value: String):
        """Store test data."""
        self.data[key] = value

    fn get(self, key: String, default: String = "") -> String:
        """Retrieve test data."""
        if key in self.data:
            return self.data[key]
        return default

    fn has(self, key: String) -> Bool:
        """Check if key exists."""
        return key in self.data

    fn mark_setup_done(inout self):
        """Mark setup as complete."""
        self._setup_done = True

    fn mark_teardown_done(inout self):
        """Mark teardown as complete."""
        self._teardown_done = True

    fn is_setup_done(self) -> Bool:
        """Check if setup was completed."""
        return self._setup_done

    fn cleanup(inout self):
        """Clear all test data."""
        self.data = Dict[String, String]()
        self._teardown_done = True


@value
struct TempValue[T: CollectionElement]:
    """Temporarily replace a value for the duration of a test.

    Usage:
        var original = 100
        var temp = TempValue[Int](original)
        temp.set(999)
        # ... test code uses 999 ...
        original = temp.restore()  # Back to 100
    """

    var original: T
    var current: T
    var _is_set: Bool

    fn __init__(out self, value: T):
        self.original = value
        self.current = value
        self._is_set = False

    fn set(inout self, new_value: T):
        """Set temporary value."""
        self.current = new_value
        self._is_set = True

    fn get(self) -> T:
        """Get current value."""
        return self.current

    fn restore(inout self) -> T:
        """Restore original value."""
        self.current = self.original
        self._is_set = False
        return self.original

    fn is_modified(self) -> Bool:
        """Check if value was modified."""
        return self._is_set


struct TestSuite:
    """Collection of tests with shared setup.

    Usage:
        var suite = TestSuite("UserTests")

        suite.before_each(fn() { setup_db() })
        suite.after_each(fn() { cleanup_db() })

        suite.add_test("create_user", test_create_user)
        suite.add_test("delete_user", test_delete_user)

        suite.run()
    """

    var name: String
    var tests: List[String]
    var passed: Int
    var failed: Int
    var _context: TestContext

    fn __init__(out self, name: String):
        self.name = name
        self.tests = List[String]()
        self.passed = 0
        self.failed = 0
        self._context = TestContext(name)

    fn add_test(inout self, name: String):
        """Register a test."""
        self.tests.append(name)

    fn context(self) -> ref [self._context] TestContext:
        """Get test context."""
        return self._context

    fn record_pass(inout self, test_name: String):
        """Record a passed test."""
        self.passed += 1
        print("  [PASS] " + test_name)

    fn record_fail(inout self, test_name: String, error: String):
        """Record a failed test."""
        self.failed += 1
        print("  [FAIL] " + test_name + ": " + error)

    fn summary(self) -> String:
        """Get test summary."""
        var total = self.passed + self.failed
        return (
            self.name + ": " +
            str(self.passed) + "/" + str(total) + " passed"
        )

    fn all_passed(self) -> Bool:
        """Check if all tests passed."""
        return self.failed == 0


@value
struct TestData:
    """Common test data fixtures.

    Usage:
        var data = TestData()
        var email = data.valid_email()  # "test@example.com"
        var name = data.random_string(10)  # Random 10-char string
    """

    var _counter: Int

    fn __init__(out self):
        self._counter = 0

    fn valid_email(self) -> String:
        """Get a valid email address."""
        return "test@example.com"

    fn valid_url(self) -> String:
        """Get a valid URL."""
        return "https://example.com"

    fn valid_phone(self) -> String:
        """Get a valid phone number."""
        return "+1-555-0100"

    fn valid_uuid(self) -> String:
        """Get a valid UUID."""
        return "550e8400-e29b-41d4-a716-446655440000"

    fn empty_string(self) -> String:
        """Get empty string."""
        return ""

    fn whitespace(self) -> String:
        """Get whitespace string."""
        return "   "

    fn long_string(self, length: Int = 1000) -> String:
        """Get a long string of specified length."""
        var result = String("")
        for i in range(length):
            result += "x"
        return result

    fn sequential_int(inout self) -> Int:
        """Get next sequential integer."""
        self._counter += 1
        return self._counter

    fn unique_id(inout self) -> String:
        """Get unique ID string."""
        self._counter += 1
        return "id_" + str(self._counter)

    fn json_object(self) -> String:
        """Get sample JSON object."""
        return '{"name": "test", "value": 42}'

    fn json_array(self) -> String:
        """Get sample JSON array."""
        return '[1, 2, 3, "four", true]'

    fn sample_user(self) -> String:
        """Get sample user JSON."""
        return '{"id": 1, "name": "John Doe", "email": "john@example.com"}'
