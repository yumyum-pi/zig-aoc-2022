const utils = @import("utils");
const std = @import("std");
const print = std.debug.print;
const allocator = std.heap.page_allocator;

const window_size = 4;

pub fn solution(input: []const u8) u64 {
    const input_len = input.len - 1;
    var char_freq = [_]i64{0} ** 28;
    var char: u64 = 0;
    var collision: i64 = 0;
    var index: u64 = 0;

    // initial window
    while (index < window_size) {
        char = char_to_az(input[index]);

        // add the char to the char_freq
        char_freq[char] += 1;

        // check if char already exists
        if (char_freq[char] > 1) {
            collision += 1;
        }

        index += 1;
    }

    while (index < input_len) {
        //remove the preview char
        char = char_to_az(input[index - window_size]);

        if (char_freq[char] > 1) {
            collision -= 1;
        }
        char_freq[char] -= 1;

        // check if char already exists

        // add the char to the char_freq
        char = char_to_az(input[index]);
        char_freq[char] += 1;

        if (char_freq[char] > 1) {
            collision += 1;
        }

        if (collision == 0) {
            return index + 1;
        }

        index += 1;
    }

    print("unique: {d}\n", .{collision});

    return 0;
}
fn char_to_az(char: u8) u64 {
    return char - 96;
}
