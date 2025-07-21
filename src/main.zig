const std = @import("std");
const assert = std.debug.assert;
const arrays_hashing_module = @import("arrays_hashing/index.zig");
const trees_module = @import("trees/index.zig");
const BSTNode = trees_module.bst.BSTNode;

pub fn main() !void {
    std.debug.print("MAIN FUNCTION", .{});
    try arrays_hashing();
    trees();
}

pub fn trees() void {
    const allocator = std.heap.page_allocator;
    const root = allocator.create(BSTNode) catch |err| {
        std.debug.print("Error allocating memory for root node: {any}\n", .{err});
        return;
    };
    root.* = BSTNode{
        .val = 10,
        .left = null,
        .right = null,
    };
    std.debug.print("Created node: {any}\n", .{root});
    const target: i32 = 0;
    _ = trees_module.bst.insert(root, target);
    std.debug.print("After insertion of {d}: {any}\n", .{ target, root });

    const right = allocator.create(BSTNode) catch |err| {
        std.debug.print("Error allocating memory for root node: {any}\n", .{err});
        return;
    };
    right.* = BSTNode{
        .val = 15,
        .left = null,
        .right = null,
    };

    const left = allocator.create(BSTNode) catch |err| {
        std.debug.print("Error allocating memory for root node: {any}\n", .{err});
        return;
    };
    left.* = BSTNode{
        .val = 5,
        .left = null,
        .right = null,
    };

    root.left = left;
    root.right = right;
    std.debug.print("Final root node: {any}\n", .{root});
    assert(root.contains(10));
    assert(root.contains(5));
    assert(root.contains(15));

    var new_root = allocator.create(BSTNode) catch |err| {
        std.debug.print("Error allocating memory for root node: {any}\n", .{err});
        return;
    };
    defer allocator.destroy(new_root);

    new_root = trees_module.bst.test_from_list() catch |err| {
        std.debug.print("Error in test_from_list: {any}\n", .{err});
        return;
    };
    std.debug.print("New root from list: {any}\n", .{new_root});
}

pub fn arrays_hashing() !void {
    std.debug.print("\nRunning problem:\n{s}", .{"Array-Hashing/two sum"});

    const values = [_]u8{ 0, 1, 2, 3, 4, 5, 6, 7, 8 };
    const result = arrays_hashing_module.two_sum.two_sum(values[0..], 8);

    std.debug.print("\nThe result is:\n{any}\n", .{&result});
}

test "bst" {
    const allocator = std.heap.page_allocator;

    const root = try allocator.create(BSTNode);
    root.* = .{
        .val = 10,
        .left = null,
        .right = null,
    };

    const left = try allocator.create(BSTNode);
    left.* = BSTNode{ .val = 5, .left = null, .right = null };
    root.left = left;

    const right = try allocator.create(BSTNode);
    right.* = BSTNode{ .val = 15, .left = null, .right = null };
    root.right = right;

    const left_left = try allocator.create(BSTNode);
    left_left.* = BSTNode{ .val = 3, .left = null, .right = null };
    left.left = left_left;

    const left_right = try allocator.create(BSTNode);
    left_right.* = BSTNode{ .val = 7, .left = null, .right = null };
    left.right = left_right;

    const right_right = try allocator.create(BSTNode);
    right_right.* = BSTNode{ .val = 20, .left = null, .right = null };
    right.right = right_right;

    try std.testing.expect(root.contains(10)); // root
    try std.testing.expect(root.contains(3)); // left-left
    try std.testing.expect(root.contains(7)); // left-right
    try std.testing.expect(root.contains(20)); // right-right
    try std.testing.expect(!root.contains(99)); // not in tree
}
test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // Try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
