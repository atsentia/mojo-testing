"""
Extended Assertions

Additional assertion functions beyond the standard library.
"""


fn assert_equal[T: Stringable & EqualityComparable](
    actual: T,
    expected: T,
    message: String = ""
) raises:
    """Assert two values are equal."""
    if actual != expected:
        var msg = "Assertion failed: " + str(actual) + " != " + str(expected)
        if len(message) > 0:
            msg += " - " + message
        raise Error(msg)


fn assert_not_equal[T: Stringable & EqualityComparable](
    actual: T,
    expected: T,
    message: String = ""
) raises:
    """Assert two values are not equal."""
    if actual == expected:
        var msg = "Assertion failed: values should not be equal: " + str(actual)
        if len(message) > 0:
            msg += " - " + message
        raise Error(msg)


fn assert_true(condition: Bool, message: String = "") raises:
    """Assert condition is True."""
    if not condition:
        var msg = "Assertion failed: expected True"
        if len(message) > 0:
            msg += " - " + message
        raise Error(msg)


fn assert_false(condition: Bool, message: String = "") raises:
    """Assert condition is False."""
    if condition:
        var msg = "Assertion failed: expected False"
        if len(message) > 0:
            msg += " - " + message
        raise Error(msg)


fn assert_none[T: CollectionElement](value: Optional[T], message: String = "") raises:
    """Assert value is None."""
    if value:
        var msg = "Assertion failed: expected None"
        if len(message) > 0:
            msg += " - " + message
        raise Error(msg)


fn assert_some[T: CollectionElement](value: Optional[T], message: String = "") raises:
    """Assert value is not None."""
    if not value:
        var msg = "Assertion failed: expected Some value"
        if len(message) > 0:
            msg += " - " + message
        raise Error(msg)


fn assert_contains(haystack: String, needle: String, message: String = "") raises:
    """Assert string contains substring."""
    if needle not in haystack:
        var msg = "Assertion failed: '" + needle + "' not found in '" + haystack + "'"
        if len(message) > 0:
            msg += " - " + message
        raise Error(msg)


fn assert_not_contains(haystack: String, needle: String, message: String = "") raises:
    """Assert string does not contain substring."""
    if needle in haystack:
        var msg = "Assertion failed: '" + needle + "' found in '" + haystack + "'"
        if len(message) > 0:
            msg += " - " + message
        raise Error(msg)


fn assert_starts_with(value: String, prefix: String, message: String = "") raises:
    """Assert string starts with prefix."""
    if not value.startswith(prefix):
        var msg = "Assertion failed: '" + value + "' does not start with '" + prefix + "'"
        if len(message) > 0:
            msg += " - " + message
        raise Error(msg)


fn assert_ends_with(value: String, suffix: String, message: String = "") raises:
    """Assert string ends with suffix."""
    if not value.endswith(suffix):
        var msg = "Assertion failed: '" + value + "' does not end with '" + suffix + "'"
        if len(message) > 0:
            msg += " - " + message
        raise Error(msg)


fn assert_empty(value: String, message: String = "") raises:
    """Assert string is empty."""
    if len(value) != 0:
        var msg = "Assertion failed: expected empty string, got '" + value + "'"
        if len(message) > 0:
            msg += " - " + message
        raise Error(msg)


fn assert_not_empty(value: String, message: String = "") raises:
    """Assert string is not empty."""
    if len(value) == 0:
        var msg = "Assertion failed: expected non-empty string"
        if len(message) > 0:
            msg += " - " + message
        raise Error(msg)


fn assert_length(value: String, expected: Int, message: String = "") raises:
    """Assert string has expected length."""
    if len(value) != expected:
        var msg = "Assertion failed: expected length " + str(expected) + ", got " + str(len(value))
        if len(message) > 0:
            msg += " - " + message
        raise Error(msg)


fn assert_list_empty[T: CollectionElement](value: List[T], message: String = "") raises:
    """Assert list is empty."""
    if len(value) != 0:
        var msg = "Assertion failed: expected empty list, got " + str(len(value)) + " items"
        if len(message) > 0:
            msg += " - " + message
        raise Error(msg)


fn assert_list_not_empty[T: CollectionElement](value: List[T], message: String = "") raises:
    """Assert list is not empty."""
    if len(value) == 0:
        var msg = "Assertion failed: expected non-empty list"
        if len(message) > 0:
            msg += " - " + message
        raise Error(msg)


fn assert_list_length[T: CollectionElement](
    value: List[T],
    expected: Int,
    message: String = ""
) raises:
    """Assert list has expected length."""
    if len(value) != expected:
        var msg = "Assertion failed: expected list length " + str(expected) + ", got " + str(len(value))
        if len(message) > 0:
            msg += " - " + message
        raise Error(msg)


fn assert_greater_than[T: Stringable & Comparable](
    actual: T,
    expected: T,
    message: String = ""
) raises:
    """Assert actual > expected."""
    if actual <= expected:
        var msg = "Assertion failed: " + str(actual) + " not > " + str(expected)
        if len(message) > 0:
            msg += " - " + message
        raise Error(msg)


fn assert_greater_equal[T: Stringable & Comparable](
    actual: T,
    expected: T,
    message: String = ""
) raises:
    """Assert actual >= expected."""
    if actual < expected:
        var msg = "Assertion failed: " + str(actual) + " not >= " + str(expected)
        if len(message) > 0:
            msg += " - " + message
        raise Error(msg)


fn assert_less_than[T: Stringable & Comparable](
    actual: T,
    expected: T,
    message: String = ""
) raises:
    """Assert actual < expected."""
    if actual >= expected:
        var msg = "Assertion failed: " + str(actual) + " not < " + str(expected)
        if len(message) > 0:
            msg += " - " + message
        raise Error(msg)


fn assert_less_equal[T: Stringable & Comparable](
    actual: T,
    expected: T,
    message: String = ""
) raises:
    """Assert actual <= expected."""
    if actual > expected:
        var msg = "Assertion failed: " + str(actual) + " not <= " + str(expected)
        if len(message) > 0:
            msg += " - " + message
        raise Error(msg)


fn assert_between[T: Stringable & Comparable](
    actual: T,
    min_val: T,
    max_val: T,
    message: String = ""
) raises:
    """Assert min <= actual <= max."""
    if actual < min_val or actual > max_val:
        var msg = "Assertion failed: " + str(actual) + " not between " + str(min_val) + " and " + str(max_val)
        if len(message) > 0:
            msg += " - " + message
        raise Error(msg)


fn assert_approximately_equal(
    actual: Float64,
    expected: Float64,
    tolerance: Float64 = 1e-9,
    message: String = ""
) raises:
    """Assert floats are approximately equal within tolerance."""
    var diff = actual - expected
    if diff < 0:
        diff = -diff
    if diff > tolerance:
        var msg = "Assertion failed: " + str(actual) + " not approximately equal to " + str(expected)
        msg += " (diff: " + str(diff) + ", tolerance: " + str(tolerance) + ")"
        if len(message) > 0:
            msg += " - " + message
        raise Error(msg)


fn fail(message: String = "Test failed") raises:
    """Explicitly fail the test."""
    raise Error(message)
