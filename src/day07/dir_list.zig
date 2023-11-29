const std = @import("std");
const print = std.debug.print;
const Allocator = std.mem.Allocator;

const initialCap = 1280;

const DIR_LIST_ERR = error{
    OutOfBound,
    MemAlloc,
    AllocationFailed,
};

pub const DIR_LIST_TYPE = struct {
    data: []u8,
    len: usize,
    cap: usize,
    alloc: Allocator,

    pub fn init(alloc: std.mem.Allocator) !DIR_LIST_TYPE {
        const data = try alloc.alloc(u8, initialCap);
        return DIR_LIST_TYPE{
            .data = data,
            .len = 0,
            .cap = initialCap,
            .alloc = alloc,
        };
    }
    pub fn push(self: *DIR_LIST_TYPE, input_string: *const []u8) !usize {
        const stringLen = input_string.len;
        const totalN = stringLen + self.len + 1;
        // check if input data fits
        if (totalN > self.cap) {
            // add input data to data
            // increase the length
            try self.grow();
        }
        const insertAt = self.len;
        self.data[self.len] = @intCast(input_string.len);
        self.len += 1;
        @memcpy(self.data[self.len .. self.len + stringLen], input_string.*);
        self.len += stringLen;
        return insertAt;
    }

    pub fn getData(n: usize) []u8 {
        _ = n;
        return []u8{"x"};
    }

    pub fn deinit(self: *DIR_LIST_TYPE) !void {
        self.alloc.free(self.data.ptr[0..self.cap]);
    }

    fn grow(self: *DIR_LIST_TYPE) !void {
        print("grow", .{});
        const newCap = self.cap * 2;

        // try to resize the existing memory block
        // if resizing fail, allocate a new block of memory
        const newMem = try self.alloc.alignedAlloc(u8, null, newCap);

        // copy existing memory
        @memcpy(newMem[0..self.len], self.data[0..self.len]);

        // free old block
        self.alloc.free(self.data);

        //update the data
        self.data = newMem;
        self.cap = newCap;
    }
};
