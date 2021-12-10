const std = @import("std");
const fmt = std.fmt;
const fs = std.fs;

//const inputDirPath = "../../inputs";

/// function that pulls input from a text file at a day #
/// returns a slice containing the entire file
/// TODO: get this documention better - this will improve as I understand the language better
pub fn getInputLines(comptime day: u8, max_size: u64) ![]u8{
    var gen_alloc = std.heap.GeneralPurposeAllocator(.{}){};
    

    const inputDir = try fs.cwd().openDir("inputs", .{});
    //defer inputDir.close();

    var day_input : [12]u8 = undefined;
    const filename = try fmt.bufPrint(day_input[0..], "day_{:0>2}.txt", .{day});

    //TODO: Catch error and pull new file if necessisary 
    const inputFile: fs.File = try inputDir.openFile(filename, .{});
    //defer inputFile.close();

    return inputFile.reader().readAllAlloc(gen_alloc.allocator(), max_size); 

}

pub fn getInputDir() ![]u8{
    var buffer : [4096]u8 = undefined;
    
    return fs.cwd().realpath("inputs", buffer[0..]);
}

/// Returns the total of the values of type T contained in the slice Values.
pub fn total(comptime T: type, values: []const T) i64 {
    var sum: i64 = 0;
    for (values) |val| sum += val;
    return sum;
}

/// returns a bool representing if the list values of type T contain item
pub fn listContains(comptime T: type, values: []const T, item: T) bool{
    for(values) |val|{
        if (val == item) return true;
    }
    return false;
}