/**
* mz_square_walls.scad
*
* @copyright Justin Lin, 2020
* @license https://opensource.org/licenses/lgpl-3.0.html
*
* @see https://openhome.cc/eGossip/OpenSCAD/lib3x-mz_square_walls.html
*
**/

use <../util/dedup.scad>;
use <_impl/_mz_square_walls_impl.scad>;

function mz_square_walls(cells, rows, columns, cell_width, left_border = true, bottom_border = true) = 
    let(
        left_walls = left_border ? [for(y = [0:rows - 1]) [[0, cell_width * (y + 1)], [0, cell_width * y]]] : [],
        buttom_walls = bottom_border ? [for(x = [0:columns - 1]) [[cell_width * x, 0], [cell_width * (x + 1), 0]]] : []
    )
     concat(
        [
            for(cell = cells) 
            let(pts = dedup(_square_walls(cell, cell_width)))
            if(pts != []) pts
        ]
        , left_walls, buttom_walls
    );