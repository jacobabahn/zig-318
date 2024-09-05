const std = @import("std");
const lm = @import("lettermatrix.zig");
const solve = @import("wordsearch.zig").solve;

const LetterMatrix = [][]u8;

const NUM_WORDS = 10;

// Reads NUM_WORDS words from the standard input and places them into an array.
// Next, it reads in a word search puzzle into the LetterMatrix `puzzle`.
fn getPuzzle(words: *[][]const u8, puzzle: *LetterMatrix) !void {
    _ = words;
    _ = puzzle;
    return error.NotImplemented;
    // Ensure word list is initially empty
    // words.* = &[_][]const u8{};
    //
    // // Load the word list
    // var stdin = std.io.getStdIn().reader();
    // var allocator = std.heap.page_allocator;
    //
    // for (NUM_WORDS) |_| {
    //     var word_buffer = try std.ArrayList(u8).init(&allocator);
    //     try stdin.readUntilDelimiterOrEofAlloc(&allocator, word_buffer.writer(), ' ');
    //     try words.append(word_buffer.toOwnedSlice());
    // }
    // try stdin.readUntilDelimiterOrEofAlloc(&allocator, word_buffer.writer(), '\n');
    //
    // // Load the puzzle
    // try readMatrix(puzzle);
}

// Main function, equivalent to `int main()` in C++
pub fn wspuzzle() !void {
    var word_list: [][]const u8 = &[_][]const u8{};
    var puz: LetterMatrix = LetterMatrix.init();

    // Get the puzzle and word list from input
    try getPuzzle(&word_list, &puz);

    // Print the list of words
    var stdout = std.io.getStdOut().writer();
    for (word_list) |word| {
        stdout.print("{s}\n", .{word});
    }
    stdout.print("\n", .{});

    // Print the puzzle
    lm.printMatrix(puz);

    // Solve the puzzle
    const ans = solve(puz, word_list);

    // Print the solution
    lm.printMatrix(ans);
}
