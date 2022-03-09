/************************************************************************

    small_switch.scad
    
    Extreme Networks Summit switch display stands
    Copyright (C) 2021 Simon Inns
    
    This is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.
    
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
    
    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
	
    Email: simon.inns@gmail.com
    
************************************************************************/

include <BOSL/constants.scad>
use <BOSL/transforms.scad>
use <BOSL/shapes.scad>
use <BOSL/metric_screws.scad>

// Local includes
include <extreme_logo.scad>

// Calculate angle from elevation
function elevation(distance, height) = atan(height / distance);

// Render the body of the switch (dimensions from datasheet)
module switch_body(switch_height, switch_width, switch_depth)
{
    // Main body of the switch
    color([(1/255) * 68, (1/255) * 0, (1/255) * 153]) cuboid([switch_width,switch_depth,switch_height], center=false);

    // Bracket M3 screws at 2mm distance from switch body (to match original bracket thickness)
    xoffset = switch_depth - (76/2);
    yoffset = switch_height / 2;

    // Right side (from front aspect)
    move([0,xoffset,yoffset]) {
        move([-2, -20, -12.5]) metric_bolt(headtype="countersunk", size=3, l=4, pitch=0, phillips="#1", orient=ORIENT_XNEG);
        move([-2,  20, -12.5]) metric_bolt(headtype="countersunk", size=3, l=4, pitch=0, phillips="#1", orient=ORIENT_XNEG);
        move([-2, -20,  12.5]) metric_bolt(headtype="countersunk", size=3, l=4, pitch=0, phillips="#1", orient=ORIENT_XNEG);
        move([-2,  20,  12.5]) metric_bolt(headtype="countersunk", size=3, l=4, pitch=0, phillips="#1", orient=ORIENT_XNEG);
    }

    // Left side (from front aspect)
    move([switch_width,xoffset,yoffset]) {
        move([2, -20, -12.5]) metric_bolt(headtype="countersunk", size=3, l=4, pitch=0, phillips="#1", orient=ORIENT_X);
        move([2,  20, -12.5]) metric_bolt(headtype="countersunk", size=3, l=4, pitch=0, phillips="#1", orient=ORIENT_X);
        move([2, -20,  12.5]) metric_bolt(headtype="countersunk", size=3, l=4, pitch=0, phillips="#1", orient=ORIENT_X);
        move([2,  20,  12.5]) metric_bolt(headtype="countersunk", size=3, l=4, pitch=0, phillips="#1", orient=ORIENT_X);
    }
}

// Render a bracket
module render_bracket_frame(bracket_thickness, bracket_depth, switch_height, switch_width, switch_depth, switch_elevation)
{
    difference() {
        move([-bracket_thickness,switch_depth - bracket_depth,-switch_elevation]) cuboid([bracket_thickness,bracket_depth,switch_height + switch_elevation], fillet=2, edges=EDGES_X_ALL, center=false);

        rotate([-elevation(switch_depth, switch_elevation),0,0]) {
            move([-bracket_thickness - 1,0,-switch_height]) cuboid([bracket_thickness + 2, switch_depth * 1.5, switch_height], center=false);
        }
    }
}

// Note: this is probably unique to the switch model
module render_screwholes(switch_height, switch_depth, bracket_thickness, isLeft)
{
    xoffset = switch_depth - (76/2);
    yoffset = switch_height / 2;
    

    if (isLeft) {
        mirror([180,0,0]) move([bracket_thickness,0,0]) {
            move([0,xoffset,yoffset]) {
                move([-1, -20, -12.5]) cyl(l=4, d=3.25, orient=ORIENT_X);
                move([-1,  20, -12.5]) cyl(l=4, d=3.25, orient=ORIENT_X);
                move([-1, -20,  12.5]) cyl(l=4, d=3.25, orient=ORIENT_X);
                move([-1,  20,  12.5]) cyl(l=4, d=3.25, orient=ORIENT_X);
            }

            move([-(bracket_thickness / 2) - 2,xoffset,yoffset]) {
                move([0, -20, -12.5]) cyl(l=bracket_thickness, d=6, orient=ORIENT_X);
                move([0,  20, -12.5]) cyl(l=bracket_thickness, d=6, orient=ORIENT_X);
                move([0, -20,  12.5]) cyl(l=bracket_thickness, d=6, orient=ORIENT_X);
                move([0,  20,  12.5]) cyl(l=bracket_thickness, d=6, orient=ORIENT_X);
            }
        }
    } else {
        move([0,xoffset,yoffset]) {
            move([-1, -20, -12.5]) cyl(l=4, d=3.25, orient=ORIENT_X);
            move([-1,  20, -12.5]) cyl(l=4, d=3.25, orient=ORIENT_X);
            move([-1, -20,  12.5]) cyl(l=4, d=3.25, orient=ORIENT_X);
            move([-1,  20,  12.5]) cyl(l=4, d=3.25, orient=ORIENT_X);
        }

        move([-(bracket_thickness / 2) - 2,xoffset,yoffset]) {
            move([0, -20, -12.5]) cyl(l=bracket_thickness, d=6, orient=ORIENT_X);
            move([0,  20, -12.5]) cyl(l=bracket_thickness, d=6, orient=ORIENT_X);
            move([0, -20,  12.5]) cyl(l=bracket_thickness, d=6, orient=ORIENT_X);
            move([0,  20,  12.5]) cyl(l=bracket_thickness, d=6, orient=ORIENT_X);
        }
    }
}

module bracket_sub(switch_height, switch_width, switch_depth, switch_elevation, isLeft, isDisplay, bracket_thickness, bracket_depth)
{
    difference() {
        render_bracket_frame(bracket_thickness, bracket_depth, switch_height, switch_width, switch_depth, switch_elevation);
        render_screwholes(switch_height, switch_depth, bracket_thickness, isLeft);

        move([1,switch_depth - 10,-30]) {
            rotate([-elevation(switch_depth, switch_elevation),0,0]) scale([1,0.5,0.5]) render_extreme_logo(bracket_thickness + 2, isLeft);
        }
    }
}

module render_bracket(switch_height, switch_width, switch_depth, switch_elevation, isLeft, isDisplay)
{
    bracket_thickness = 4;
    bracket_depth = 76; // Should not exceed switch depth

    if (isDisplay) {
        if (isLeft) {
            // Left bracket
            move([switch_width + bracket_thickness,0,0]) {
                bracket_sub(switch_height, switch_width, switch_depth, switch_elevation, isLeft, isDisplay, bracket_thickness, bracket_depth);
            }
        } else {
            // Right bracket (*)
            bracket_sub(switch_height, switch_width, switch_depth, switch_elevation, isLeft, isDisplay, bracket_thickness, bracket_depth);
        }
    } else {
        if (isLeft) {
            // Left bracket
            rotate([0,-90,0]) {
                move([bracket_thickness,-switch_depth, 0]) {
                    bracket_sub(switch_height, switch_width, switch_depth, switch_elevation, isLeft, isDisplay, bracket_thickness, bracket_depth);
                }
            }
        } else {
            // Right bracket
            rotate([0,90,0]) {
                move([0,bracket_depth + 10 - switch_depth,0]) {
                    bracket_sub(switch_height, switch_width, switch_depth, switch_elevation, isLeft, isDisplay, bracket_thickness, bracket_depth);
                }
            }
        }
    }
}