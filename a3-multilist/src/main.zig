const std = @import("std");

pub const Node = struct {
    id: i32,
    name: []const u8,
    age: i32,
    prev_id: ?*Node,
    next_id: ?*Node,
    prev_name: ?*Node,
    next_name: ?*Node,
    prev_age: ?*Node,
    next_age: ?*Node,

    pub fn init(id: i32, name: []const u8, age: i32) Node {
        return .{
            .id = id,
            .name = name,
            .age = age,
            .prev_id = null,
            .next_id = null,
            .prev_name = null,
            .next_name = null,
            .prev_age = null,
            .next_age = null,
        };
    }
};

pub const Multilist = struct {
    allocator: std.mem.Allocator,
    first: ?*Node,
    last: ?*Node,

    pub fn init(allocator: std.mem.Allocator) !Multilist {
        var list = Multilist{
            .allocator = allocator,
            .first = null,
            .last = null,
        };

        var first_sentinel = try allocator.create(Node);
        first_sentinel.* = Node.init(0, "SentinelFirst", 0); // Sentinel values

        var last_sentinel = try allocator.create(Node);
        last_sentinel.* = Node.init(0, "SentinelLast", 0); // Sentinel values

        first_sentinel.next_id = last_sentinel;
        last_sentinel.prev_id = first_sentinel;

        list.first = first_sentinel;
        list.last = last_sentinel;

        return list;
    }

    pub fn deinit(self: *Multilist) void {
        var current = self.first;
        while (current) |node| {
            current = node.next_id;
            self.allocator.destroy(node);
        }
    }

    pub fn insert(self: *Multilist, node: *Node) !void {
        try idInsert(self, node);
        try ageInsert(self, node);
        // nameInsert(self, node);
    }

    fn idInsert(list: *Multilist, node: *Node) !void {
        var current = list.first;
        while (current) |curr_node| {
            if ((curr_node.id > node.id) or (curr_node == list.last)) {
                node.next_id = curr_node;
                node.prev_id = curr_node.prev_id;
                curr_node.prev_id.?.next_id = node;
                curr_node.prev_id = node;
                // std.debug.print("Inserted node: {any}\n", .{node.id});
                break;
            }
            current = curr_node.next_id;
        }
    }
    fn ageInsert(list: *Multilist, node: *Node) !void {
        var current = list.first;
        while (current) |curr_node| {
            if ((curr_node.age > node.age) or (curr_node == list.last)) {
                node.next_age = curr_node;
                node.prev_age = curr_node.prev_age;
                curr_node.prev_age.?.next_age = node;
                curr_node.prev_age = node;
                std.debug.print("Inserted node: {any}\n", .{node.id});
                break;
            }
            current = curr_node.next_age;
        }
    }
    // fn nameInsert(list: *Multilist, node: *Node) !void {}
};

pub fn printByAge(list: Multilist) void {
    std.debug.print("Printing by age\n", .{});
    var current = list.first;
    while (current) |node| {
        if (node == list.first or node == list.last) {
            current = node.next_age;
            continue;
        }
        std.debug.print("Node: {any}\n", .{node.id});
        current = node.next_age;
    }
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var ml = try Multilist.init(allocator);
    const node1 = try allocator.create(Node);
    const node2 = try allocator.create(Node);
    const node3 = try allocator.create(Node);
    const node4 = try allocator.create(Node);
    node1.* = Node.init(1, "Node1", 10);
    node2.* = Node.init(2, "Node2", 20);
    node3.* = Node.init(4, "Node3", 30);
    node4.* = Node.init(3, "Node4", 15);
    try ml.insert(node1);
    try ml.insert(node2);
    try ml.insert(node3);
    try ml.insert(node4);
    defer ml.deinit();
    // printByAge(ml);
    var current = ml.first;
    while (current) |node| {
        if (node == ml.first or node == ml.last) {
            current = node.next_id;
            continue;
        }
        std.debug.print("Node ID: {d}, Name: {s}, Age: {d}\n", .{ node.id, node.name, node.age });
        current = node.next_id;
    }
    // std.debug.print("Multilist: {any}\n", .{ml.first.?.next_id});
}
