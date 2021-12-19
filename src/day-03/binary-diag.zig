const std = @import("std");
const util = @import("aoc_util");
const print = std.debug.print;
const fmt = std.fmt;
const mem = std.mem;

const DiagProperties = struct{
    entries: u32,
    gamma: u32,
    epsilon: u32,
    heatmap: [12]u32 = [12]u32{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
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
    var properties = DiagProperties{ .entries = 0, .gamma = 0, .epsilon = 0};
    var subStatus = SubDiag{ 
                        .power_consumption = 0,
                        .O2_gen_rating = 0,
                        .CO2_scrub_rating = 0 
                    };

    subStatus.power_consumption = try part1(file_input, &properties);

    //try part2(file_input, &properties, &subStatus);

    print("---Part 1 result---\n", .{});
    print("Result: {d}\n", .{subStatus.power_consumption});
    print("Entries: {d}, Gamma: {b}, Epsilon: {b}\n", .{properties.entries, properties.gamma, properties.epsilon});
    print("---Part 2 result---\n Does not currently work\n", .{});
    print("Result: {d}\n", .{subStatus.O2_gen_rating * subStatus.CO2_scrub_rating});
    print("O2 Generator rating: {d}, CO2 scrubber rating: {d}\n", 
          .{subStatus.O2_gen_rating, subStatus.CO2_scrub_rating});
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
        properties.heatmap[i] = num_bin_one[i];
    }

    properties.entries = num_count;
    properties.gamma = gamma_rate;
    properties.epsilon = epsilon_rate;
    return gamma_rate * epsilon_rate;
}

const DiagValue = struct{
    CO2_valid: bool = true,
    O2_valid: bool = true,
    value: u16
};

pub fn part2(input: []u8, properties: *DiagProperties, subStatus: *SubDiag) !void{
    var gen_alloc = std.heap.GeneralPurposeAllocator(.{}){};
    const bitmask = [_]u16{0x0800, 0x0400, 0x0200, 0x0100,
                           0x0080, 0x0040, 0x0020, 0x0010,
                           0x0008, 0x0004, 0x0002, 0x0001, };
    
    //heatmap[0] is the number of 1's present in the numbers valid for O2
    //heatmap[1] is the number of 1's present in the numbers valid for CO2
    var heatmap = [_]u16{@intCast(u16, properties.heatmap[11]), @intCast(u16, properties.heatmap[11])};

    //initialize array list of diag numbers and array indicies
    var diag_list = std.ArrayList(DiagValue).init(gen_alloc.allocator());
    defer diag_list.deinit();

    //tokenize and parse the input into diag list
    var binary_diag = mem.tokenize(u8, input, "\n");

    while(binary_diag.next()) |diag_str| {
        var value = try fmt.parseInt(u16, diag_str, 2);
        try diag_list.append(DiagValue{.value = value});
    }

    var O2_found: bool = false;
    var CO2_found: bool = false;

    var numCO2Valid = properties.entries;
    var numO2Valid = properties.entries;

    //cycle through each bit
    bitCycle: for(bitmask) |mask, i|{
        print("\nchecking bit {d}\n", .{12 - i});

        //determine the Bits that we're comparing to
        const O2_Bit: bool = (heatmap[0] >= (numO2Valid/2));
        const CO2_Bit: bool = (heatmap[1] <= (numCO2Valid/2));
        print("O2_Bit: {}, CO2_Bit: {}\n", .{O2_Bit, CO2_Bit});

        //cycle through each number in the input
        for(diag_list.items) |*item|{
            var bitMatch: bool = undefined;

            //if O2 number hasn't been found, check this entry
            if(!O2_found){
                if(item.O2_valid){
                    print("checking value for O2: {b}   ", .{item.value});

                    if(O2_Bit){
                        bitMatch = (item.value & mask) != 0;
                    }else{
                        bitMatch = (item.value | (~mask)) != 0;
                    }

                    if(numO2Valid == 1){
                        O2_found = true;
                        subStatus.O2_gen_rating = item.value;
                    }else if(!bitMatch){
                        print("value failed!\n", .{});
                        item.O2_valid = bitMatch;
                        numO2Valid -= 1;
                    }else{
                        print("\n", .{});
                    }
                }
            }

            //if CO2 number hasn't been found, check this entry.
            if(!CO2_found){
                if(item.CO2_valid){
                    print("checking value for CO2: {b}  ", .{item.value});
                    
                    if(CO2_Bit){
                        bitMatch = (item.value & mask) != 0;
                    }else{
                        bitMatch = (item.value | (~mask)) != 0;
                    }

                    if(numCO2Valid == 1){
                        CO2_found = true;
                        subStatus.CO2_scrub_rating = item.value;
                    }else if(!bitMatch){
                        print("value failed!\n", .{});
                        item.CO2_valid = bitMatch;
                        numCO2Valid -= 1;
                    }else{
                        print("\n", .{});
                    }
                }
            }

            //break if we've found both desired numbers
            if(CO2_found and O2_found){
                break :bitCycle;
            }
        }

        //determine new heatmap values
        heatmap[0] = 0;
        heatmap[1] = 0;
        
        // we shouldn't get through the previous for loop on bit 11 without
        // getting something for the ratings
        if(i == 11) break;

        for(diag_list.items) |item|{
            if(!O2_found){
                if(item.O2_valid){
                    if(item.value & bitmask[i + 1] != 0){
                        heatmap[0] += 1;
                    }
                }
            }

            if(!CO2_found){
                if(item.CO2_valid){
                    if(item.value & bitmask[i + 1] != 0){
                        heatmap[1] += 1;
                    }
                }
            }

            if(!CO2_found){

            }
        }
    }
}