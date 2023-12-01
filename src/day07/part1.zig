const utils = @import("utils");
const std = @import("std");
const Allocator = std.mem.Allocator;
const print = std.debug.print;

const File_Explorer = @import("./file_explorer.zig").File_Explorer;
const New_File_Explorer = @import("./file_explorer.zig").New_File_Explorer;

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

var sum: u64 = 0;

const min_size = 100000;

const root_dir_string: *const []u8 = "/";

var FE: File_Explorer = undefined;
pub fn solution(input: []const u8) !u64 {
    const buffer = try fba.alloc(u8, BUFFER_SIZE);
    const allocator = std.heap.page_allocator;
    var buffer_len: u8 = 0;

    input_len = input.len;

    // TODO make the root dir
    // skipped the root dir
    index = 7;
    FE = New_File_Explorer(allocator, "/");

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
                        try parse_cd(buffer, buffer_len);
                        //print("root dir name ptr: {}\n", .{&rootDir.name});
                    },
                    // $ ls
                    108 => {
                        // parse ls
                    },
                    // dir directory name
                    114 => {
                        // parse dr
                        try parse_dir(buffer, buffer_len, allocator);
                    },
                    // file size
                    else => {
                        // parse file
                        try parse_file(buffer, buffer_len);
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

    // FE.print_file_list();
    sum = FE.calcSize();
    return sum;
}

// rest the line state
fn reset_line(buffer: []u8, buffer_len: *u8) void {
    @memset(buffer, 0);
    buffer_len.* = 0;

    new_cmd = false;
}

fn parse_cd(buffer: []u8, buffer_len: u8) !void {
    // $ cd
    // handle the back cmd
    if (buffer[5] == 46 and buffer[6] == 46) {
        FE.back();
        return;
    }

    // cd to dir
    var name = buffer[5..buffer_len];

    FE.cd(name);
}

fn parse_dir(buffer: []u8, buffer_len: u8, allocator: Allocator) !void {
    _ = allocator;
    const name = buffer[4..buffer_len];
    try FE.addDir(name);
}

fn parse_file(buffer: []u8, buffer_len: u8) !void {
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

    sum += size;
    const name = buffer[i..buffer_len];
    // 4060174 j
    // a way to store this info
    try FE.addFile(name, size);
}
