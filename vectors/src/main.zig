const std = @import("std");

//------------------------------------------------
// Returns the maximum value in array v.
// The result is undefined if v is empty.
pub fn maximum(v: []const i32) i32 {
    if (v.len == 0) {
        return undefined;
    }

    var max: i32 = 0;
    for (v) |value| {
        if (value > max) {
            max = value;
        }
    }
    return max;
}

//------------------------------------------------
// Returns the position of the value seek
// within array v.
// Returns -1 if seek is not an element of v.
pub fn find(v: []const i32, seek: i32) i32 {
    for (v, 0..) |value, index| {
        if (value == seek) {
            return @intCast(index);
        }
    }
    return -1;
}

//------------------------------------------------
// Returns the number of times the value seek
// appears within array v.
// Returns 0 if seek is not an element of v.
pub fn count(v: []const i32, seek: i32) i32 {
    var seek_count: i32 = 0;

    for (v) |value| {
        if (value == seek) {
            seek_count += 1;
        }
    }
    return seek_count;
}

//------------------------------------------------
// Returns true if arrays v1 and v2 contain
// exactly the same elements, regardless of their
// order; otherwise, the function returns false.
pub fn equivalent(v1: []const i32, v2: []const i32) !bool {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    var v1_map = std.AutoHashMap(i32, i32).init(allocator);
    defer v1_map.deinit();
    for (v1) |value| {
        if (v1_map.contains(value)) {
            const val: i32 = v1_map.get(value).? + 1;
            try v1_map.put(value, val);
        } else {
            try v1_map.put(value, 1);
        }
    }

    var v2_map = std.AutoHashMap(i32, i32).init(allocator);
    defer v2_map.deinit();
    for (v2) |value| {
        if (v2_map.contains(value)) {
            const val: i32 = v2_map.get(value).? + 1;
            try v2_map.put(value, val);
        } else {
            try v2_map.put(value, 1);
        }
    }

    if (v1_map.count() != v2_map.count()) {
        return false;
    }

    var iter = v1_map.keyIterator();
    while (iter.next()) |key| {
        if (v2_map.get(key.*) != v1_map.get(key.*)) {
            return false;
        }
    }
    return true;
}

//------------------------------------------------
// Physically rearranges the elements of v
// so they appear in order from lowest value.
pub fn sort(v: []i32) void {
    quicksort(v, 0, v.len - 1);
}

fn quicksort(v: []i32, start: usize, end: usize) void {
    // base case size <= 1
    if (start >= end) {
        return;
    }
    const pivotIdx = partition(v, start, end);
    if (pivotIdx > 0) {
        quicksort(v, start, pivotIdx - 1);
    }
    quicksort(v, pivotIdx + 1, end);
}

fn partition(v: []i32, start: usize, end: usize) usize {
    const pivotVal = v[end];
    var pivotIdx = start;
    for (start..end) |index| {
        if (v[index] <= pivotVal) {
            const temp = v[index];
            v[index] = v[pivotIdx];
            v[pivotIdx] = temp;
            pivotIdx += 1;
        }
    }

    const temp = v[pivotIdx];
    v[pivotIdx] = v[end];
    v[end] = temp;

    return pivotIdx;
}

//------------------------------------------------
// Removes the first occurrence of element
// seek from array v.
// The function returns true if an element is
// removed; otherwise, it returns false.
pub fn remove_first(v: []i32, del: i32) bool {
    var index: usize = 0;
    while (index < v.len) {
        if (v[index] == del) {
            while (index < v.len - 1) {
                v[index] = v[index + 1];
                index += 1;
            }
            return true;
        }
        index += 1;
    }
    return false;
}

pub fn main() !void {
    var v = [_]i32{ 2, 1, 0, 7, 3, 7, 10, 8 };
    const max = maximum(&v);
    std.debug.assert(max == 10);
    std.debug.print("max: {d}\n", .{max});

    const find_v = find(&v, 7);
    std.debug.print("find: {d}\n", .{find_v});

    const count_v = count(&v, 7);
    std.debug.print("count: {d}\n", .{count_v});

    sort(&v);
    std.debug.print("sort: {any}\n", .{v});
    // std.debug.assert(!equivalent(&v, sorted));

    var v1 = [_]i32{ 2, 1, 0, 7, 3, 10, 8 };
    var v2 = [_]i32{ 2, 1, 0, 7, 3, 10, 8 };
    var v3 = [_]i32{ 2, 1, 0, 7, 3, 10, 9 };

    const equiv = try equivalent(&v1, &v2);
    std.debug.print("equiv: {any}\n", .{equiv});

    const equiv2 = try equivalent(&v1, &v3);
    std.debug.print("equiv2: {any}\n", .{equiv2});

    std.debug.print("not removed: {any}\n", .{v1});
    const rem = remove_first(&v1, 7);
    if (rem) {
        std.debug.print("remove_first: {any}\n", .{v1});
    }
}
