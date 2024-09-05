const std = @import("std");
const main = @import("main.zig");

pub const LetterMatrix = [][]u8;
pub const LetterMatrix2 = [10][10]u8;

// Prints a 2D matrix of letters.
// os: the output stream to send the data (can be the console or a text file).
// grid: the matrix to print.
pub fn printMatrix(grid: LetterMatrix) void {
    for (grid) |row| {
        for (row) |cell| {
            std.debug.print("{c} ", .{cell});
        }
        std.debug.print("\n", .{});
    }
}

// Reads a 2D matrix of letters from an input stream.
// grid: the matrix to fill.
pub fn readMatrix(grid: *LetterMatrix) !void {
    var stdin = std.io.getStdIn().reader();
    // create the grid
    grid.* = undefined;
    var line_buffer: [128]u8 = undefined; // A temporary buffer to hold the input

    while (try stdin.readUntilDelimiterOrEofAlloc(&std.heap.page_allocator, &line_buffer, '\n')) |line| {
        if (line.len > 0) {
            var row: []u8 = undefined;
            for (line) |ch| {
                if (ch >= 'A' and ch <= 'Z') {
                    row = try std.array.push(ch); // Collect valid letters into the row
                }
            }
            if (row.len > 0) {
                try grid.push(row); // Append the row to the matrix
            }
        }
    }
}

pub fn canPlaceWord(r: usize, c: usize, wordLen: usize, size: usize, direction: []usize) bool {
    const row = r + @as(usize, direction[0]) * wordLen;
    const col = c + @as(usize, direction[1]) * wordLen;
    return row >= 0 and row < size and col >= 0 and col < size;
}

pub fn placeWords(grid: LetterMatrix, words: std.ArrayList([]const u8)) void {
    const size = grid.len;
    const directions = [_][2]usize{
        .{ @as(usize, 1), @as(usize, 0) },
        .{ @as(usize, 0), @as(usize, 1) },
        // .{ @as(usize, -1), @as(usize, 0) },
        // .{ @as(usize, 0), @as(usize, -1) },
        // .{ @as(usize, 1), @as(usize, 1) },
        // .{ @as(usize, -1), @as(usize, 1) },
        // .{ @as(usize, 1), @as(usize, -1) },
        // .{ @as(usize, -1), @as(usize, -1) },
    };

    for (words.items) |word| {
        for (grid, 0..) |row, i| {
            for (row, 0..) |_, j| {
                var direction = directions[std.crypto.random.intRangeAtMost(usize, 0, directions.len - 1)];
                while (true) {
                    if (canPlaceWord(i, j, word.len, size, &direction)) {
                        placeWord(grid, word, .{ @as(usize, i), @as(usize, j) }, direction);
                        break;
                    }
                    direction = directions[std.crypto.random.intRangeAtMost(usize, 0, directions.len - 1)];
                }
            }
        }
    }
}

pub fn placeWord(grid: LetterMatrix, word: []const u8, start: []usize, direction: []usize) void {
    const row = start[0];
    const col = start[1];

    for (word, 0..) |letter, i| {
        grid[row + direction[0] * i][col + direction[1] * i] = letter;
    }
}

pub fn generatePuzzle(allocator: std.mem.Allocator, size: usize) !LetterMatrix {
    var matrix = try allocator.alloc([]u8, size);

    for (0..size) |i| {
        matrix[i] = try allocator.alloc(u8, size);
        for (0..size) |j| {
            const letter = std.crypto.random.intRangeAtMost(u8, 65, 90);
            matrix[i][j] = letter;
        }
    }

    return matrix;
}

pub fn emptyPuzzle(allocator: std.mem.Allocator, size: usize) !LetterMatrix {
    var matrix = try allocator.alloc([]u8, size);

    for (0..size) |i| {
        // matrix[i] = allocator.alloc(u8, size) |err| {
        //     freePuzzleRows(allocator, matrix, i); // Free rows up to this point if allocation fails
        //     return err;
        // };
        matrix[i] = try allocator.alloc(u8, size);
        @memset(matrix[i], '.'); // Initialize each row with '.'
    }

    return matrix;
}
