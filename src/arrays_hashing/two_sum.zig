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

pub fn case(values: []const u8, target: u8, result: []const u8) bool {
    const test_result = two_sum(values, target);
    std.debug.print("Result is: {any}\n", .{result});

    return ((result[0] == test_result[0]) and (result[1] == test_result[1]));
}

test "simple_test" {
    const sample_values = [_]u8{ 3, 3 };
    const sample_target: u8 = 6;

    const sample_result = [2]u8{ 0, 1 };

    const validity: bool = case(&sample_values, sample_target, &sample_result);
    std.debug.print("Test result is: {any}\n", .{validity});

    try expect(validity == true);
}
