const std = @import("std");
const print = @import("std").debug.print;
const fs = std.fs;
const time = std.time;

const file_path = "./input";
const test_file = "/Users/vivekrawat/dev/aoc-zig/2022/day1/test_input";

var file = @embedFile(file_path);

pub fn main() !void {
    const start_time: f64 = @floatFromInt(time.nanoTimestamp());
    const max = part1(file);
    _ = try max;

    const end_time: f64 = @floatFromInt(time.nanoTimestamp());
    const ns = end_time - start_time;
    const ms = ns / 1000000;
    print("time taken: {!d}\n", .{ms});
    //print("max: {!d}\n", .{max});
}

const LINEBREAK: u8 = 10;
pub fn part1(input: []const u8) !u64 {
    const stdout = std.io.getStdOut().writer();
    _ = stdout;
    var sum: u64 = 0;
    var calarise: u64 = 0;
    var char_len: u8 = 0;
    var prev: u8 = 0;
    var elf_len: u8 = 0;
    var max: u64 = 0;
    for (input) |char| {
        switch (char) {
            LINEBREAK => {
                if (prev == LINEBREAK) {
                    // new element
                    elf_len += 1;
                    if (max < sum) {
                        max = sum;
                    }
                    sum = 0;
                    continue;
                }
                sum = sum + calarise;
                calarise = 0;
                char_len = 0;
            },
            48...57 => {
                calarise = run_to_digit(calarise, char, char_len);
                char_len += 1;
            },
            else => {
                print("unknown charactor: {!}\n", .{char});
            },
        }
        prev = char;
    }
    return max;
}

fn line_rest(calarise: *u64, char_len: *u8) void {
    calarise.* = 0;
    char_len.* = 0;
}

const multipler: u8 = 10;

fn run_to_digit(calarise: u64, char: u8, char_len: u8) u64 {
    const digit = run_to_int(char);
    var val: u64 = 0;
    if (char_len != 0) {
        val = calarise * multipler;
    }

    val = val + digit;
    return val;
}

const zero_u8: u8 = 48;
fn run_to_int(char: u8) u64 {
    const int: u64 = @intCast(char - zero_u8);
    return int;
}
