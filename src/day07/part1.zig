const utils = @import("utils");
const std = @import("std");
const Allocator = std.mem.Allocator;
const print = std.debug.print;

const t = @import("./types.zig");

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

var currentDir: *t.dir = undefined;
const min_size = 100000;

const root_dir_string: *const []u8 = "/";

pub fn solution(input: []const u8) !u64 {
    const buffer = try fba.alloc(u8, BUFFER_SIZE);
    const allocator = std.heap.page_allocator;
    var buffer_len: u8 = 0;

    input_len = input.len;

    // set the root dir
    var rootDir: t.dir = t.newDirRoot("/", allocator);
    //print("root dir ptr: {}\t", .{&rootDir});
    print("root dir name ptr: {}\n", .{&rootDir.name});
    currentDir = &rootDir;
    //print("currentDir: {any}", .{currentDir});
    index = 7;

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
                        //parse_file(buffer, buffer_len);
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
    // a way to store this info
    if (buffer[5] == 46 and buffer[6] == 46) {
        print("back \n", .{});
        currentDir = currentDir.parent.?;
        return;
    }
    var name = buffer[5..buffer_len];

    // search for the sub dir
    var subdir = currentDir.sub_dir.get(name);

    print("cd:{s}\n", .{name});
    // check if sub dir exit
    currentDir = &subdir.?;
}

fn parse_dir(buffer: []u8, buffer_len: u8, allocator: Allocator) !void {
    const name = buffer[4..buffer_len];
    // dir
    // a way to store this info
    print("dir:{s}\t", .{name});

    print("current dir ptr: {}\t", .{&currentDir});
    print("current dir name ptr: {}\n", .{&currentDir.name});
    try t.addDir(currentDir, name, allocator);
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

    if (size > min_size) {
        sum += size;
    }
    // 4060174 j
    // a way to store this info
    print("file:{s} - size:{d}\n", .{ buffer[i..buffer_len], size });
}
