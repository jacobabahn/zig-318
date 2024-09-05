const std = @import("std");
const lm = @import("lettermatrix.zig");

pub fn solve(matrix: lm.LetterMatrix, wordlist: std.ArrayList([]const u8)) lm.LetterMatrix {
    var count: usize = 0;
    outer: for (wordlist.items) |word| {
        for (matrix, 0..) |row, i| {
            for (row, 0..) |_, j| {
                if (matrix[i][j] == word[0]) {
                    const found = checkDirections(matrix, word, i, j);
                    if (found) {
                        count += 1;
                        continue :outer;
                    }
                }
            }
        }
    }

    std.debug.print("Found {d} out of {d} words\n", .{ count, wordlist.items.len });

    return matrix;
}

fn checkDirections(matrix: lm.LetterMatrix, word: []const u8, row: usize, col: usize) bool {
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

    for (directions) |direction| {
        const irow: isize = @intCast(row);
        const icol: isize = @intCast(col);
        const nr: usize = @intCast(irow + direction[0]);
        const nc: usize = @intCast(icol + direction[1]);
        const wordLen: isize = @intCast(word.len);
        var found = false;

        if (!canPlaceWord(row, col, wordLen, matrix.len, &direction)) {
            return false;
        }
        if (matrix[nr][nc] == word[1]) {
            found = checkWord(matrix, word, row, col, &direction);
        }

        if (found) {
            return true;
        }
    }
    return false;
}

fn canPlaceWord(r: usize, c: usize, wordLen: isize, size: usize, direction: []const isize) bool {
    const nr: isize = @intCast(r);
    const nc: isize = @intCast(c);
    const row = nr + @as(isize, direction[0]) * @as(isize, wordLen);
    const col = nc + @as(isize, direction[1]) * @as(isize, wordLen);
    std.debug.print("canPlaceWord: row: {d}, col: {d}\n, direction: {any}\n", .{ row, col, direction });
    return row >= 0 and row < size and col >= 0 and col < size;
}

fn checkWord(matrix: lm.LetterMatrix, word: []const u8, row: usize, col: usize, direction: *const [2]isize) bool {
    // const wordLen: isize = @intCast(word.len);

    const nrow: isize = @intCast(row);
    const ncol: isize = @intCast(col);
    for (word, 1..) |letter, i| {
        const idx: usize = i;
        const newRow: usize = @intCast(nrow + direction[0] * @as(isize, @intCast(idx)));
        const newCol: usize = @intCast(ncol + direction[1] * @as(isize, @intCast(idx)));
        if (newRow < 0 or newCol < 0 or newRow >= matrix.len or newCol >= matrix[0].len) {
            return false;
        }
        if (matrix[newRow][newCol] != letter) {
            return false;
        }
    }

    // for (direction, 0..) |d, i| {
    //     const newRow: usize = @intCast(nrow + d[0] * @as(isize, wordLen));
    //     const newCol: usize = @intCast(ncol + d[1] * @as(isize, wordLen));
    //     if (matrix[newRow][newCol] != word[i]) {
    //         return false;
    //     }
    // }
    // for (0..word.len) |i| {
    //     const newRow: usize = @intCast(nrow + @as(isize, @intCast(i)) * direction[0]);
    //     const newCol: usize = @intCast(ncol + @as(isize, @intCast(i)) * direction[1]);
    //     if (newRow >= matrix.len or newCol >= matrix[0].len or matrix[newRow][newCol] != word[i]) {
    //         return false;
    //     }
    // }
    return true;
}
