/************************************************************************

	extreme_logo.scad
    
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

module logo(thickness) {
    union() {
        difference() {
            move([0,0,0]) cuboid([40,9,thickness], center=false, fillet = 0.5);
            move([4.5,-10,-1]) rotate([0,0,45]) cuboid([10,20,thickness+2], center=false);
        }

        difference() {
            move([0,5,0]) cuboid([10,43 - 5,thickness], center=false, fillet = 0.5);
            move([-7,3.5,-1]) rotate([0,0,-45]) cuboid([10,25,thickness+2], center=false);
        }

        move([0,34,0]) cuboid([40,9,thickness], center=false, fillet = 0.5);
        move([17,17,0]) cuboid([17.5,9,thickness], center=false, fillet = 0.5);
    }
}

// Render the Extreme Logo
module render_extreme_logo(thickness, isLeft)
{

    if (isLeft) rotate([90,0,-90]) mirror([180,0,0]) move([-40,0,0]) logo(thickness);
    else rotate([90,0,-90]) logo(thickness);

}