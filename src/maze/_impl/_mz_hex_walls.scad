use <../mz_get.scad>;

function _get_x(block) = mz_get(block, "x"); 
function _get_y(block) = mz_get(block, "y");
function _get_wall_type(block) = mz_get(block, "w");

function _is_upper_wall(block) = _get_wall_type(block) == "UPPER_WALL";
function _is_right_wall(block) = _get_wall_type(block) == "RIGHT_WALL";
function _is_upper_right_wall(block) = _get_wall_type(block) == "UPPER_RIGHT_WALL";

function _cell_position(cell_radius, x_cell, y_cell) =
    let(
        grid_h = 2 * cell_radius * sin(60),
        grid_w = cell_radius + cell_radius * cos(60)
    )
    [grid_w * x_cell, grid_h * y_cell + (x_cell % 2 == 0 ? 0 : grid_h / 2), 0];
    
function _hex_seg(cell_radius, begin, end) = [for(a = [begin:60:end]) 
				[cell_radius * cos(a), cell_radius * sin(a)]];
    
function _upper_right(cell_radius) = _hex_seg(cell_radius, 0, 60);
function _upper(cell_radius) = _hex_seg(cell_radius, 60, 120);
function _upper_left(cell_radius) = _hex_seg(cell_radius, 120, 180);			
function _down_left(cell_radius) = _hex_seg(cell_radius, 180, 240); 
function _down(cell_radius) = _hex_seg(cell_radius, 240, 300);
function _down_right(cell_radius) = _hex_seg(cell_radius, 300, 360); 	   
  
function _right_wall(cell_radius, x_cell) = 
    (x_cell % 2 != 0) ? _down_right(cell_radius) : _upper_right(cell_radius);

function _row_wall(cell_radius, x_cell, y_cell) =
    x_cell % 2 != 0 ? [_upper_right(cell_radius), _upper_left(cell_radius)] : [_down_right(cell_radius)];
    
function _build_cell(cell_radius, block) = 
    let(
        x = _get_x(block) - 1,
        y = _get_y(block) - 1,
        walls = concat(
            _row_wall(cell_radius, x, y),
            [_is_upper_wall(block) || _is_upper_right_wall(block) ? _upper(cell_radius) : []],
            [_is_right_wall(block) || _is_upper_right_wall(block) ? _right_wall(cell_radius, x) : []]
        )
    )
    [
        for(wall = walls)
        if(wall != [])
            [for(p = wall)
                _cell_position(cell_radius, x, y) + p]
    ];
