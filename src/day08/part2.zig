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
var max_score: u64 = 0;

var size: u64 = 0;
var trimed_r: u64 = 0;
var trimed_c: u64 = 0;
var input: []const u8 = undefined;

var current_score: u64 = 0;

pub fn solution(i: []const u8) !u64 {
    input = i;
    var index: u64 = 0;
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

    for (1..trimed_r) |r| {
        const index_row_start = (size + 1) * r;

        for (1..trimed_c) |c| {
            index = c + index_row_start;
            current_score = get_score(r, c, index);
            if (max_score < current_score) {
                max_score = current_score;
            }
        }
    }

    return max_score;
}

// return true if visible from any side
pub fn get_score(row_n: u64, col_n: u64, index_current: u64) u64 {
    var top: u64 = 0;
    var bottom: u64 = 0;
    var left: u64 = 0;
    var right: u64 = 0;
    top = get_score_top(0, row_n, col_n, index_current);
    left = get_score_left(0, col_n, row_n, index_current);
    right = get_score_column(col_n + 1, size, row_n, index_current);
    bottom = get_score_row(row_n + 1, size, col_n, index_current);

    var score = top * left * right * bottom;

    return score;
}

// TODO optimize this code
//  possible solution
//  - make sure
// check vertical side: either top or bottom depending on the start and end
fn get_score_row(start: usize, end: usize, col_n: u64, index_current: u64) u64 {
    const s = size + 1;
    var index_to_check: u64 = 0;
    var score: u64 = 0;

    // loop through each rows start to end
    // check for each row until found a char greater than current var
    // if the char is greater than current char then not visible
    for (start..end) |r| {
        index_to_check = col_n + (s * r);

        score += 1;
        // visible if surrounding tree are small than current char
        if (input[index_to_check] >= input[index_current]) {
            // return true if visible
            return score;
        }
    }

    return score;
}

fn get_score_top(start: usize, end: usize, col_n: u64, index_current: u64) u64 {
    // check from left right to left
    const s = size + 1;
    var index_to_check: u64 = 0;
    var score: u64 = 0;

    var r = end;

    while (r > start) {
        r -= 1;
        index_to_check = col_n + (s * r);

        score += 1;
        if (input[index_to_check] >= input[index_current]) {
            return score;
        }
    }

    return score;
}

// check horizontal side: either left or right depending on the start and end
fn get_score_column(start: usize, end: usize, row_n: u64, index_current: u64) u64 {
    const s = size + 1;
    var index_to_check: u64 = 0;
    var score: u64 = 0;

    for (start..end) |c| {
        index_to_check = c + (s * row_n);

        score += 1;
        if (input[index_to_check] >= input[index_current]) {
            return score;
        }
    }

    return score;
}

// check horizontal side: either left or right depending on the start and end
fn get_score_left(start: usize, end: usize, row_n: u64, index_current: u64) u64 {
    // check from left right to left
    const s = size + 1;
    var index_to_check: u64 = 0;
    var score: u64 = 0;

    var c = end;

    while (c > start) {
        c -= 1;
        index_to_check = c + (s * row_n);

        score += 1;
        if (input[index_to_check] >= input[index_current]) {
            return score;
        }
    }

    return score;
}
