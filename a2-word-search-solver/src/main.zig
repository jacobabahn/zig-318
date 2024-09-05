const std = @import("std");
const lm = @import("lettermatrix.zig");
const ws = @import("wspuzzle.zig");
const solve = @import("wordsearch.zig").solve;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var matrix = try lm.emptyPuzzle(allocator, 15);
    defer freePuzzle(allocator, matrix);

    var wordList = std.ArrayList([]const u8).init(allocator);
    defer wordList.deinit();
    try wordList.append("mary");
    try wordList.append("its");
    try wordList.append("and");
    try wordList.append("the");
    try wordList.append("word");
    try wordList.append("search");
    try wordList.append("solver");

    std.debug.print("Words: {s}\n\n", .{wordList.items});

    lm.placeWords(matrix, wordList);
    matrix = try lm.generatePuzzle(matrix);
    std.debug.print("\nPuzzle:\n", .{});
    lm.printMatrix(matrix);
    matrix = solve(matrix, wordList);
}

pub fn freePuzzle(allocator: std.mem.Allocator, matrix: lm.LetterMatrix) void {
    freePuzzleRows(allocator, matrix, matrix.len);
    allocator.free(matrix);
}

fn freePuzzleRows(allocator: std.mem.Allocator, matrix: lm.LetterMatrix, rows: usize) void {
    for (0..rows) |i| {
        allocator.free(matrix[i]);
    }
}
