const std = @import("std");
const util = @import("aoc_util");
const print = std.debug.print;
const fmt = std.fmt;
const mem = std.mem;

//const input = @embedFile("../../input/day_02.txt");

const instruction = enum{fwd, up, down};
const forward = "forward";
const up = "up";
const down = "down";

const sub_cmd = struct{
    inst: instruction, value: u16,
};

const sub_pos = struct{
    depth: i64 = 0, distance: i64 = 0,
};


pub fn main() !void {
    print("---Part 1 result---\n", .{});
    print("{}\n", .{try part1()});
    print("---Part 2 result---\n", .{});
    print("{}", .{try part2()});
}

pub fn part1() !i64{
    //initialize sub position
    var position = sub_pos{};

    //pull and tokenize the file input, each line is one command
    const input: []u8 = try util.getInputLines(2, 0x2FFF);
    var commands = mem.tokenize(u8, input, "\n");

    //cycle through the lines in the file
    while(commands.next()) |command_str| {
        //tokenize the line
        var command = mem.tokenize(u8, command_str, " ");
        var inst_str = command.next().?;
        var val_str = command.next().?;
        
        // and use it to populate a struct
        var cur_cmd = sub_cmd{
            .inst = parse: { 
                if (mem.eql(u8, forward[0..], inst_str)){
                    break :parse instruction.fwd;
                } else if (mem.eql(u8, up[0..], inst_str)){
                    break :parse instruction.up;
                } else if (mem.eql(u8, down[0..], inst_str)){
                    break :parse instruction.down;
                } else unreachable;
            },
            .value = try fmt.parseInt(u16, val_str, 10),
        };

        switch(cur_cmd.inst){
            instruction.fwd => position.distance += cur_cmd.value,
            instruction.up => position.depth -= cur_cmd.value,
            instruction.down => position.depth += cur_cmd.value,
        }
    }

    return position.depth * position.distance;
}

pub fn part2() !i128{
    //initialize sub position
    var position = sub_pos{};
    var aim :i32 = 0;

    //pull and tokenize the file input, each line is one command
    const input: []u8 = try util.getInputLines(2, 0x2FFF);
    var commands = mem.tokenize(u8, input, "\n");

    //cycle through the lines in the file
    while(commands.next()) |command_str| {
        //tokenize the line
        var command = mem.tokenize(u8, command_str, " ");
        var inst_str = command.next().?;
        var val_str = command.next().?;
        
        // and use it to populate a struct
        var cur_cmd = sub_cmd{
            .inst = parse: { 
                if (mem.eql(u8, forward[0..], inst_str)){
                    break :parse instruction.fwd;
                } else if (mem.eql(u8, up[0..], inst_str)){
                    break :parse instruction.up;
                } else if (mem.eql(u8, down[0..], inst_str)){
                    break :parse instruction.down;
                } else unreachable;
            },
            .value = try fmt.parseInt(u16, val_str, 10),
        };

        switch(cur_cmd.inst){
            instruction.fwd => {
                position.distance += cur_cmd.value;
                position.depth += (cur_cmd.value * aim);
            },
            instruction.up => aim += cur_cmd.value,
            instruction.down => aim -= cur_cmd.value,
        }
        print("aim: {}\n", .{aim});
    }

    return position.depth * position.distance;
}