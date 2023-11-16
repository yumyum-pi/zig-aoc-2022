const std = @import("std");
const print = @import("std").debug.print;
const fs = std.fs;
const time = std.time;

const solution = @import("./part1.zig").solution;
//const solution = @import("./part2.zig").solution;

const file_path = "./input";
const test_file = "test_input";

var file = @embedFile(file_path);
//var file = @embedFile(test_file);

pub fn main() !void {
    const start_time: f64 = @floatFromInt(time.nanoTimestamp());

    const ans = solution(file);

    const end_time: f64 = @floatFromInt(time.nanoTimestamp());
    const ns = end_time - start_time;
    const ms = ns / 1000000;
    print("time taken:\t{!d}ms\n", .{ms});
    print("ans: {!d}\n", .{ans});
}
