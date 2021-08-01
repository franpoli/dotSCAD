use <shear.scad>;
use <along_with.scad>;
use <bezier_smooth.scad>;
use <util/reverse.scad>;
use <util/dedup.scad>;
use <turtle/lsystem3.scad>;
use <curve.scad>;
use <dragon_head.scad>;
use <dragon_scales.scad>;

hilbert_dragon();

module hilbert_dragon() {
    module one_segment(body_r, body_fn, one_scale_data) {
        rotate([-90, 0, 0])
            dragon_body_scales(body_r, body_fn, one_scale_data);

        // dorsal fin
        translate([0, 4, -1.5]) 
        rotate([-105, 0, 0]) 
        shear(sy = [0, .75])
        linear_extrude(5, scale = 0.15)
            square([2.5, 4], center = true);            

        translate([0, -2.5, 1]) 
        rotate([-10, 0, 0]) 
        scale([1.1, 0.8, 1.25])  
            sphere(body_r * 1.075, $fn = 8); 
    }

    body_r = 5;
    body_fn = 12;
    scale_fn = 5;
    scale_tilt_a = -3;

    lines = hilbert_curve();
    hilbert_path = dedup(
        concat(
            [for(line = lines) line[0]], 
            [lines[len(lines) - 1][1]])
        );
    smoothed_hilbert_path = bezier_smooth(hilbert_path, 0.45, t_step = 0.15);

    dragon_body_path = reverse([for(i = [1:len(smoothed_hilbert_path) - 2]) smoothed_hilbert_path[i]]);
     
    one_body_scale_data = one_body_scale(body_r, body_fn, scale_fn, scale_tilt_a);
     
    along_with(dragon_body_path, scale = 0.6)    
    rotate([90, 0, 0]) 
    scale(0.035)  
        one_segment(body_r, body_fn, one_body_scale_data);
    
    // tail
    translate([0, 0, -0.62])
    rotate(-5)
    scale(0.0285)
    mirror([0, 0, 1]) 
        tail_scales(120, 2.5, 2, -9, 1, $fn = 4);

    translate([0, 0, -2.5])        
    scale(0.035)         
        dragon_head([0, 0]);     
}
   

function hilbert_curve() = 
    let(
        axiom = "A",
        rules = [
            ["A", "B-F+CFC+F-D&F^D-F+&&CFC+F+B//"],
            ["B", "A&F^CFB^F^D^^-F-D^|F^B|FC^F^A//"],
            ["C", "|D^|F^B-F+C^F^A&&FA&F^C+F+B^F^D//"],
            ["D", "|CFB-F+B|FA&F^A&&FB-F+B|FC//"]
        ]
    )
    lsystem3(axiom, rules, 2, 90, 1, 0,  [0, 0, 0]);  