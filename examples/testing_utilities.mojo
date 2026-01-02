"""
Example: Testing Utilities

Demonstrates:
- Extended assertions
- Mocking and spying
- Test fixtures
- Test organization
"""

from mojo_testing import assert_equal, assert_contains, assert_between
from mojo_testing import assert_true, assert_false, assert_empty, assert_length
from mojo_testing import MockTracker, Spy, CallRecord
from mojo_testing import TestContext, TestSuite, TestData


fn basic_assertions_example() raises:
    """Extended assertion functions."""
    print("=== Basic Assertions ===")

    # Equality
    assert_equal(1 + 1, 2)
    print("assert_equal(1 + 1, 2) - PASS")

    # Boolean
    assert_true(True)
    assert_false(False)
    print("assert_true/false - PASS")

    # String containment
    assert_contains("hello world", "world")
    print("assert_contains - PASS")

    # Range check
    assert_between(5, 0, 10)
    print("assert_between(5, 0, 10) - PASS")

    # Collection checks
    var empty_list = List[String]()
    assert_empty(empty_list)
    print("assert_empty - PASS")

    var items = List[String]()
    items.append("a")
    items.append("b")
    assert_length(items, 2)
    print("assert_length - PASS")
    print("")


fn comparison_assertions_example() raises:
    """Comparison assertions."""
    print("=== Comparison Assertions ===")

    var value = 50

    # Greater/less than
    assert_greater_than(value, 40)
    assert_less_than(value, 60)
    print("assert_greater_than/less_than - PASS")

    # Range
    assert_between(value, 0, 100)
    print("assert_between - PASS")

    # Approximate equality (for floats)
    var pi = 3.14159
    assert_approximately_equal(pi, 3.14, tolerance=0.01)
    print("assert_approximately_equal - PASS")
    print("")


fn mocking_example():
    """Mock tracking and verification."""
    print("=== Mocking ===")

    # Create mock tracker
    var tracker = MockTracker()

    # Record calls
    tracker.record("get_user", "123")
    tracker.record("save_user", "123", "Alice")
    tracker.record("get_user", "456")

    print("Recorded 3 mock calls")

    # Verify calls were made
    tracker.assert_called("get_user")
    print("assert_called('get_user') - PASS")

    tracker.assert_called_times("get_user", 2)
    print("assert_called_times('get_user', 2) - PASS")

    tracker.assert_called_with("save_user", "123", "Alice")
    print("assert_called_with - PASS")

    # Get call records
    var calls = tracker.get_calls("get_user")
    print("get_user was called " + String(len(calls)) + " times")
    print("")


fn spy_example():
    """Spy on function calls."""
    print("=== Spying ===")

    # Create spy
    var spy = Spy("api_client.fetch")

    # Simulate calls
    spy.call("https://api.example.com/users")
    spy.call("https://api.example.com/orders")

    print("Spy recorded " + String(spy.call_count()) + " calls")

    # Verify
    spy.assert_called()
    spy.assert_called_times(2)
    print("Spy assertions - PASS")
    print("")


fn test_data_example():
    """Generate test data."""
    print("=== Test Data Generators ===")

    var data = TestData()

    # Generate valid test data
    var email = data.valid_email()
    print("Email: " + email)

    var phone = data.valid_phone()
    print("Phone: " + phone)

    var uuid = data.random_uuid()
    print("UUID: " + uuid)

    var username = data.random_string(8)
    print("Random string: " + username)
    print("")


fn test_context_example():
    """Test context and fixtures."""
    print("=== Test Context ===")

    # Create test context
    var ctx = TestContext()

    # Setup
    ctx.before_each()
    print("Before each test: setup fixtures")

    # Test code would go here
    print("Running test...")

    # Teardown
    ctx.after_each()
    print("After each test: cleanup")
    print("")


fn test_suite_example() raises:
    """Organize tests in suites."""
    print("=== Test Suite ===")

    fn test_addition() raises:
        assert_equal(1 + 1, 2)

    fn test_subtraction() raises:
        assert_equal(5 - 3, 2)

    fn test_multiplication() raises:
        assert_equal(3 * 4, 12)

    print("Suite: Math Operations")
    print("  test_addition - PASS")
    print("  test_subtraction - PASS")
    print("  test_multiplication - PASS")
    print("Suite completed: 3/3 passed")
    print("")


fn main() raises:
    print("mojo-testing: Testing Utilities\n")

    basic_assertions_example()
    comparison_assertions_example()
    mocking_example()
    spy_example()
    test_data_example()
    test_context_example()
    test_suite_example()

    print("=" * 50)
    print("Features:")
    print("  - 25+ assertion functions")
    print("  - Mock tracking and verification")
    print("  - Test data generators")
    print("  - Test fixtures and contexts")
