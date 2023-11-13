const std = @import("std");
const MODE = std.builtin.Mode;

const fs = std.fs;
const print = std.debug.print;

const day_start = 1;
const day_end = 24;

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});

    const mode = MODE.ReleaseFast;

    const utils_modules = b.addModule("utils", .{ .source_file = .{ .path = "src/utils.zig" } });

    for (day_start..day_end) |day_number| {
        const day_string = b.fmt("day{:0>2}", .{day_number});
        const source_file_path = b.fmt("src/{s}/main.zig", .{day_string});
        const exe_name = b.fmt("aoc-{s}", .{day_string});

        // check if file exist
        _ = fs.cwd().openFile(source_file_path, .{}) catch |err| {
            if (err == fs.File.OpenError.FileNotFound) {
                // this can either be break for continue
                // if you are sure that you are solving the problem in a series
                // then break is better
                break;
                // else you should use continue

                // continue;
            }
        };

        // create an excutable for each day
        const exe = b.addExecutable(.{
            .name = exe_name,
            .root_source_file = .{ .path = source_file_path },
            .target = target,
        });
        exe.optimize = mode;

        exe.addModule("utils", utils_modules);
        // create install artifact for each day
        b.installArtifact(exe);

        // create cmd
        const cmd = b.addRunArtifact(exe);
        cmd.step.dependOn(b.getInstallStep());

        // create a step
        const des = b.fmt("Run the solution of {s}", .{day_string});
        const step = b.step(day_string, des);
        step.dependOn((&cmd.step));
    }
}
