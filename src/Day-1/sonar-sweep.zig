const std = @import("std");
const print = std.debug.print;
const fmt = std.fmt;

const input = @embedFile("../../inputs/day_01.txt");


pub fn main() !void{
    print("Result: {d}\n", .{ part1() });
}

pub fn part1() !u32{
    var increases: u32 = 0;
    var lines = std.mem.tokenize(input, "\n");
    

    var num: i32 = try fmt.parseInt(i32, lines.next().?, 10);

    while(lines.next()) |line|{
        var curNum : i32 = try fmt.parseInt(i32, line, 10);  
        
        if(curNum > num) increases += 1; 
        num = curNum;
    }

    return increases;

    // for(lines) |line, i|{
    //     var curNum: u32 = fmt.parseInt(u32, line);
    //     var nextNum: u32 = if(i != lines.length) fmt.parseInt(u32, lines[i + 1]) else break;

    //     if(nextNum > curNum){
    //         increases += 1;
    //     }
    // }
}