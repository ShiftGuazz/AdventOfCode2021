const std = @import("std");
const util = @import("aoc_util");
const print = std.debug.print;
const fmt = std.fmt;

const input = @embedFile("../../inputs/day_01.txt");

pub fn main() !void {
    print("---Part 1 result---\n", .{});
    print("Result: {d}\n", .{part1()});
    print("---Part 2 result---\n", .{});
    print("result: {d}\n", .{part2()});
}

pub fn part1() !u32 {
    var increases: u32 = 0;
    var lines = std.mem.tokenize(input, "\n");

    var num: i32 = try fmt.parseInt(i32, lines.next().?, 10);

    while (lines.next()) |line| {
        var curNum: i32 = try fmt.parseInt(i32, line, 10);

        if (curNum > num) increases += 1;
        num = curNum;
    }

    return increases;
}

pub fn part2() !u32 {
    var increases: u32 = 0;
    var lines = std.mem.tokenize(input, "\n");

    var curWin = [3]i32{
        try fmt.parseInt(i32, lines.next().?, 10),
        try fmt.parseInt(i32, lines.next().?, 10),
        try fmt.parseInt(i32, lines.next().?, 10),
    };

    var nextWin = [3]i32{
        curWin[1],
        curWin[2],
        0,
    };

    var curSum: i64 = undefined;
    var nextSum: i64 = undefined;

    while (lines.next()) |line| {
        nextWin[2] = try fmt.parseInt(i32, line, 10);

        curSum = util.total(i32, curWin[0..]);
        nextSum = util.total(i32, nextWin[0..]);

        //print("curSum = {}, nextSum = {}\n", .{ curSum, nextSum });

        if (nextSum > curSum) {
            increases += 1;
        }

        curWin = nextWin[0..].*;

        nextWin[0] = nextWin[1];
        nextWin[1] = nextWin[2];
    }
    return increases;
}
