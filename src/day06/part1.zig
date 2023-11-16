const utils = @import("utils");
const std = @import("std");
const print = std.debug.print;
const allocator = std.heap.page_allocator;

pub fn solution(input: []const u8) u64 {
    var index: u64 = 0;
    const last_index = input.len - 4;

    // character
    var chars: [4]u64 = undefined;

    // an array of boleans.
    // the index will be used as a character addrss
    // unique[0] is a, unique[1] is b.
    // check is a character exist in the list
    var unique: [27]bool = undefined;
    var is_marching: bool = false;

    while (index < last_index) {
        is_marching = false;
        @memset(&unique, false);

        for (0..4) |i| {
            chars[i] = char_to_az(input[index + i]);
            // if character exist then for loop
            if (unique[chars[i]]) {
                // break to the while loop;
                is_marching = true;
                break;
            }
            unique[chars[i]] = true;
        }
        if (!is_marching) {
            return index + 4;
        }

        index += 1;
    }

    return 0;
}
fn char_to_az(char: u8) u64 {
    if (char == 0) {
        return 0;
    }
    return char - 96;
}
