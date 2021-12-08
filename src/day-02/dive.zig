const std = @import("std");
const util = @import("aoc_util");
const print = std.debug.print;
const fmt = std.fmt;

const input = @embedFile("../../input/day_02.txt");

pub fn main() !void {
    print("Input directory is: {s}", .{try util.getInputDir()});
    print("---Part 1 result---\n", .{});
}
