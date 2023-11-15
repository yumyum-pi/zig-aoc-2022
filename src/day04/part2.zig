const utils = @import("utils");
const std = @import("std");
const print = std.debug.print;

const LINEBREAK = utils.ASCII.LINEBREAK;
const DASH: u8 = 45;
const COMMA: u8 = 44;
const assignment = [2]u64;

var n: u64 = 0;
pub fn solution(input: []const u8) u64 {
    var elfs: [2]assignment = undefined;
    @memset(&elfs[0], 0);
    @memset(&elfs[1], 0);
    var isAssignment2: bool = false;

    // capture the digit
    var digit: u64 = 0;
    // capture the digit length
    var digit_len: u8 = 0;
    var sum: u64 = 0;
    for (input) |char| {
        switch (char) {
            LINEBREAK => {
                elfs[1][1] = digit;
                sum += compare_assignment(&elfs);
                rest_digit(&digit, &digit_len);
                isAssignment2 = false;
                n += 1;
            },
            COMMA => {
                // separate the elf
                isAssignment2 = true;
                elfs[0][1] = digit;
                rest_digit(&digit, &digit_len);
            },
            DASH => {
                if (isAssignment2) {
                    elfs[1][0] = digit;
                    rest_digit(&digit, &digit_len);
                    continue;
                }
                elfs[0][0] = digit;
                rest_digit(&digit, &digit_len);
            },
            else => {
                utils.String_to_int(&digit, char, digit_len);
                digit_len += 1;
            },
        }
    }
    return sum;
}

var first_elf: assignment = undefined;
var second_elf: assignment = undefined;
fn compare_assignment(elfs: *[2]assignment) u64 {
    var result: u64 = 0;
    // which is bigger
    if (elfs[0][0] < elfs[1][0]) {
        first_elf = elfs[0];
        second_elf = elfs[1];
    } else {
        first_elf = elfs[1];
        second_elf = elfs[0];
    }

    if (first_elf[1] >= second_elf[0]) {
        result = 1;
    }
    return result;
}

fn rest_digit(digit: *u64, digit_len: *u8) void {
    digit.* = 0;
    digit_len.* = 0;
}
