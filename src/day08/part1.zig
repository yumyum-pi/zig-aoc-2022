const utils = @import("utils");
const std = @import("std");
const Allocator = std.mem.Allocator;
const print = std.debug.print;

const LINEBREAK = utils.ASCII.LINEBREAK;
const SPACE = utils.ASCII.SPACE;
const ASCI_RED = "\x1b[1;31m";
const ASCI_BLUE = "\x1b[1;34m";
const ASCI_REST = "\x1b[0m";

var input_len: u64 = 0;
var char: u8 = 0;
var sum: u64 = 0;

var size: u64 = 0;
var trimed_r: u64 = 0;
var trimed_c: u64 = 0;
var input: []const u8 = undefined;
pub fn solution(i: []const u8) !u64 {
    input = i;
    var index: u64 = 0;
    print("\n", .{}); // just a spacer
    const allocator = std.heap.page_allocator;
    _ = allocator;
    input_len = input.len;

    // calc the char in 1st row
    while (index < input_len) {
        if (input[index] == LINEBREAK) {
            // break the loop
            // add the index = width
            break;
        }
        index += 1;
    }

    size = index;
    trimed_r = size - 1;
    trimed_c = size - 1;

    index = 0;

    var inner: u64 = 0;
    for (1..trimed_r) |r| {
        const index_row_start = (size + 1) * r;

        for (1..trimed_c) |c| {
            index = c + index_row_start;
            if (is_visible(r, c, index)) {
                inner += 1;
                print(ASCI_RED ++ "{d}" ++ ASCI_REST, .{input[index] - 48});
            } else {
                print("{d}", .{input[index] - 48});
            }
        }
        print("\n", .{});
    }

    const outer = (size - 1) * 4;

    print("outer:{d}\tinner:{d}\n", .{ outer, inner });
    sum = outer + inner;
    return sum;
}

// return true if visible from any side
pub fn is_visible(row_n: u64, col_n: u64, index_current: u64) bool {
    var visible: bool = false;
    //visible = check_visibility_row(row_n, col_n);

    // check if visible from the top
    visible = is_visible_row(0, row_n, col_n, index_current);
    // if visible from the top then return
    if (visible) {
        return true;
    }

    // else if not visible, check the bottom
    visible = is_visible_row(row_n + 1, size, col_n, index_current);
    if (visible) {
        return true;
    }

    // check the column only if not visible
    //visible = check_visibility_column(row_n, col_n);
    // check if visible from the left
    visible = is_visible_column(0, col_n, row_n, index_current);
    // if visible from the left then return
    if (visible) {
        return true;
    }

    // if not visible from the left check right
    visible = is_visible_column(col_n + 1, size, row_n, index_current);
    return visible;
}

// check vertical side: either top or bottom depending on the start and end
fn is_visible_row(start: usize, end: usize, col_n: u64, index_current: u64) bool {
    const s = size + 1;
    var index_to_check: u64 = 0;

    // loop through each rows start to end
    // check for each row until found a char greater than current var
    // if the char is greater than current char then not visible
    for (start..end) |r| {
        index_to_check = col_n + (s * r);

        // visible if surrounding tree are small than current char
        if (input[index_to_check] >= input[index_current]) {
            // return true if visible
            return false;
        }
    }

    return true;
}

// check horizontal side: either left or right depending on the start and end
fn is_visible_column(start: usize, end: usize, row_n: u64, index_current: u64) bool {
    const s = size + 1;
    var index_to_check: u64 = 0;

    for (start..end) |c| {
        index_to_check = c + (s * row_n);

        if (input[index_to_check] >= input[index_current]) {
            return false;
        }
    }

    return true;
}
