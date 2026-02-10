const std = @import("std");
pub const BSTNode = struct {
    val: i32,
    left: ?*BSTNode,
    right: ?*BSTNode,
    pub fn contains(self: *BSTNode, target: i32) bool {
        var result: bool = false;
        var node: ?*BSTNode = self;

        while (node) |n| {
            if (target == n.val) {
                result = true;
                break;
            } else if (target < n.val) {
                node = n.left;
            } else if (target > n.val) {
                node = n.right;
            }
        }

        return result;
    }
};

pub fn from_list(values: []const i32) ?*BSTNode {
    const allocator = std.heap.page_allocator;
    if (values.len == 0) return null;

    // Create the root node
    const root = allocator.create(BSTNode) catch |err| {
        std.debug.print("Error allocating memory for root node: {any}\n", .{err});
        return null;
    };
    root.* = BSTNode{
        .val = values[0],
        .left = null,
        .right = null,
    };

    // Insert remaining values into the tree
    for (values[1..]) |value| {
        _ = insert(root, value);
    }

    return root;
}

pub fn insert(root: *BSTNode, value: i32) struct { inserted: bool, node: ?*BSTNode } {
    var result_left = false;
    var result_right = false;
    if (value == root.val) {}

    if (value < root.val) {
        if (root.left) |left| {
            const result = insert(left, value);
            result_left = result.inserted;
            return .{ .inserted = false, .node = root };
        } else {
            const new_node = std.heap.page_allocator.create(BSTNode) catch |err| {
                std.debug.print("Error allocating memory for new node: {any}\n", .{err});
                return .{ .inserted = false, .node = null };
            };
            new_node.* = BSTNode{ .val = value, .left = null, .right = null };
            root.left = new_node;
            return .{ .inserted = true, .node = root };
        }
    }
    if (value > root.val) {
        if (root.right) |right| {
            const result = insert(right, value);
            result_right = result.inserted;
            return .{ .inserted = false, .node = root };
        } else {
            const new_node = std.heap.page_allocator.create(BSTNode) catch |err| {
                std.debug.print("Error allocating memory for new node: {any}\n", .{err});
                return .{ .inserted = false, .node = null };
            };
            new_node.* = BSTNode{ .val = value, .left = null, .right = null };
            root.right = new_node;
            return .{ .inserted = true, .node = root };
        }
    }
    return .{ .inserted = result_right or result_right, .node = root };
}

fn _recursive_insert() ?*BSTNode {}

pub fn test_from_list() !*BSTNode {
    const values = &[_]i32{ 10, 5, 15, 3, 7, 20, 99, 1, 2, 4, 6, 8, 9 };

    const nullroot = from_list(values);
    if (nullroot) |root| {
        try std.testing.expect(root.contains(10));
        try std.testing.expect(root.contains(5));
        try std.testing.expect(root.contains(15));
        try std.testing.expect(root.contains(3));
        try std.testing.expect(root.contains(7));
        try std.testing.expect(root.contains(20));
        try std.testing.expect(root.contains(99));
        try std.testing.expect(root.contains(10));
        try std.testing.expect(root.contains(5));
        try std.testing.expect(root.contains(15));
        try std.testing.expect(root.contains(3));
        try std.testing.expect(root.contains(7));
        try std.testing.expect(root.contains(20));
        try std.testing.expect(root.contains(99));
        try std.testing.expect(root.contains(1));
        try std.testing.expect(root.contains(2));
        try std.testing.expect(root.contains(4));
        try std.testing.expect(root.contains(6));
        try std.testing.expect(root.contains(8));
        try std.testing.expect(root.contains(9));
        return root;
    } else {
        const allocator = std.heap.page_allocator;
        const node = allocator.create(BSTNode) catch |err| {
            std.debug.print("Error allocating memory for root node: {any}\n", .{err});
            return err;
        };
        defer allocator.destroy(node);
        return node;
    }
}
test "test_from list" {
    const allocator = std.heap.page_allocator;
    const values = &[_]i32{ 10, 5, 15, 3, 7, 20 };

    const root = try from_list(values);
    defer allocator.destroy(root);

    try std.testing.expect(root.contains(10)); // root
    try std.testing.expect(root.contains(5)); // left child
    try std.testing.expect(root.contains(15)); // right child
    try std.testing.expect(root.contains(3)); // left-left child
    try std.testing.expect(root.contains(7)); // left-right child
    try std.testing.expect(root.contains(20)); // right-right child
    try std.testing.expect(!root.contains(99)); // not in tree
}
test "test_manual" {
    const allocator = std.heap.page_allocator;

    const root = try allocator.create(BSTNode);
    root.* = BSTNode{
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
