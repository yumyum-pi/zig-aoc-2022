const print = @import("std").debug.print;

// 0 -> win
// 1 -> draw
// 2 -> loose
const round_points: [3]u8 = [3]u8{ 6, 3, 0 };

// 0 -> rock
// 1 -> paper
// 2 -> scissors
const move_points: [3]u8 = [3]u8{ 1, 2, 3 };

// 0 -> x -> loose
// 1 -> y -> draw
// 2 -> z -> win
const moves_matrix: [3][3]u8 = [3][3]u8{
    // loose vs
    [3]u8{
        // my move + round pointer          // p1 -> my move
        move_points[2] + round_points[2], // rock -> scissors
        move_points[0] + round_points[2], // paper -> rock
        move_points[1] + round_points[2], // scissors -> paper
    },
    // draw vs
    [3]u8{
        // my move + round pointer          // p1 -> my move
        move_points[0] + round_points[1], // rock -> rock
        move_points[1] + round_points[1], // paper -> paper
        move_points[2] + round_points[1], // scissors -> scissors
    },
    // win
    [3]u8{
        // my move + round pointer          // p1 -> my move
        move_points[1] + round_points[0], // rock -> paper
        move_points[2] + round_points[0], // paper -> scissors
        move_points[0] + round_points[0], // scissors -> rock
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

        //print("p1: {any}\t", .{p1});
        //print("p2: {any}\t", .{p2});
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
