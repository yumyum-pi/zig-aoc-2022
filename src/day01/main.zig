const std = @import("std");
const print = @import("std").debug.print;
const fs = std.fs;
const time = std.time;

const part1 = @import("./part1.zig");

const file_path = "./input";
const test_file = "/Users/vivekrawat/dev/aoc-zig/2022/day1/test_input";

var file = @embedFile(file_path);

pub fn main() !void {
    const start_time: f64 = @floatFromInt(time.nanoTimestamp());
    const max = try part1.solve(file);

    const end_time: f64 = @floatFromInt(time.nanoTimestamp());
    const ns = end_time - start_time;
    const ms = ns / 1000000;
    print("time taken: {!d}ms\n", .{ms});
    print("max: {!d}\n", .{max});
}
