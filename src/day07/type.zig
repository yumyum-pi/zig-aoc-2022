pub const dir = struct {
    name: []u8,
    parent: ?dir, // index for dir
    childs_dir: []dir, // index for children dir
    files: []file, // index for files
};

pub const file = struct {
    name: []u8, // file name
    parent: dir, // index for parent
    size: u64, // file size
};

pub fn newDir(
    name: []u8,
    parent: ?*dir,
) dir {
    return dir{
        .name = name,
        .parent = parent,
    };
}
