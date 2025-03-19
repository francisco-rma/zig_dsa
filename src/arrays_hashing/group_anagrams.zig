const std = @import("std");
const assert = std.debug.assert;
const expect = std.testing.expect;

pub fn group_anagram(words: [][]const u8) void {
    for (words) |word| {
        std.debug.print("\n{s}", .{word});
    }
}

pub fn is_anagram(s: []const u8, t: []const u8) bool {
    assert(s.len == t.len);
    var i: usize = 0;

    while (i < (s.len / 2)) {
        if (s[i] != t[s.len - 1 - i]) return false;
        i += 1;
    }

    return true;
}

test "anagram_validation" {
    const s = "liquidificador";
    const t = "rodacifidiuqil";

    const result = is_anagram(s, t);

    std.debug.print("Test result is: {any}\n", .{result});

    try expect(result == true);
}

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    const path = "C:/Users/User/projetos/zig_dsa/src/arrays_hashing/group_anagram_test.txt";

    const file = try std.fs.cwd().openFile(path, .{ .mode = .read_only });
    defer file.close();

    var reader = file.reader();
    var line_count: usize = 0;
    var buffer: [1024]u8 = undefined;

    while (true) {
        const bytes_read = try reader.read(&buffer);
        if (bytes_read == 0) break;
        for (buffer[0..bytes_read]) |byte| {
            if (byte == '\n')
                line_count += 1;
        }
    }

    // std.log.info("\nFile line count is: {d}\n", .{line_count});

    var word_slice: [][]u8 = try allocator.alloc([]u8, line_count);
    defer allocator.free(word_slice);

    try file.seekTo(0);

    var i: u8 = 0;

    while (i < line_count) {
        var line_start: usize = 0;
        var idx: usize = 0;

        const bytes_read = try reader.read(&buffer);

        if (bytes_read == 0) break;

        for (buffer[0..bytes_read]) |byte| {
            if (byte == '\n') {
                // std.log.info("\nNew line found!\n", .{});
                word_slice[i] = buffer[line_start..idx];
                i += 1;
                line_start = idx + 1;
            }
            idx += 1;
        }
    }

    // std.debug.print("\nArray size: {d}\n", .{word_slice.len});
    // var idx: usize = 0;
    // for (word_slice[0..word_slice.len]) |word| {
    //     std.debug.print("\nword: {s}", .{word});
    //     std.debug.print("\nindex: {d} -- value: {s}\n", .{ idx, word });
    //     idx += 1;
    // }

    group_anagram(word_slice);
}
