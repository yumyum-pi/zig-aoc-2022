const std = @import("std");
const print = @import("std").debug.print;
const fs = std.fs;
const time = std.time;

//const solution = @import("./part1.zig").solution;
const solution = @import("./part2.zig").solution;

const file_path = "./input";
const test_file = "test_input";

var file = @embedFile(file_path);
//var file = @embedFile(test_file);

pub fn main() !void {
    const start_time: i128 = time.nanoTimestamp();

    const ans = try solution(file);

    const end_time: i128 = time.nanoTimestamp();
    const delta: f64 = @floatFromInt(end_time - start_time);
    const ms: f64 = delta / 1000000;
    print("time taken:\t{!d}ms\n", .{ms});
    print("ans: {!d}\n", .{ans});
}
