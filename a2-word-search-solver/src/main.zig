const std = @import("std");
const lm = @import("lettermatrix.zig");
const ws = @import("wspuzzle.zig");
const solve = @import("wordsearch.zig").solve;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const matrix = try lm.generatePuzzle(allocator, 10);
    defer freePuzzle(allocator, matrix);

    // try lettermatrix.readMatrix(&grid);
    var wordList = std.ArrayList([]const u8).init(allocator);
    defer wordList.deinit();
    try wordList.append("Mary");
    try wordList.append("Its");
    try wordList.append("And");
    try wordList.append("the");

    const grid = solve(matrix, wordList);
    lm.printMatrix(grid);

    std.debug.print("\n", .{});

    lm.placeWords(grid, wordList);
    lm.printMatrix(grid);
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
