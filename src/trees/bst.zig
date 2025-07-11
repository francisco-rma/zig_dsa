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

pub fn from_list() ?*BSTNode {}

test "manual binary tree up to 3 levels" {
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
