const std = @import("std");
const fmt = std.fmt;
const fs = std.fs;

//const inputDirPath = "../../inputs";

/// function that pulls input from a text file at a day #
/// returns a 2d array of u8s, one per line.
/// TODO: get this documention better - this will improve as I understand the language better
// pub fn getInputLines(comptime day: u8) ![][]u8{
//     var gen_alloc = std.heap.GeneralPurposeAllocator(.{}){};  

//     var buffer: [100]u8 = undefined


//     const inputDir = try fs.cwd().openDir(inputDirPath, .{});
//     defer inputDir.close();

//     var filename : [10]u8 = undefined;
//     filename = fmt.printBuf("day_{:0>2}.txt", .{day});

//     //TODO: Catch error and pull new file if necessisary 
//     const inputFile: fs.File = try inputDir.openFile(filename);
//     defer inputFile.close();

//     var lines = std.ArrayList([]u8).init(gen_alloc);
//     defer lines.deinit(); 

//     // read the file, line by line
//     while(try inputFile.reader().readUntilDelimiterOrEof(buffer, "\n")) |line|{
//         lines.append(line);
//     }
    
//     return lines.items[0..];
// }

// pub fn getInputDir() ![]u8{
//     var buffer : [4096]u8 = undefined;
    
//     return fs.cwd().realpath(inputDirPath, buffer);
// }

/// Returns the total of the values of type T contained in the slice Values.
pub fn total(comptime T: type, values: []const T) i64 {
    var sum: i64 = 0;
    for (values) |val| sum += val;
    return sum;
}
