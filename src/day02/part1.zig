const utils = @import("utils");
const print = @import("std").debug.print;

const NumRange = utils.ASCII.Numbers;
const LINEBREAK = utils.ASCII.LINEBREAK;

// 0 -> win
// 1 -> draw
// 2 -> loose
const round_points: [3]u8 = [3]u8{ 6, 3, 0 };

// 0 -> rock
// 1 -> paper
// 2 -> scissors
const move_points: [3]u8 = [3]u8{ 1, 2, 3 };

const moves_matrix: [3][3]u8 = [3][3]u8{
    // rock vs
    [3]u8{
        move_points[0] + round_points[1], // rock
        move_points[0] + round_points[2], // paper
        move_points[0] + round_points[0], // scissors
    },
    // paper vs
    [3]u8{
        move_points[1] + round_points[0], // rock
        move_points[1] + round_points[1], // paper
        move_points[1] + round_points[2], // scissors
    },
    // scissors vs
    [3]u8{
        move_points[2] + round_points[2], // rock
        move_points[2] + round_points[0], // paper
        move_points[2] + round_points[1], // scissors
    },
};

pub fn solution(input: []const u8) !u64 {
    var score: u64 = 0;
    var index: usize = 0;
    const input_len = input.len;

    var p1: usize = 0;
    var p2: usize = 0;

    while (index < input_len) {
        // index
        p1 = input[index] - 65;
        p2 = input[index + 2] - 88;

        // ittreate
        index += 4;

        //print("p1: {any}\n", .{p1});
        //print("p2: {any}\n", .{p2});
        //print("point: {any}\n", .{calculateScore(p1, p2)});
        score += calculateScore(p1, p2);
    }

    return score;
}

// p2 is me
// p1 is the opponent
fn calculateScore(p1: usize, p2: usize) u64 {
    return moves_matrix[p2][p1];
}
