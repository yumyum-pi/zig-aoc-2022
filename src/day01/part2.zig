const utils = @import("utils");
const print = @import("std").debug.print;
const NumRange = utils.ASCII.Numbers;

const CharReaderErr = error{
    UnknownChar,
};

const LINEBREAK: u8 = 10;
pub fn solution(input: []const u8) !u64 {
    var sum: u64 = 0;
    var calarise: u64 = 0;
    var char_len: u8 = 0;
    var prev: u8 = 0;
    var elf_len: u8 = 0;
    var max: u64 = 0;
    _ = max;
    var top: [3]u64 = [3]u64{ 0, 0, 0 };

    for (input) |char| {
        switch (char) {
            LINEBREAK => {
                if (prev == LINEBREAK) {
                    // new elf
                    elf_len += 1;
                    // check if in the top 3
                    ifTop(&top, sum);
                    sum = 0;
                    continue;
                }
                sum = sum + calarise;
                line_rest(&calarise, &char_len);
            },
            NumRange.Start...NumRange.End => {
                utils.String_to_int(&calarise, char, char_len);
                char_len += 1;
            },
            else => {
                return CharReaderErr.UnknownChar;
            },
        }
        prev = char;
    }
    return SumTop(top);
}

fn ifTop(top: *[3]u64, max: u64) void {
    if (top[2] >= max) {
        return;
    }
    top[2] = max;

    if (top[1] >= max) {
        return;
    }
    top[2] = top[1];
    top[1] = max;

    if (top[0] >= max) {
        return;
    }
    top[1] = top[0];
    top[0] = max;
}

fn SumTop(top: [3]u64) u64 {
    var sum: u64 = 0;

    for (top) |i| {
        sum += i;
    }
    return sum;
}

fn line_rest(calarise: *u64, char_len: *u8) void {
    calarise.* = 0;
    char_len.* = 0;
}
