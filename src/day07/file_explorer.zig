const std = @import("std");
const string = []const u8;
const Allocator = std.mem.Allocator;
const Hash_String = std.StringHashMap(u64);

const dir_table_header = [_]string{ "index", "name", "dir count", "file count", "size", "parent_index" };
const table_col_size = 16;

const File = struct {
    name: string,
    parent_index: u64, // parent index
    size: u64, // total size of file
};

const Index_List = std.ArrayList(u64);
const File_List = std.ArrayList(File);

const Dir = struct {
    name: string,
    file_index_list: Index_List, // store the index of file
    dir_list: Index_List, // store the index of dir
    tree: Hash_String,
    parent_index: u64,
    size: u64, // total size of Dir
};

const Dir_List = std.ArrayList(Dir);

pub const File_Explorer = struct {
    current_dir: u64, // index to the current dir
    dir_list: Dir_List,
    file_list: File_List,
    allocator: Allocator,

    pub fn addFile(self: *File_Explorer, name: string, size: u64) !void {
        const parent_index = 0;
        var n = try self.allocator.alloc(u8, name.len);
        @memcpy(n[0..], name);

        var file = File{
            .parent_index = parent_index,
            .size = size,
            .name = n,
        };

        const index = self.file_list.items.len;
        try self.file_list.append(file);

        // add file to current dir
        try self.dir_list.items[self.current_dir].file_index_list.append(index);
    }

    pub fn cd(self: *File_Explorer, name: string) void {
        // serach from current dir if name exist

        if (self.dir_list.items[self.current_dir].tree.get(name)) |index| {
            self.current_dir = index;
        } else {
            std.os.exit(8);
        }
        // if index is correct , change current dir to index
    }

    pub fn back(self: *File_Explorer) void {
        self.current_dir = self.dir_list.items[self.current_dir].parent_index;
    }

    pub fn addDir(self: *File_Explorer, name: string) !void {
        var n = try self.allocator.alloc(u8, name.len);
        @memcpy(n[0..], name);

        // create a new dir
        var dir = Dir{
            .name = n,
            .file_index_list = Index_List.init(self.allocator),
            .dir_list = Index_List.init(self.allocator),
            .parent_index = self.current_dir,
            .tree = Hash_String.init(self.allocator),
            .size = 0,
        };

        // add to the main dir list
        const index = self.dir_list.items.len;
        self.dir_list.append(dir) catch |err| {
            std.debug.print("err:{any}\n", .{err});
            std.os.exit(1);
        };

        // attach the dir to current dir
        try self.dir_list.items[self.current_dir].tree.put(n, index);
        try self.dir_list.items[self.current_dir].dir_list.append(index);
    }

    pub fn calcSize(self: *File_Explorer) u64 {
        var dir_index = self.dir_list.items.len - 1;
        var sum: u64 = 0;

        while (dir_index > 0) {
            // calcuate the file size
            for (self.dir_list.items[dir_index].file_index_list.items) |file_index| {
                self.dir_list.items[dir_index].size += self.file_list.items[file_index].size;
            }

            // calcuate the dir size
            for (self.dir_list.items[dir_index].dir_list.items) |subdir_index| {
                self.dir_list.items[dir_index].size += self.dir_list.items[subdir_index].size;
            }

            if (self.dir_list.items[dir_index].size <= 100000) {
                sum += self.dir_list.items[dir_index].size;
            }
            dir_index -= 1;
        }

        return sum;
    }

    pub fn print_file_list(self: *File_Explorer) void {
        const len = self.file_list.items.len;

        std.debug.print("\n", .{});
        var i: usize = 0;
        var file: File = undefined;

        while (i < len) {
            file = self.file_list.items[i];
            std.debug.print("Name:{s:<16}\tsize:{d:<16}\tparent_index:{d}\n", .{ file.name, file.size, file.parent_index });
            i += 1;
        }
    }

    pub fn print_dir_list(self: *File_Explorer) void {
        const len = self.dir_list.items.len;

        std.debug.print("\n", .{});
        var i: usize = 0;
        var dir: Dir = undefined;
        for (dir_table_header) |h| {
            std.debug.print("| {s:<16} ", .{h});
        }
        std.debug.print("|\n", .{});
        while (i < len) {
            dir = self.dir_list.items[i];
            std.debug.print("| {d:<16} ", .{i});
            std.debug.print("| {s:<16} ", .{dir.name});
            std.debug.print("| {d:<16} ", .{dir.dir_list.items.len});
            std.debug.print("| {d:<16} ", .{dir.file_index_list.items.len});
            std.debug.print("| {d:<16} ", .{dir.size});
            std.debug.print("| {d:<16} ", .{dir.parent_index});
            std.debug.print("|\n", .{});
            i += 1;
        }
    }
};

// TODO create File_explorer
pub fn New_File_Explorer(allocator: Allocator, root: string) File_Explorer {
    _ = root;
    var f = File_Explorer{
        .allocator = allocator,
        .current_dir = 0,
        .dir_list = Dir_List.init(allocator),
        .file_list = File_List.init(allocator),
    };

    // create a new dir
    var dir = Dir{
        .name = "/",
        .file_index_list = Index_List.init(allocator),
        .dir_list = Index_List.init(allocator),
        .parent_index = 0,
        .tree = Hash_String.init(allocator),
        .size = 0,
    };

    // add to the main dir list
    f.dir_list.append(dir) catch |err| {
        std.debug.print("err:{any}\n", .{err});
        std.os.exit(1);
    };

    return f;
}
