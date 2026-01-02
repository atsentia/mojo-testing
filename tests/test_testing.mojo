"""
Tests for mojo-testing library.
"""

from testing import assert_equal as std_equal, assert_true as std_true, assert_false as std_false

from mojo_testing import (
    assert_contains,
    assert_not_contains,
    assert_starts_with,
    assert_ends_with,
    assert_empty,
    assert_not_empty,
    assert_between,
    assert_approximately_equal,
)
from mojo_testing import MockTracker, MockReturn, Spy
from mojo_testing import TestContext, TestData


fn test_assert_contains():
    """Test assert_contains."""
    try:
        assert_contains("hello world", "world")
        print("  [PASS] assert_contains passes for valid case")
    except e:
        print("  [FAIL] assert_contains:", e)


fn test_assert_not_contains():
    """Test assert_not_contains."""
    try:
        assert_not_contains("hello", "world")
        print("  [PASS] assert_not_contains passes for valid case")
    except e:
        print("  [FAIL] assert_not_contains:", e)


fn test_assert_starts_with():
    """Test assert_starts_with."""
    try:
        assert_starts_with("hello world", "hello")
        print("  [PASS] assert_starts_with passes for valid case")
    except e:
        print("  [FAIL] assert_starts_with:", e)


fn test_assert_ends_with():
    """Test assert_ends_with."""
    try:
        assert_ends_with("hello world", "world")
        print("  [PASS] assert_ends_with passes for valid case")
    except e:
        print("  [FAIL] assert_ends_with:", e)


fn test_assert_empty():
    """Test assert_empty."""
    try:
        assert_empty("")
        print("  [PASS] assert_empty passes for empty string")
    except e:
        print("  [FAIL] assert_empty:", e)


fn test_assert_not_empty():
    """Test assert_not_empty."""
    try:
        assert_not_empty("hello")
        print("  [PASS] assert_not_empty passes for non-empty string")
    except e:
        print("  [FAIL] assert_not_empty:", e)


fn test_assert_between():
    """Test assert_between."""
    try:
        assert_between(50, 0, 100)
        print("  [PASS] assert_between passes for value in range")
    except e:
        print("  [FAIL] assert_between:", e)


fn test_assert_approximately_equal():
    """Test assert_approximately_equal."""
    try:
        assert_approximately_equal(3.14159, 3.14159, 0.001)
        print("  [PASS] assert_approximately_equal passes for close values")
    except e:
        print("  [FAIL] assert_approximately_equal:", e)


fn test_mock_tracker_basic():
    """Test MockTracker basic functionality."""
    var tracker = MockTracker()

    std_false(tracker.was_called("get_user"))

    tracker.record("get_user", "123")
    std_true(tracker.was_called("get_user"))
    std_equal(tracker.call_count("get_user"), 1)

    tracker.record("get_user", "456")
    std_equal(tracker.call_count("get_user"), 2)

    print("  [PASS] test_mock_tracker_basic")


fn test_mock_tracker_get_args():
    """Test MockTracker argument retrieval."""
    var tracker = MockTracker()

    var args = List[String]()
    args.append("user_id=123")
    args.append("include_profile=true")
    tracker.record("get_user", args)

    var call = tracker.first_call("get_user")
    std_true(call is not None)
    std_equal(len(call.value().args), 2)

    print("  [PASS] test_mock_tracker_get_args")


fn test_mock_tracker_assertions():
    """Test MockTracker assertion methods."""
    var tracker = MockTracker()
    tracker.record("save_user")

    try:
        tracker.assert_called("save_user")
        tracker.assert_not_called("delete_user")
        tracker.assert_called_times("save_user", 1)
        print("  [PASS] test_mock_tracker_assertions")
    except e:
        print("  [FAIL] test_mock_tracker_assertions:", e)


fn test_mock_return():
    """Test MockReturn value queue."""
    var returns = MockReturn[Int](0)
    returns.add_return(42)
    returns.add_return(100)

    std_equal(returns.next(), 42)
    std_equal(returns.next(), 100)
    std_equal(returns.next(), 0)  # Default

    returns.reset()
    std_equal(returns.next(), 42)  # Back to start

    print("  [PASS] test_mock_return")


fn test_spy():
    """Test Spy combining tracker and returns."""
    var spy = Spy()

    spy.returns("get_config").add_return("debug=true")
    spy.returns("get_config").add_return("debug=false")

    var result1 = spy.call("get_config")
    std_equal(result1, "debug=true")

    var result2 = spy.call("get_config")
    std_equal(result2, "debug=false")

    std_equal(spy.call_count("get_config"), 2)

    print("  [PASS] test_spy")


fn test_test_context():
    """Test TestContext data storage."""
    var ctx = TestContext("user_test")

    ctx.set("user_id", "123")
    ctx.set("email", "test@example.com")

    std_true(ctx.has("user_id"))
    std_equal(ctx.get("user_id"), "123")
    std_equal(ctx.get("missing", "default"), "default")

    ctx.cleanup()
    std_false(ctx.has("user_id"))

    print("  [PASS] test_test_context")


fn test_test_data():
    """Test TestData fixtures."""
    var data = TestData()

    std_equal(data.valid_email(), "test@example.com")
    std_true(data.valid_url().startswith("https://"))
    std_equal(len(data.empty_string()), 0)
    std_equal(len(data.long_string(100)), 100)

    var id1 = data.sequential_int()
    var id2 = data.sequential_int()
    std_true(id2 > id1)

    print("  [PASS] test_test_data")


fn main():
    """Run all tests."""
    print("Running mojo-testing tests...")

    test_assert_contains()
    test_assert_not_contains()
    test_assert_starts_with()
    test_assert_ends_with()
    test_assert_empty()
    test_assert_not_empty()
    test_assert_between()
    test_assert_approximately_equal()
    test_mock_tracker_basic()
    test_mock_tracker_get_args()
    test_mock_tracker_assertions()
    test_mock_return()
    test_spy()
    test_test_context()
    test_test_data()

    print("\nAll tests passed!")
