const std = @import("std");
const expect = std.testing.expect;

pub fn contains_duplicate(nums: []const i32) !bool {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    // defer gpa.deinit();

    var map = std.AutoHashMap(i32, i32).init(allocator);
    defer map.deinit();

    var i: u32 = 0;

    for (nums) |value| {
        if (map.contains(value)) {
            return true;
        }
        map.put(value, 1) catch |err| {
            std.debug.print("\nError occured:\n{any}\n", .{err});
        };
        i += 1;
    }

    return false;
}

test "simple_test" {
    const values = [_]i32{ 1, 2, 3, 1 };
    std.debug.print("values: {any}\n", .{values});
    const result = contains_duplicate(values[0..]) catch |err| {
        std.debug.print("Error occurred: {}\n", .{err});
        return;
    };
    std.debug.print("\nresult: {any}\n", .{result});
    try expect(result == true);
}

test "hashing" {
    const Point = struct { x: i32, y: i32 };

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var map = std.AutoHashMap(i32, Point).init(allocator);
    defer map.deinit();

    const sample = .{ .x = 0, .y = 0 };
    try map.put(sample.x, sample);
    try expect(map.count() == 1);
}
