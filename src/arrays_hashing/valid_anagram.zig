const std = @import("std");
const expect = std.testing.expect;
pub fn valid_anagram(s: []const u8, t: []const u8) bool {
    if (s.len != t.len) return false;

    var i: usize = 0;

    while (i < s.len) {
        if (s[i] != t[s.len - 1 - i]) return false;
        i += 1;
    }

    return true;
}

test "simple_test" {
    var result: bool = false;
    result = valid_anagram("socorrammesubinoonibusemmarrocos", "socorrammesubinoonibusemmarrocos");
    std.debug.print("\nResult is: {any}\n", .{result});
    try expect(result == true);
}
