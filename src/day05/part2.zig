const utils = @import("utils");
const std = @import("std");
const print = std.debug.print;
const allocator = std.heap.page_allocator;

const stackErr = error{
    stackOverFlow,
    stackUnderFlow,
};

const LINEBREAK = utils.ASCII.LINEBREAK;
const NUMBER = utils.ASCII.Numbers;
const SPACE: u8 = 32;

const STACK_SIZE = 64;
const stack = struct {
    data: [STACK_SIZE]u8,
    size: usize,
    fn push(self: *stack, u: u8) !void {
        if (self.size >= STACK_SIZE) {
            return stackErr.stackOverFlow;
        }

        self.data[self.size] = u;
        self.size += 1;

        return;
    }

    fn pop(self: *stack) !void {
        if (self.size <= 0) {
            return stackErr.stackUnderFlow;
        }

        self.size -= 1;
        self.data[self.size] = 0;

        return;
    }
    fn top(self: *stack) !u8 {
        if (self.size <= 0) {
            return stackErr.stackUnderFlow;
        }
        return self.data[self.size - 1];
    }

    fn print(self: *stack) void {
        var s: []const u8 = &self.data;
        if (self.size > 0) {
            for (0..self.size) |i| {
                std.debug.print("{s} ", .{s[i .. i + 1]});
            }
        }
        std.debug.print("\n", .{});
    }

    fn rest(self: *stack) void {
        @memset(&self.data, 0);
        self.size = 0;
    }

    fn reverse(self: *stack, temp: *stack) !void {
        temp.rest();
        while (self.size > 0) {
            try temp.push(try self.top());
            try self.pop();
        }

        for (temp.data, 0..) |d, i| {
            self.data[i] = d;
        }
        self.size = temp.size;
    }
};

fn NewStack() stack {
    return stack{
        .data = undefined,
        .size = 0,
    };
}
var crates_n: u64 = 0;
pub fn solution(input: []const u8) ![]const u8 {
    const input_len = input.len;
    //    var move_start_position: u64 = 0;
    var index: u64 = 0;
    var line_len: u64 = 0;

    // find the length no of creates
    index = 3;
    while (true) {
        if (input[index] == LINEBREAK) {
            break;
        }
        index += 1;
    }
    line_len = index + 1;
    crates_n = line_len / 4;

    var crates = try allocator.alloc(stack, crates_n);
    defer allocator.free(crates);
    var temp_crate: stack = NewStack();

    // extract each create
    for (0..crates_n) |i| {
        crates[i].size = 0;
        index = try extract_crate(input, &crates[i], line_len, i);
        try crates[i].reverse(&temp_crate);
    }

    // loop over movements
    index += 4;
    var char: u8 = 0;
    var no: u64 = 0;
    var position: u8 = 0;
    var move_list: [3]u64 = undefined;
    @memset(&move_list, 0);
    var move_list_n: usize = 0;

    while (index < input_len) {
        char = input[index];
        switch (char) {
            LINEBREAK => {
                //reset
                move_list[move_list_n] = no;
                move_list_n = 0;
                try move_crates(&crates, &move_list);
                //print_crates(&crates);
                rest_number(&no, &position);
            },
            NUMBER.Start...NUMBER.End => {
                // record the number
                utils.String_to_int(&no, char, position);
                position += 1;
            },
            SPACE => {
                // increase the number
                if (no != 0) {
                    move_list[move_list_n] = no;
                    move_list_n += 1;
                }
                rest_number(&no, &position);
            },
            else => {},
        }
        index += 1;
    }

    var sum: []const u8 = undefined;
    sum = try get_tops(&crates);
    return sum;
}

fn rest_number(no: *u64, position: *u8) void {
    no.* = 0;
    position.* = 0;
}

fn extract_crate(input: []const u8, crate: *stack, line_len: u64, n: u64) !u64 {
    var char: u8 = 0;
    var v_line: u64 = 0;
    var j = n * 4 + 1;
    while (true) {
        char = input[j + v_line * line_len];
        switch (char) {
            SPACE => {},
            48...57 => {
                break;
            },
            else => {
                crate.push(char) catch |err| {
                    print("Err:{any}\n{s}", .{ err, input[j + v_line * line_len .. j + 10 + v_line * line_len] });
                    return 0;
                };
            },
        }

        v_line += 1;
    }
    return j + v_line * line_len;
}

fn move_crates(crates: *[]stack, moves: *[3]u64) !void {
    const n = moves[0];
    const f_i = moves[1] - 1; // from index
    const t_i = moves[2] - 1; // to index

    //var c_t = crates[t_i];
    // copy element to
    // from start point
    const c_f_start = crates.*[f_i].size - n;
    const c_t_start = crates.*[t_i].size;
    for (0..n) |i| {
        crates.*[t_i].data[c_t_start + i] = crates.*[f_i].data[c_f_start + i];
        crates.*[f_i].data[c_f_start + i] = 0;
    }
    // update size of from and to
    crates.*[t_i].size += n;
    crates.*[f_i].size = c_f_start;
}

fn print_crates(crates: *[]stack) void {
    var cs = crates.*;

    for (0..crates_n) |n| {
        print("{d}: ", .{n});
        cs[n].print();
    }
}

fn get_tops(crates: *[]stack) ![]u8 {
    var cs = crates.*;
    var tops: []u8 = try allocator.alloc(u8, crates_n);
    for (0..crates_n) |n| {
        tops[n] = try cs[n].top();
    }

    return tops;
}
