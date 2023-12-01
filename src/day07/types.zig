const std = @import("std");
const print = std.debug.print;
const stringHashMap = std.StringHashMap;
const Allocator = std.mem.Allocator;

const string = []const u8;

pub fn newDirRoot(name: string, alloc: std.mem.Allocator) dir {
    var dir_list = stringHashMap(dir).init(alloc);
    var file_list = stringHashMap(file).init(alloc);
    return dir{
        .name = name,
        .parent = null,
        .sub_dir = dir_list,
        .files = file_list,
    };
}

pub fn newDir(name: string, parent: *dir, alloc: std.mem.Allocator) !dir {
    var dir_list = stringHashMap(dir).init(alloc);
    var file_list = stringHashMap(file).init(alloc);
    var p = try alloc.create(dir);
    p = parent;
    var d = dir{
        .name = name,
        .parent = p,
        .sub_dir = dir_list,
        .files = file_list,
    };

    return d;
}

pub const dir = struct {
    name: string,
    parent: ?*dir, // index for dir
    sub_dir: stringHashMap(dir), // index for children dir
    files: stringHashMap(file), // index for files
    //

    pub fn print(self: *dir) void {
        std.debug.print("name: {s}\t", .{self.name});
        std.debug.print("dir_count: {d}\t", .{self.sub_dir.count()});
        std.debug.print("file_count: {d}\t", .{self.files.count()});
        std.debug.print("parent: {s}\n", .{self.parent.?.name});
    }
};

pub fn addDir(self: *dir, name: string, alloc: Allocator) !void {
    // create a new memory block
    var n = alloc.alloc(u8, name.len) catch |err| {
        std.debug.print("error:{any}", .{err});
        std.os.exit(15);
    };
    // copy the memory block
    @memcpy(n, name);

    print("self ptr: {}\t", .{&self});
    print("self name ptr: {}\n", .{&self.name});
    var parent = self;

    var dir_list = stringHashMap(dir).init(alloc);
    var file_list = stringHashMap(file).init(alloc);
    var d = dir{
        .name = n,
        .parent = parent,
        .sub_dir = dir_list,
        .files = file_list,
    };

    self.sub_dir.put(n, d) catch |err| {
        std.debug.print("error:{any}", .{err});
        std.os.exit(1);
    };
}

pub const file = struct {
    name: []u8, // file name
    parent: *dir, // index for parent
    size: u64, // file size
};
