/**
* vx_intersection.scad
*
* @copyright Justin Lin, 2020
* @license https://opensource.org/licenses/lgpl-3.0.html
*
* @see https://openhome.cc/eGossip/OpenSCAD/lib3x-vx_intersection.html
*
**/ 

use <../util/set/hashset.scad>;
use <../util/set/hashset_has.scad>;
use <../__comm__/_pt3_hash.scad>;

function vx_intersection(points1, points2) =
    let(
        leng1 = len(points1),
        leng2 = len(points2),
        pts_pair = leng1 > leng2 ? [points1, points2] : [points2, points1],
        hash = function(p) _pt3_hash(p),
        sorted = hashset(pts_pair[1], hash = hash)
    )
    [for(p = pts_pair[0]) if(hashset_has(sorted, p, hash = hash)) p];