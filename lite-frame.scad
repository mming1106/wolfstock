use <makerslide.scad>;
use <vwheel_single_bearing_b17001_rev_2.scad>;
use <carriage_plate_standard_c14005_rev_2.scad>;
use <misumi-parts-library.scad>;
use <tensioner_608.scad>
use <base-bracket-motor.scad>

function offsetX(d)= sin(30) * d;
function offsetY(d)= cos(30) * d;

triangleLength= 312;
armLength= 250;
beamLength= 268.5;
slideht= 700;
centerBottomY= tan(30) * triangleLength/2;
midlineY= cos(30) * triangleLength;
centerTopY= midlineY - centerBottomY;
centerRadius= (triangleLength/2)/cos(30);
beamOffset= 10+25;

echo("centerRadius= ", centerRadius, centerTopY);
echo("centerBottomY= ", centerBottomY, midlineY-centerTopY);
echo("Diagonal Arm= ", triangleLength*0.8);

%rotate([0,0,0]) translate([0, -centerBottomY, 0]) polygon(points=[[-triangleLength/2,0],[0,offsetY(triangleLength)],[triangleLength/2,0]], paths=[[0,1,2]]);

main();

carriageHt= 300;
armr= 0.344*25.4/2;
armsp= 57.7;
if(false) {
	translate([0,centerTopY+20,carriageHt]) rotate([90,0,0]) carriage_assy();
	translate([0,centerTopY-16,carriageHt-8]) rotate([0,0,0]) import("stl/arm-plate-back.stl");
	// arms
	color("black") translate([-armsp/2,centerTopY-14.5-6.5,carriageHt-20]) rotate([-30,0,-30]) translate([0,0,-armLength]) cylinder(r=armr, h= armLength);
	
	color("green") {
 	 	intersection() {
			translate([0,centerTopY,50]) cylinder(r=armLength+50,h=2, $fn=80);
			translate([triangleLength/2,-centerBottomY,50]) cylinder(r=armLength+50,h=2, $fn=80);
			translate([-triangleLength/2,-centerBottomY,50]) cylinder(r=armLength+50,h=2, $fn=80);
  		}
  	}
	bed();
}

module tower() {
	translate([-20,0,0]) makerslide(slideht);
}

module main() {
	// towers
	translate([0,centerTopY,slideht/2]) rotate([0,0,-90]) tower();
	translate([triangleLength/2,-centerBottomY,slideht/2]) rotate([0,0,-210]) tower();
	translate([-triangleLength/2,-centerBottomY,slideht/2]) rotate([0,0,30]) tower();

	// Bottom Beams
	translate([beamLength/2,-centerBottomY-beamOffset,45/2]) rotate([0,0,90]) hfs2040(beamLength);
	translate([offsetY(centerBottomY+beamOffset),offsetX(centerBottomY+beamOffset),45/2]) rotate([0,0,30]) translate([0,-beamLength/2,0]) hfs2040(beamLength);
	translate([-offsetY(centerBottomY+beamOffset),offsetX(centerBottomY+beamOffset),45/2]) rotate([0,0,-30]) translate([0,-beamLength/2,0]) hfs2040(beamLength);


	// bottom brackets
	translate([0,centerTopY,0]) rotate([0,0,90]) frame_motor();
	translate([triangleLength/2,-centerBottomY,0]) rotate([0,0,-30]) frame_motor();
	translate([-triangleLength/2,-centerBottomY,0]) rotate([0,0,-150]) frame_motor();
}

module bed() {
	translate([0, 0, 45]) circle(r=250/2);
}

module carriage_assy() {
	wheelelevation= -3 + -(0.25) *25.4;
	translate([0.6,0,20 + -wheelelevation]) {
   		color([0.2,0.2,0.2]) translate([]) rotate([0,0,-90]) centeredCarriagePlate();
      	translate([32.163,-34.925,wheelelevation]) rotate([180,0,0]) vwheel();
      	translate([32.163, 34.925,wheelelevation]) rotate([180,0,0]) vwheel();
      	translate([-32.663 - 0.94,0,wheelelevation]) rotate([180,0,0]) vwheel();
	}
}
