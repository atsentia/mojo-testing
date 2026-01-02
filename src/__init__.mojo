"""
mojo-testing

Testing utilities, assertions, and mocking for Mojo applications.

Features:
- Extended assertions beyond the standard library
- Mock tracking and verification
- Test fixtures and data generators
- Test suite organization

Usage:
    from mojo_testing import assert_equal, assert_contains, assert_between
    from mojo_testing import MockTracker, Spy
    from mojo_testing import TestContext, TestSuite, TestData

    # Extended assertions
    assert_contains("hello world", "world")
    assert_between(value, 0, 100)

    # Mocking
    var tracker = MockTracker()
    tracker.record("get_user", "123")
    tracker.assert_called("get_user")

    # Fixtures
    var data = TestData()
    var email = data.valid_email()
"""

# Extended assertions
from .assertions import (
    assert_equal,
    assert_not_equal,
    assert_true,
    assert_false,
    assert_none,
    assert_some,
    assert_contains,
    assert_not_contains,
    assert_starts_with,
    assert_ends_with,
    assert_empty,
    assert_not_empty,
    assert_length,
    assert_list_empty,
    assert_list_not_empty,
    assert_list_length,
    assert_greater_than,
    assert_greater_equal,
    assert_less_than,
    assert_less_equal,
    assert_between,
    assert_approximately_equal,
    fail,
)

# Mocking utilities
from .mock import (
    CallRecord,
    MockTracker,
    MockReturn,
    Spy,
)

# Test fixtures
from .fixtures import (
    TestContext,
    TempValue,
    TestSuite,
    TestData,
)
