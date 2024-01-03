const std = @import("std");
const INF = @as(u32, 0x3f3f3f3f);
const K = @as(u32, 1000000);

// Assumes k is much bigger than 1
fn bfs_1_k(
    source: [2]usize,
    grid: [][]const u8,
    big_rows: []bool,
    big_cols: []bool,
    allocator: *const std.mem.Allocator,
) ![][]u32 {
    const n = grid.len;
    const m = grid[0].len;

    var distance = try allocator.alloc([]u32, n);
    for (distance, 0..) |_, i| {
        distance[i] = try allocator.alloc(u32, m);
        for (distance[i], 0..) |_, j| {
            distance[i][j] = INF;
        }
    }
    distance[source[0]][source[1]] = 0;

    const Queue = std.TailQueue([2]usize);
    var queues = [2]Queue{ Queue{}, Queue{} };
    var node = Queue.Node{ .data = source };
    queues[0].append(&node);

    var qi: u4 = 0;
    while (queues[0].len + queues[1].len > 0) : (qi = (qi + 1) % 2) {
        while (queues[qi].len != 0) {
            const v = queues[qi].popFirst().?.data;
            const i = v[0];
            const j = v[1];

            var weights = [_]u32{ 1, 1, 1, 1 };
            if (big_rows[i]) {
                weights[0] = K;
                weights[1] = K;
            }
            if (big_cols[j]) {
                weights[2] = K;
                weights[3] = K;
            }

            const dx = [_]i32{ -1, 1, 0, 0 };
            const dy = [_]i32{ 0, 0, -1, 1 };

            for (0..4) |dir| {
                const next_i = @as(i128, i) + dx[dir];
                const next_j = @as(i128, j) + dy[dir];
                if (next_i < 0 or next_i >= n) continue;
                if (next_j < 0 or next_j >= m) continue;

                const ni: usize = @intCast(next_i);
                const nj: usize = @intCast(next_j);
                if (distance[ni][nj] > distance[i][j] + weights[dir]) {
                    distance[ni][nj] = distance[i][j] + weights[dir];
                    var next = try allocator.create(Queue.Node);
                    next.* = Queue.Node{ .data = [2]usize{ ni, nj } };
                    if (weights[dir] == 1) {
                        queues[qi].append(next);
                    } else {
                        queues[1 - qi].append(next);
                    }
                }
            }
        }
    }

    return distance;
}

pub fn main() !void {
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var input: [10241024]u8 = undefined;
    _ = try stdin.readAll(&input);

    var splits = std.mem.split(u8, &input, "\n");
    var grid_al = std.ArrayList([]const u8).init(allocator);
    while (splits.next()) |line| {
        // I've tried to check for an empty string, but failed
        if (line[0] == '.' or line[0] == '#') {
            try grid_al.append(line);
        }
    }

    const grid = grid_al.items;
    const n = grid.len;
    const m = grid[0].len;

    var big_rows = try allocator.alloc(bool, n);
    var big_cols = try allocator.alloc(bool, m);

    for (grid, 0..) |line, i| {
        big_rows[i] = true;
        for (line) |c| {
            if (c != '.') big_rows[i] = false;
        }
    }

    for (0..m) |j| {
        big_cols[j] = true;
        for (0..n) |i| {
            if (grid[i][j] != '.') big_cols[j] = false;
        }
    }

    var marks = std.ArrayList([2]usize).init(allocator);
    for (0..n) |i| {
        for (0..m) |j| {
            if (grid[i][j] == '#') {
                try marks.append([_]usize{ i, j });
            }
        }
    }

    var answer: u64 = 0;
    const positions = marks.items;
    for (0..positions.len) |i| {
        const dist = try bfs_1_k(positions[i], grid, big_rows, big_cols, &allocator);
        for (i..positions.len) |j| {
            answer += dist[positions[j][0]][positions[j][1]];
        }
    }

    try stdout.print("{d}\n", .{answer});
}
