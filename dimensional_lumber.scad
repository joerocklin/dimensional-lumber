include <BOSL2/std.scad>
include <BOSL2/structs.scad>

// Convert a value to inches. Since OpenSCAD works in millimeters, but dimensional
// lumber is all in Imperial units, we want to make it easy to write.
function inches(v) = (v * 25.4);
function cmToInches(v) = (v / 25.4);

measurements = struct_set([], [
    "1x1",  [inches(0.75), inches(0.75)],
    "1x2",  [inches(0.75), inches(1.5)],
    "1x3",  [inches(0.75), inches(2.5)],
    "1x4",  [inches(0.75), inches(3.5)],
    "1x6",  [inches(0.75), inches(5.5)],
    "1x8",  [inches(0.75), inches(7.25)],
    "1x10", [inches(0.75), inches(9.25)],
    "1x12", [inches(0.75), inches(11.25)],

    "2x2",  [inches(1.5), inches(1.5)],
    "2x3",  [inches(1.5), inches(2.5)],
    "2x4",  [inches(1.5), inches(3.5)],
    "2x6",  [inches(1.5), inches(5.5)],
    "2x8",  [inches(1.5), inches(7.25)],
    "2x10", [inches(1.5), inches(9.25)],
    "2x12", [inches(1.5), inches(11.25)],

    "4x4",  [inches(3.5), inches(3.5)],
    "4x6",  [inches(3.5), inches(5.5)],
    "6x6",  [inches(5.5), inches(5.5)],
], false);

function board_thickness(l=2, w=4) =
    let( b = struct_val(measurements, format("{d}x{d}", [l, w])) )
    b.x;
function board2x4thickness() = board_thickness(l=2,w=4);
function board2x6thickness() = board_thickness(l=2,w=6);

function board_width(l=2, w=4) =
    let( b = struct_val(measurements, format("{d}x{d}", [l,w])) )
    b.y;
function board2x4width() = board_width(l=2, w=4);
function board2x6width() = board_width(l=2, w=6);


// Module board returns a cube matching the dimensions provided
// in inches.
module board(h=2, w=4, l=inches(12*8), anchor=CENTER) {
    b = struct_val(measurements, format("{d}x{d}", [h, w]));
    cuboid([b.x, b.y, l], anchor=anchor);
    printboardIn(size=[h, w, l]);
}

module board2x4(l=inches(12*8), anchor=CENTER) {
    board(h=2, w=4, l=l, anchor=anchor);
}

module board2x6(l=inches(12*8), anchor=CENTER) {
    board(h=2, w=6, l=l, anchor=anchor);
}

module printboardIn(size=[1,2,3]) {
    echo(format("Board\t{d}x{d}\t{d}", 
        [size.x, size.y, cmToInches(size.z)]));
}