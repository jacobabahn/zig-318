const std = @import("std");
const data: []const u8 = @embedFile("words.txt");

pub fn main() !void {
    var splits = std.mem.splitSequence(u8, data, " ");
    while (splits.next()) |word| {
        std.debug.print("{s}\n", .{word});
    }
}
