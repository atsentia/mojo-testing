"""
Mocking Utilities

Simple mocking infrastructure for testing.
"""


@value
struct CallRecord:
    """Record of a function call."""

    var method: String
    var args: List[String]
    var timestamp: Int  # Monotonic counter

    fn __init__(out self, method: String):
        self.method = method
        self.args = List[String]()
        self.timestamp = 0

    fn __init__(out self, method: String, args: List[String], timestamp: Int):
        self.method = method
        self.args = args
        self.timestamp = timestamp

    fn __str__(self) -> String:
        var result = self.method + "("
        for i in range(len(self.args)):
            if i > 0:
                result += ", "
            result += self.args[i]
        result += ")"
        return result


struct MockTracker:
    """Tracks mock function calls.

    Usage:
        var tracker = MockTracker()

        # In mock function:
        tracker.record("get_user", ["user_id=123"])

        # In test:
        assert_true(tracker.was_called("get_user"))
        assert_equal(tracker.call_count("get_user"), 1)
    """

    var calls: List[CallRecord]
    var _counter: Int

    fn __init__(out self):
        self.calls = List[CallRecord]()
        self._counter = 0

    fn record(inout self, method: String):
        """Record a call with no arguments."""
        self._counter += 1
        self.calls.append(CallRecord(method, List[String](), self._counter))

    fn record(inout self, method: String, args: List[String]):
        """Record a call with arguments."""
        self._counter += 1
        self.calls.append(CallRecord(method, args, self._counter))

    fn record(inout self, method: String, arg: String):
        """Record a call with single argument."""
        self._counter += 1
        var args = List[String]()
        args.append(arg)
        self.calls.append(CallRecord(method, args, self._counter))

    fn was_called(self, method: String) -> Bool:
        """Check if method was called at least once."""
        for i in range(len(self.calls)):
            if self.calls[i].method == method:
                return True
        return False

    fn was_not_called(self, method: String) -> Bool:
        """Check if method was never called."""
        return not self.was_called(method)

    fn call_count(self, method: String) -> Int:
        """Get number of times method was called."""
        var count = 0
        for i in range(len(self.calls)):
            if self.calls[i].method == method:
                count += 1
        return count

    fn total_calls(self) -> Int:
        """Get total number of calls recorded."""
        return len(self.calls)

    fn get_call(self, method: String, index: Int = 0) -> Optional[CallRecord]:
        """Get the Nth call to a method (0-indexed)."""
        var found = 0
        for i in range(len(self.calls)):
            if self.calls[i].method == method:
                if found == index:
                    return self.calls[i]
                found += 1
        return None

    fn last_call(self, method: String) -> Optional[CallRecord]:
        """Get the last call to a method."""
        var last: Optional[CallRecord] = None
        for i in range(len(self.calls)):
            if self.calls[i].method == method:
                last = self.calls[i]
        return last

    fn first_call(self, method: String) -> Optional[CallRecord]:
        """Get the first call to a method."""
        return self.get_call(method, 0)

    fn clear(inout self):
        """Clear all recorded calls."""
        self.calls = List[CallRecord]()
        self._counter = 0

    fn get_args(self, method: String, index: Int = 0) -> List[String]:
        """Get arguments of the Nth call to method."""
        var call = self.get_call(method, index)
        if call:
            return call.value().args
        return List[String]()

    fn assert_called(self, method: String) raises:
        """Assert method was called at least once."""
        if not self.was_called(method):
            raise Error("Expected '" + method + "' to be called, but it was not")

    fn assert_not_called(self, method: String) raises:
        """Assert method was never called."""
        if self.was_called(method):
            raise Error("Expected '" + method + "' to not be called, but it was called " + str(self.call_count(method)) + " time(s)")

    fn assert_called_times(self, method: String, times: Int) raises:
        """Assert method was called exactly N times."""
        var actual = self.call_count(method)
        if actual != times:
            raise Error("Expected '" + method + "' to be called " + str(times) + " time(s), but was called " + str(actual) + " time(s)")

    fn assert_called_with(self, method: String, args: List[String]) raises:
        """Assert method was called with specific arguments."""
        var call = self.last_call(method)
        if not call:
            raise Error("Expected '" + method + "' to be called, but it was not")

        var actual_args = call.value().args
        if len(actual_args) != len(args):
            raise Error("Expected " + str(len(args)) + " args, got " + str(len(actual_args)))

        for i in range(len(args)):
            if actual_args[i] != args[i]:
                raise Error("Argument mismatch at index " + str(i) + ": expected '" + args[i] + "', got '" + actual_args[i] + "'")


@value
struct MockReturn[T: CollectionElement]:
    """Configure return values for mock functions.

    Usage:
        var returns = MockReturn[Int]()
        returns.set_default(0)
        returns.add_return(42)
        returns.add_return(100)

        print(returns.next())  # 42
        print(returns.next())  # 100
        print(returns.next())  # 0 (default)
    """

    var _returns: List[T]
    var _default: T
    var _index: Int

    fn __init__(out self, default: T):
        self._returns = List[T]()
        self._default = default
        self._index = 0

    fn set_default(inout self, value: T):
        """Set default return value when queue is exhausted."""
        self._default = value

    fn add_return(inout self, value: T):
        """Add a return value to the queue."""
        self._returns.append(value)

    fn next(inout self) -> T:
        """Get next return value (or default if exhausted)."""
        if self._index < len(self._returns):
            var value = self._returns[self._index]
            self._index += 1
            return value
        return self._default

    fn reset(inout self):
        """Reset index to start of queue."""
        self._index = 0

    fn clear(inout self):
        """Clear return queue."""
        self._returns = List[T]()
        self._index = 0


struct Spy:
    """Combines MockTracker with return configuration.

    Usage:
        var spy = Spy()

        # Configure returns
        spy.returns("get_user").add_return('{"name": "test"}')

        # In code under test, mock would call:
        spy.call("get_user", "123")  # Records + returns configured value

        # Assert
        spy.assert_called("get_user")
    """

    var tracker: MockTracker
    var string_returns: Dict[String, MockReturn[String]]

    fn __init__(out self):
        self.tracker = MockTracker()
        self.string_returns = Dict[String, MockReturn[String]]()

    fn returns(inout self, method: String) -> ref [self.string_returns] MockReturn[String]:
        """Get return value configuration for method."""
        if method not in self.string_returns:
            self.string_returns[method] = MockReturn[String]("")
        return self.string_returns[method]

    fn call(inout self, method: String) -> String:
        """Record call and return configured value."""
        self.tracker.record(method)
        if method in self.string_returns:
            return self.string_returns[method].next()
        return ""

    fn call(inout self, method: String, arg: String) -> String:
        """Record call with arg and return configured value."""
        self.tracker.record(method, arg)
        if method in self.string_returns:
            return self.string_returns[method].next()
        return ""

    fn was_called(self, method: String) -> Bool:
        """Check if method was called."""
        return self.tracker.was_called(method)

    fn call_count(self, method: String) -> Int:
        """Get call count for method."""
        return self.tracker.call_count(method)

    fn assert_called(self, method: String) raises:
        """Assert method was called."""
        self.tracker.assert_called(method)

    fn reset(inout self):
        """Reset all state."""
        self.tracker.clear()
        for key in self.string_returns:
            self.string_returns[key].reset()
