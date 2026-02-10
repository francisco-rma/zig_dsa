const std = @import("std");
const assert = std.debug.assert;
const allocator = std.heap.page_allocator;

pub fn AllocateZeroMatrix(rows: usize, cols: usize) ![][]i32 {
    const matrix: [][]i32 = try allocator.alloc([]i32, rows);
    errdefer allocator.free(matrix);

    for (matrix) |*row| {
        row.* = try allocator.alloc(i32, cols);
        errdefer allocator.free(row.*);
        for (row.*) |*col| {
            col.* = 0; // Initialize the matrix with zeros
        }
    }

    return matrix;
}
pub fn main() !void {
    const zeroes = AllocateZeroMatrix(2, 2) catch |err| {
        std.debug.print("Error allocating matrix: {}\n", .{err});
        return err;
    };
    std.debug.print("Zeroes:\n", .{});
    print_matrix(zeroes);
    print_matrix(zeroes);

    const A = AllocateZeroMatrix(2, 2) catch |err| {
        std.debug.print("Error allocating matrix: {}\n", .{err});
        return err;
    };
    A[0][0] = 1;
    A[0][1] = 0;
    A[1][0] = 0;
    A[1][1] = 1;
    std.debug.print("A:\n", .{});
    print_matrix(A);

    const B = AllocateZeroMatrix(2, 2) catch |err| {
        std.debug.print("Error allocating matrix: {}\n", .{err});
        return err;
    };
    B[0][0] = 1;
    B[0][1] = 2;
    B[1][0] = 3;
    B[1][1] = 4;
    std.debug.print("B:\n", .{});
    print_matrix(B);

    const result = multiply(A, B);
    if (result) |r| {
        std.debug.print("RESULT:\n", .{});
        print_matrix(r);
    }
}

pub fn print_matrix(matrix: [][]i32) void {
    for (matrix) |row| {
        for (row) |val| {
            std.debug.print("{d} ", .{val});
        }
        std.debug.print("\n", .{});
    }
}

pub fn dot_product(a: []i32, b: []i32) i32 {
    var result: i32 = 0;
    for (a, b) |val_a, val_b| {
        result += val_a * val_b;
    }
    return result;
}

pub fn multiply(a: [][]i32, b: [][]i32) ?[][]i32 {
    assert(a.len == b[0].len);
    assert(a[0].len == b.len);

    var result = AllocateZeroMatrix(a.len, b[0].len) catch |err| {
        std.debug.print("Error allocating result matrix: {}\n", .{err});
        return null;
    };

    for (0..a.len) |i| {
        for (0..b[0].len) |j| {
            std.debug.print("i: {d}\n", .{i});
            std.debug.print("j: {d}\n", .{j});
            result[i][j] = dot_product(a[i][0..], b[0..][j]);
            std.debug.print("a_row: {d}\n", .{a[i][0..]});
            std.debug.print("b_col: {d}\n", .{b[0..][j]});
            std.debug.print("b_row: {d}\n", .{b[j][0..]});
            std.debug.print("b: {d}\n", .{b});
            std.debug.print("result[{d}][{d}] = {d}\n", .{ i, j, result[i][j] });
        }
    }
    return result;
}
