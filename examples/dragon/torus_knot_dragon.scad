use <torus_knot.scad>;
use <shear.scad>;
use <along_with.scad>;
use <util/reverse.scad>;
use <dragon_head.scad>;
use <dragon_body_scales.scad>;

torus_knot_dragon();

module torus_knot_dragon() {
    phi_step = 0.0525;

    body_r = 6;
    body_fn = 12;
    scale_fn = 8;
    scale_tilt_a = 3;

    knot = torus_knot(2, 3, phi_step);
    d_path = reverse([for(i = [6:len(knot) - 4]) knot[i]]);
	
    one_body_scale_data = one_body_scale(body_r, body_fn, scale_fn, scale_tilt_a);
	along_with(d_path, scale = 0.85, method = "EULER_ANGLE")    
	scale(0.06)
	    one_segment(body_r, body_fn, one_body_scale_data);

    function __angy_angz(p1, p2) = 
        let(
            dx = p2[0] - p1[0],
            dy = p2[1] - p1[1],
            dz = p2[2] - p1[2],
            ya = atan2(dz, sqrt(dx * dx + dy * dy)),
            za = atan2(dy, dx)
        ) [ya, za];
		
	h_angy_angz = __angy_angz(d_path[len(d_path) - 2], d_path[len(d_path) - 1]);
	
	translate([2.75, -.9, .45])
    rotate([0, 28, 245])
    scale(0.0625)    
        dragon_head(h_angy_angz);
		
	t_angy_angz = __angy_angz(d_path[1], d_path[0]);	
	
	translate([2.17, 1.53, -.775])
	rotate([0, t_angy_angz[0], t_angy_angz[1]])
	rotate([0, -85, -90])
	scale(0.055)
	    tail();
}

module tail_scales(ang, leng, radius, height, thickness) {
    module one_scale() {
        rotate([0, ang, 0]) 
        shear(sx = [0, -1.5])
        linear_extrude(thickness, center = true) 
        scale([leng, 1]) 
            circle(1, $fn = 8);    
    }

    for(a = [0:30:330]) {
        hull() {
            rotate(a) 
            translate([radius, 0, height]) 
                one_scale();
                
            rotate(a + 15) 
            translate([radius, 0, height + 1.75]) 
                one_scale();
        }
    }
}

module one_segment(body_r, body_fn, one_scale_data) {
    // scales
    rotate([-90, 0, 0])
        dragon_body_scales(body_r, body_fn, one_scale_data);

    // dorsal fin
    translate([0, 2.5, -3]) 
    rotate([-65, 0, 0]) 
    shear(sy = [0, 2])
    linear_extrude(4, scale = 0.2)
        square([2, 10], center = true);            
            
    // belly    
    translate([0, -2.5, .8]) 
    rotate([-5, 0, 0]) 
    scale([1, 1, 1.4])  
        sphere(5.8, $fn = 8); 
    
}

module tail() {
    tail_scales(75, 2.5, 5, -4, 1.25);
    tail_scales(100, 1.25, 4.5, -7, 1);
    tail_scales(110, 1.25, 3, -9, 1);
    tail_scales(120, 2.5, 2, -9, 1);   
}