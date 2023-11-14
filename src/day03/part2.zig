const utils = @import("utils");
const std = @import("std");
const print = std.debug.print;

const MAX_LINE_LEN = 48;
const NumRange = utils.ASCII.Numbers;
const LINEBREAK = utils.ASCII.LINEBREAK;

const line_type = [MAX_LINE_LEN]u8;
const GRP_SIZE = 3;

pub fn solution(input: []const u8) u64 {
    // store the line
    var line_grp: [GRP_SIZE]line_type = undefined;
    var len_grp: [GRP_SIZE]u8 = [GRP_SIZE]u8{ 0, 0, 0 };
    var grp_index: usize = 0;
    var sum: u64 = 0;

    for (input) |char| {
        switch (char) {
            LINEBREAK => {
                if (grp_index >= 2) {
                    // compare here
                    sum += find_common(&line_grp, len_grp);
                    reset_line(&len_grp, &grp_index);
                    continue;
                }
                grp_index += 1;
            },
            else => {
                line_grp[grp_index][len_grp[grp_index]] = char;
                len_grp[grp_index] += 1;
            },
        }
    }

    return sum;
}

fn reset_line(len_grp: *[GRP_SIZE]u8, grp_index: *usize) void {
    grp_index.* = 0;
    len_grp[0] = 0;
    len_grp[1] = 0;
    len_grp[2] = 0;
}

var common: [53]u8 = undefined;
var c: u8 = 0;
var index: usize = 0;
fn find_common(line_grp: *[3]line_type, len_grp: [3]u8) u64 {
    // create a common cacter list
    @memset(&common, 0);
    c = 0;
    index = 0;

    // find common in line 0
    while (index < len_grp[0]) {
        c = Char_to_u8(line_grp[0][index]);
        common[c] = 1;
        index += 1;
    }

    index = 0;
    // find common in line 1
    while (index < len_grp[1]) {
        c = Char_to_u8(line_grp[1][index]);
        if (common[c] == 1) {
            common[c] = 2;
        }
        index += 1;
    }

    index = 0;
    // find common in line 2
    while (index < len_grp[2]) {
        c = Char_to_u8(line_grp[2][index]);
        if (common[c] == 2) {
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
