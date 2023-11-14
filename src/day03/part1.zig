const utils = @import("utils");
const std = @import("std");
const print = std.debug.print;

const MAX_LINE_LEN = 48;
const NumRange = utils.ASCII.Numbers;
const LINEBREAK = utils.ASCII.LINEBREAK;

const line_type = [MAX_LINE_LEN]u8;

pub fn solution(input: []const u8) u64 {
    // store the line
    var line: line_type = undefined;
    var line_len: usize = 0;
    var sum: u64 = 0;

    for (input) |char| {
        switch (char) {
            LINEBREAK => {
                sum += find_common(&line, line_len);
                //var s: []const u8 = &line;
                //print("line: {s}\n", .{s});
                // reset and do somethings
                reset_line(&line_len);
            },
            else => {
                line[line_len] = char;
                line_len += 1;
            },
        }
    }

    return sum;
}

fn reset_line(len: *usize) void {
    len.* = 0;
}

fn find_common(line: *line_type, len: usize) u64 {
    var common: [53]bool = undefined;
    var c: u8 = 0;
    var len_half: usize = 0;
    var index: usize = 0;
    // create a common cacter list
    @memset(&common, false);
    c = 0;
    len_half = len / 2;

    index = 0;

    while (index < len_half) {
        c = Char_to_u8(line[index]);
        common[c] = true;
        index += 1;
    }

    while (index < len) {
        c = Char_to_u8(line[index]);
        if (common[c]) {
            return c;
        }
        index += 1;
    }

    return 0;
}

fn Char_to_u8(char: u8) u8 {
    if (char > 95) {
        return char - 96;
    }
    return char - 38;
}
