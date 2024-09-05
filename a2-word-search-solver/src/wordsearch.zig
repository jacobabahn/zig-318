const std = @import("std");
const lm = @import("lettermatrix.zig");

pub fn solve(puzzle: lm.LetterMatrix, wordlist: std.ArrayList([]const u8)) lm.LetterMatrix {
    for (wordlist.items) |word| {
        std.debug.print("{s}\n", .{word});
    }
    std.debug.print("\n", .{});
    return puzzle;
}
