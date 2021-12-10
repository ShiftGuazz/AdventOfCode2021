const std = @import("std");
const util = @import("aoc_util");
const print = std.debug.print;
const fmt = std.fmt;
const mem = std.mem;

const DiagProperties = struct{
    gamma: u32,
    epsilon: u32,
};

const SubDiag = struct{
    power_consumption: i128,
    O2_gen_rating: u32,
    CO2_scrub_rating: u32
};

pub fn main() !void {    
    //pull input values from the file
    const file_input: []u8 = try util.getInputLines(3, 0x4FFF);
    
    //init diag properties struct
    var properties = DiagProperties{ .gamma = 0, .epsilon = 0};
    var subStatus = SubDiag{ 
                        .power_consumption = 0,
                        .O2_gen_rating = 0,
                        .CO2_scrub_rating = 0 
                    };

    subStatus.power_consumption = try part1(file_input, &properties);

    print("---Part 1 result---\n", .{});
    print("Result: {d}\n", .{subStatus.power_consumption});
    print("Gamma: {d}, Epsilon: {d}", .{properties.gamma, properties.epsilon});

}

pub fn part1(input: []u8, properties: *DiagProperties) !i128{
    // initialize the count for the number of input lines/entries
    var num_count: u32 = 0;
    // initialize the array to count how many 1's are in each bit
    // of the input lines
    var num_bin_one: [12]u32 = [12]u32{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
    //mem.set(u32, num_bin_one, 0);
    const bitmask = [_]u16{ 0x0001, 0x0002, 0x0004, 0x0008, 
                           0x0010, 0x0020, 0x0040, 0x0080, 
                           0x0100, 0x0200, 0x0400, 0x0800}; 

    var epsilon_rate : u32 = 0;
    var gamma_rate : u32 = 0;

    //pull and tokenize the file input
    //const input: []u8 = try util.getInputLines(3, 0x4FFF);
    var binary_power = mem.tokenize(u8, input, "\n");

    while(binary_power.next()) |power_str| : (num_count += 1){
        //parse the line as a binary number:
        var power = try fmt.parseInt(u16, power_str, 2);

        
        for(num_bin_one) |_ , bit|{
            if (power & bitmask[bit] != 0) {
                num_bin_one[bit] += 1;
            } 
        }
    }

    for(num_bin_one) |value, i|{
        if(value > (num_count/2)){
            gamma_rate |= bitmask[i];  
        }else{
            epsilon_rate |= bitmask[i];
        }
    }

    properties.gamma = gamma_rate;
    properties.epsilon = epsilon_rate;
    return gamma_rate * epsilon_rate;
}

// pub fn part2(input: []u8, properties: *DiagProperties, subStatus: *SubDiag) !void{

// }