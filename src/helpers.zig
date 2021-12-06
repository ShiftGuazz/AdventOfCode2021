const @import("std");
const fmt = std.fmt;
const fs = std.fs;

///function that pulls input from a text file at a day #
/// returns a 2d array of u8s, one per line.
/// TODO: get this documention better - this will improve as I understand the language better
pub fn GetInput(comptime day: u8) ![]u8{
  //open the input file associated with day
  //generate the path to the input file
  const input_Path: [128:0]u8 = 0 ** 128;
  _ = fmt.buf(&input_Path, "../Inputs/Day_{}", .{day});

  const file = fs.cwd().openFileZ(input_Path) catch |err|{

  };
  //TODO
  //if the file does not exist, get the input file from adventofcode2021
  //cache the file
  if()

  //read each line in the file and place each line into the returned 2d array
  
}
