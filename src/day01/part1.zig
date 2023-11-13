const utils = @import("utils");
const NumRange = utils.ASCII.Numbers;

const CharReaderErr = error{
    UnknownChar,
};

const LINEBREAK: u8 = 10;
pub fn solve(input: []const u8) !u64 {
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
                    // new elf
                    elf_len += 1;
                    if (max < sum) {
                        max = sum;
                    }
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
    return max;
}

fn line_rest(calarise: *u64, char_len: *u8) void {
    calarise.* = 0;
    char_len.* = 0;
}
