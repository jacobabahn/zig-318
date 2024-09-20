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

pub fn canPlaceWord(r: usize, c: usize, wordLen: isize, size: usize, direction: []const isize) bool {
    const nr: isize = @intCast(r);
    const nc: isize = @intCast(c);
    const row = nr + @as(isize, direction[0]) * @as(isize, wordLen);
    const col = nc + @as(isize, direction[1]) * @as(isize, wordLen);
    return row >= 0 and row < size and col >= 0 and col < size;
}

pub fn placeWords(grid: LetterMatrix, words: std.ArrayList([]const u8)) void {
    const size = grid.len;
    const directions = [_][2]isize{
        .{ 1, 0 },
        .{ 0, 1 },
        .{ -1, 0 },
        .{ 0, -1 },
        .{ 1, 1 },
        .{ -1, 1 },
        .{ 1, -1 },
        .{ -1, -1 },
    };

    outer: for (words.items) |word| {
        var direction = directions[std.crypto.random.intRangeAtMost(usize, 0, directions.len - 1)];
        inner: while (true) {
            const row = std.crypto.random.intRangeAtMost(usize, 0, size - 1);
            const col = std.crypto.random.intRangeAtMost(usize, 0, size - 1);
            const wordLen: isize = @intCast(word.len);
            if (canPlaceWord(row, col, wordLen, size, &direction)) {
                placeWord(grid, word, row, col, &direction) catch |err| {
                    std.debug.print("{any}: {d}, col: {d}\n", .{ err, row, col });
                    continue :inner;
                };
                std.debug.print("placed word at row: {d}, col: {d}\n", .{ row, col });
                continue :outer;
            }
            direction = directions[std.crypto.random.intRangeAtMost(usize, 0, directions.len - 1)];
        }
    }
}

pub fn placeWord(grid: LetterMatrix, word: []const u8, row: usize, col: usize, direction: []isize) !void {
    const nrow: isize = @intCast(row);
    const ncol: isize = @intCast(col);
    for (word, 0..) |letter, i| {
        const idx: usize = i;
        const newRow: usize = @intCast(nrow + direction[0] * @as(isize, @intCast(idx)));
        const newCol: usize = @intCast(ncol + direction[1] * @as(isize, @intCast(idx)));
        if (grid[newRow][newCol] != '.') {
            return error.WordCollision;
        }
        grid[newRow][newCol] = letter;
    }
}

pub fn generatePuzzle(matrix: LetterMatrix) !LetterMatrix {
    // var matrix = try allocator.alloc([]u8, size);

    for (0..matrix.len) |i| {
        // matrix[i] = try allocator.alloc(u8, size);
        for (0..matrix[i].len) |j| {
            if (matrix[i][j] != '.') {
                continue;
            }

            const letter = std.crypto.random.intRangeAtMost(u8, 65, 90);
            matrix[i][j] = letter;
        }
    }

    return matrix;
}

pub fn emptyPuzzle(allocator: std.mem.Allocator, size: usize) !LetterMatrix {
    var matrix = try allocator.alloc([]u8, size);

    for (0..size) |i| {
        matrix[i] = try allocator.alloc(u8, size);
        @memset(matrix[i], '.'); // Initialize each row with '.'
    }

    return matrix;
}
