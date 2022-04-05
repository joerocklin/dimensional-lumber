// Inspired by the design from https://oldworldgardenfarms.com/2019/06/06/diy-compost-bin/

include <BOSL2/std.scad>
include <../dimensional_lumber.scad>

boards=9;
gap=inches(0.25);

width=inches(36);
depth=inches(31);

// The original design - or close to it
// compost_bin_2x6([inches(36), inches(36), 6*(inches(0.5)+board2x6width())], 6, inches(0.5));

// 2x4 example - I've actually built this one with the output from the 
compost_bin_2x4([width, depth, boards*(gap+board2x4width())], boards, gap);

module compost_bin_2x4(d=[1,2,3], boards=5, gap=inches(2)) {
    // Back uprights
    line_of(d.x-board2x6width()) zrot(90) board2x6(l=d.z, anchor=BOTTOM);

    // Back wall
    fwd(board2x4thickness()) up(d.z/2) yrot(90) wall_2x4(spacing=(board2x4width()+gap), boards=boards, length=d.x);

    // Left Wall
    move([-d.x/2-board2x4thickness()/2, -d.y/2+board2x4thickness()/2, d.z/2]) rot([0, 90, 90]) wall_2x4(spacing=(board2x4width()+gap), boards=boards, length=d.y);

    // Right Wall
    move([d.x/2+board2x4thickness()/2, -d.y/2+board2x4thickness()/2, d.z/2]) rot([0, 90, 90]) wall_2x4(spacing=(board2x4width()+gap), boards=boards, length=d.y);

    // Front uprights
    fwd(d.y-board2x6thickness()) line_of(d.x-board2x6width()) zrot(90) board2x6(l=d.z, anchor=BOTTOM);
    fwd(d.y-3*board2x4thickness()) line_of(d.x-board2x4width()) zrot(90) board2x4(l=d.z, anchor=BOTTOM);

    // Front wall
    fwd(d.y-2*board_thickness()) up(d.z/2) yrot(90) wall_2x4(spacing=(board2x4width()+1), boards=boards, length=d.x-inches(0.5));

    // Lid
    // move([0,-d.y/2,d.z]) rot([90, 0, 90]) 
    //     line_of(spacing=d.y/2-board2x4width(), n=3) 
    //         zrot(90) board2x4(l=d.x+2*board2x6thickness(), anchor=CENTER);
}

module compost_bin_2x6(d=[1,2,3], boards=5, gap=inches(2)) {
    // Back uprights
    line_of(d.x-board2x6width()) zrot(90) board2x6(l=d.z, anchor=BOTTOM);

    // Back wall
    fwd(board2x6thickness()) up(d.z/2) yrot(90) wall_2x6(spacing=(board2x6width()+gap), boards=boards, length=d.x);

    // Left Wall
    move([-d.x/2-board2x6thickness()/2, -d.y/2+board2x6thickness()/2, d.z/2]) rot([0, 90, 90]) wall_2x6(spacing=(board2x6width()+gap), boards=boards, length=d.y);

    // Right Wall
    move([d.x/2+board2x6thickness()/2, -d.y/2+board2x6thickness()/2, d.z/2]) rot([0, 90, 90]) wall_2x6(spacing=(board2x6width()+gap), boards=boards, length=d.y);

    // Front uprights
    fwd(d.y-board2x6thickness()) line_of(d.x-board2x6width()) zrot(90) board2x6(l=d.z, anchor=BOTTOM);
    fwd(d.y-3*board2x6thickness()) line_of(d.x-board2x4width()) zrot(90) board2x4(l=d.z, anchor=BOTTOM);

    // Front wall
    fwd(d.y-2*board_thickness()) up(d.z/2) yrot(90) wall_2x6(spacing=(board2x6width()+1), boards=boards, length=d.x-inches(0.5));

    // Lid
    // move([0,-d.y/2,d.z]) rot([90, 0, 90]) 
    //     line_of(spacing=d.y/2-board2x4width(), n=3) 
    //         zrot(90) board2x4(l=d.x+2*board2x6thickness(), anchor=CENTER);
}

module wall_2x4(spacing=2, boards=2, length=inches(36)) {
    line_of(spacing=spacing, n=boards) 
        zrot(90) board2x4(l=length, anchor=CENTER);
}

module wall_2x6(spacing=2, boards=2, length=inches(36)) {
    line_of(spacing=spacing, n=boards) 
        zrot(90) board2x6(l=length, anchor=CENTER);
}