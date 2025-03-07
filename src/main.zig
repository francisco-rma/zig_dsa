const std = @import("std");
const arrays_hashing_module = @import("arrays_hashing/index.zig");

pub fn main() !void {
    std.debug.print("\nRunning problem:\n{s}", .{"Array-Hashing/contains_duplicate"});

    const values = [_]i32{ 0, 1, 2, 3, 4, 5, 6, 7, 8 };
    const result: bool = try arrays_hashing_module.contains_duplicate.contains_duplicate(values[0..]);

    std.debug.print("\nThe result is:\n{}\n", .{result});
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // Try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
