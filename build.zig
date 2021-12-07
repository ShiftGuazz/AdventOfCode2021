const std = @import("std");
const Builder = std.build.Builder;
const LibExeObjStep = std.build.LibExeObjStep;

const should_link_libc = false;
const nameFile = @embedFile("ExeNames");

// const ExeNames = [_][]const u8{
//     "sonar-
// }

const test_files = [_][]const u8{
    //list files with tests here
};

fn linkObject(b: *Builder, obj: *LibExeObjStep) void {
    if (should_link_libc) obj.linkLibC();
    _ = b;

    // Add linking for packages or third party libraries here
    obj.addPackagePath("aoc_util", "src/helpers.zig");

}


pub fn build(b: *Builder) void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});

    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();

    const install_all = b.step("install_all", "Install all days");
    const run_all = b.step("run_all", "Run all days");

    var day: u8 = 1;
    var names = std.mem.tokenize(u8, nameFile, "\n");

    while(names.next()) |name| : (day += 1){
        const dayString = b.fmt("day-{:0>2}", .{day});
        const zigFile = b.fmt("src/{s}/{s}.zig", .{dayString, name});

        const exe = b.addExecutable(name, zigFile);
        exe.setTarget(target);
        exe.setBuildMode(mode);
        linkObject(b, exe);

        exe.install();

        const install_cmd = b.addInstallArtifact(exe);

        const step_key = b.fmt("install_{s}", .{dayString});
        const step_desc = b.fmt("Install {s}.exe", .{name});
        const install_step = b.step(step_key, step_desc);
        install_step.dependOn(&install_cmd.step);
        install_all.dependOn(&install_cmd.step);

        const run_cmd = exe.run();
        run_cmd.step.dependOn(&install_cmd.step);
        if(b.args) |args| {
            run_cmd.addArgs(args);
        }

        const run_desc = b.fmt("Run {s}", .{name});
        const run_step = b.step(dayString, run_desc);
        run_step.dependOn(&run_cmd.step);
        run_all.dependOn(&run_cmd.step);
    }

    
    //const exe = b.addExecutable("AdventOfCode2021", "src/day-1/sonar-sweep.zig");
    //exe.setTarget(target);
    //exe.setBuildMode(mode);
    //linkObject(b, exe);
    
    
    //exe.install();

    // const run_cmd = exe.run();
    // run_cmd.step.dependOn(b.getInstallStep());
    // if (b.args) |args| {
    //     run_cmd.addArgs(args);
    // }

    // const run_step = b.step("run", "Run the app");
    // run_step.dependOn(&run_cmd.step);
}
