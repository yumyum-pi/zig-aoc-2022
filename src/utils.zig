pub const RangeU8 = struct { Start: u8, End: u8 };

const ascii_struct = struct {
    Numbers: RangeU8,
    LINEBREAK: u8,
    SPACE: u8,
};

// Function converst string to unsigned int. Using this funtion over string ittrator
// i: pointer to the current u64.
// char: the character to add to current
// position: Position of the number;
pub fn String_to_int(current: *u64, char: u8, position: u8) void {
    const i = Char_to_int(char);
    // increate the place of the number. from 10 -> 100
    if (position != 0) {
        current.* = current.* * @as(u64, 10);
    }
    current.* += i;
}

pub const ASCII = ascii_struct{
    .Numbers = RangeU8{
        .Start = 48,
        .End = 57,
    },
    .LINEBREAK = 10,
    .SPACE = 32,
};

// Function converts ASCII number to unsigned int
// The caller should make sure the char value is between
pub fn Char_to_int(char: u8) u64 {
    return @intCast(char - ASCII.Numbers.Start);
}

// utf-8 reference: https://www.charset.org/utf-8
