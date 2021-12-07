const std = @import("std");
const fmt = std.fmt;
const fs = std.fs;

///function that pulls input from a text file at a day #
/// returns a 2d array of u8s, one per line.
/// TODO: get this documention better - this will improve as I understand the language better
// pub fn getInputLines(comptimtme day: u8) ![][]u8{
//     return @embedFile(fmt."../../input/day_{}
// }

//read each line in the file and place each line into the returned 2d array

//}

pub fn total(comptime T: type, values: []const T) i64 {
    var sum: i64 = 0;
    for (values) |val| sum += val;
    return sum;
}
