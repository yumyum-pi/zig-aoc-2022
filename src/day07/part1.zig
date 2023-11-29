const utils = @import("utils");
const std = @import("std");
const Array = std.ArrayList;
const print = std.debug.print;

const DIR_LIST = @import("./dir_list.zig");
const DIR_LIST_TYPE = DIR_LIST.DIR_LIST_TYPE;

const BUFFER_SIZE = 128;

var fixed_buffer: [BUFFER_SIZE]u8 = undefined;
var fb = std.heap.FixedBufferAllocator.init(&fixed_buffer);
const fba = fb.allocator();

const LINEBREAK = utils.ASCII.LINEBREAK;
const SPACE = utils.ASCII.SPACE;
const CMD_CHAR: u8 = 36;

var index: u64 = 0;
var new_cmd: bool = false;
var input_len: u64 = 0;
var char: u8 = 0;

pub fn solution(input: []const u8) !u64 {
    const buffer = try fba.alloc(u8, BUFFER_SIZE);
    const allocator = std.heap.page_allocator;
    var buffer_len: u8 = 0;

    var dir_list = try DIR_LIST_TYPE.init(allocator);
    input_len = input.len;

    while (index < input_len) {
        char = input[index];
        switch (char) {
            LINEBREAK => {
                char = buffer[2];
                // 3 char for
                // $ cd = c
                // $ ls = l
                // dir = r
                // else its a file
                switch (char) {
                    // $ cd
                    99 => {
                        // parse cmd
                        try parse_cd(buffer, buffer_len, &dir_list);
                    },
                    // $ ls
                    108 => {
                        // parse ls
                    },
                    // dir directory name
                    114 => {
                        // parse dr
                        //parse_dir(buffer, buffer_len);
                    },
                    // file size
                    else => {
                        // parse file
                        // parse_file(buffer, buffer_len);
                    },
                }
                reset_line(buffer, &buffer_len);
            },
            else => {
                buffer[buffer_len] = char;
                buffer_len += 1;
            },
        }

        index += 1;
    }

    //print("data:{s}\nlen:{}, cap:{}\n", .{ dir_list.data, dir_list.len, dir_list.cap });
    return 0;
}

// rest the line state
fn reset_line(buffer: []u8, buffer_len: *u8) void {
    @memset(buffer, 0);
    buffer_len.* = 0;
    new_cmd = false;
}

fn parse_cd(buffer: []u8, buffer_len: u8, dir_list: *DIR_LIST_TYPE) !void {
    // $ cd
    // a way to store this info
    if (buffer[5] == 46 and buffer[6] == 46) {
        //print("cd:back\n", .{});
        return;
    }
    const no = try dir_list.push(&buffer[5..buffer_len]);
    _ = no;
}

fn parse_dir(buffer: []u8, buffer_len: u8) void {
    // dir
    // a way to store this info
    print("dir:{s}\n", .{buffer[4..buffer_len]});
}

fn parse_file(buffer: []u8, buffer_len: u8) void {
    var c: u8 = 0;
    var i: u8 = 0;
    var position: u8 = 0;
    var size: u64 = 0;

    while (i < buffer_len) {
        c = buffer[i];
        switch (c) {
            SPACE => {
                break;
            },
            else => {
                utils.String_to_int(&size, c, position);
                position += 1;
            },
        }
        i += 1;
    }

    // 4060174 j
    // a way to store this info
    print("file:{s} - size:{d}\n", .{ buffer[i..buffer_len], size });
}
