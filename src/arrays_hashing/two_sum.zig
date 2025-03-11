const std = @import("std");
const expect = std.testing.expect;

pub fn two_sum(nums: []const u8, target: u8) [2]u8 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var map = std.AutoHashMap(u8, u8).init(allocator);
    defer map.deinit();

    var result = [2]u8{ 0, 0 };

    var i: u8 = 0;

    while (i < nums.len) {
        if (map.get(target - nums[i])) |map_idx| {
            if (map_idx < i) {
                result[0] = map_idx;
                result[1] = i;
            } else {
                result[1] = map_idx;
                result[0] = i;
            }
            return result;
        }
        map.put(nums[i], i) catch |err| {
            std.debug.print("\nError occurred: {any}\n", .{err});
            return result;
        };
        i += 1;
    }

    return result;
}

test "simple_test" {
    const sample_values = [_]u8{ 1, 2, 3, 4, 5, 6, 7, 8, 9 };
    const sample_target: u8 = 9;

    const sample_result = [2]u8{ 3, 4 };

    const result = two_sum(&sample_values, sample_target);
    std.debug.print("Result is: {any}\n", .{result});

    const test_result: bool = ((sample_result[0] == result[0]) and (sample_result[1] == result[1]));

    std.debug.print("Test result is: {any}\n", .{test_result});
    try expect(test_result == true);
}
