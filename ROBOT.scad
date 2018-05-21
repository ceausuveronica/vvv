
size = 7.5;  // this is the overall size scale.  ***This is the only number you need to change to make it larger or smaller***

// other sizes based on the size above
bSize = size * 1.9; 
hSize = size * 1.25;
rSize = size * 0.25;
nubHeight = size * 0.25;
llSize = size * 0.5;
lwSize = size * 1.6;
legNubHeight = size * 0.55;
eyebrowAngle = 20; // degrees, like a real man uses. None of that radians crap, I'm not in high school.
circleRad = bSize * 0.3;
$fn = 30;

// draw the parts
head();
translate([0, 0, -hSize/2 - rSize])
{
   body();
}

translate([-bSize/2 - rSize + 0.1, 0, -size/2])
{
    rotate([15, 0, 0])
    arm();
}

translate([bSize/2 + rSize - 0.1, 0, -size/2])
{
    rotate([0,0,180])
    rotate([-15, 0, 0])
    arm();
}

translate([-bSize * 0.3, 0, -hSize - rSize * 2])
{
    leg();
}

translate([bSize * 0.3, 0,  -hSize - rSize * 2])
{
    mirror([1,0,0])
    leg();
}



// Modules start here
//------------------------------

module head()
{
    //color([1,0,0])
    difference()
    {
        translate([0,0,size/5])
        sphere(r=size, center = true);
        translate([-size, -size, -size * 2])
        {
            cube(size*2);
        }
        // cut out the eyes
        translate([-size/2 + size/10, -size + (size/5), size/3])
        sphere(r=size/5);
        translate([size/2 - size/10, -size + (size/5), size/3])
        sphere(r=size/5);
        
        // eyebrows
        translate([-cos(eyebrowAngle) - size/2, -size, size*0.75])
        rotate([0,eyebrowAngle,0])
        cube([size/2, size/3, size/15]);
        
        translate([cos(eyebrowAngle), -size, size*0.75 - (size/2 * sin(eyebrowAngle))])
        rotate([0,-eyebrowAngle,0])
        cube([size/2, size/3, size/15]);
        
    }
}

module body()
{
    backTextSize = (0.6 * size / 8.0);

    difference()
    {
        hull()
        {
            translate([-bSize/2, bSize/2, hSize/2])
            sphere(r=rSize);
            translate([bSize/2, bSize/2, hSize/2])
            sphere(r=rSize);
            translate([-bSize/2, -bSize/2, hSize/2])
            sphere(r=rSize);
            translate([bSize/2, -bSize/2, hSize/2])
            sphere(r=rSize);
            translate([-bSize/2, bSize/2, -hSize/2])
            sphere(r=rSize);
            translate([bSize/2, bSize/2, -hSize/2])
            sphere(r=rSize);
            translate([-bSize/2, -bSize/2, -hSize/2])
            sphere(r=rSize);
            translate([bSize/2, -bSize/2, -hSize/2])
            sphere(r=rSize);
        }
        translate([0, -bSize/2 - rSize, 0])
        rotate([90,0,0])
        scale([3.0 * size / 8.0, 3.0 * size / 8.0, 3.0])
        #import("robotFrontText.stl");

        translate([0, bSize/2 + rSize, 0])
        rotate([90,0,180])
        scale([ backTextSize, backTextSize, 1.0])
        #import("back-text-SCAD-only.stl");
//        #import("robotText.stl", convexity=5);
        
        difference()
        {
            hull()
            {
                translate([-bSize/5, -bSize/2 - rSize + 1, 0])
                rotate([90,0,0])
                cylinder(r=circleRad, h=2);
                translate([bSize/5, -bSize/2 - rSize + 1, 0])
                rotate([90,0,0])
                cylinder(r=circleRad, h=2);
            }
            hull()
            {
                translate([-bSize/5, -bSize/2 - rSize + 1, 0])
                rotate([90,0,0])
                cylinder(r=circleRad - 0.5, h=2);
                translate([bSize/5, -bSize/2 - rSize + 1, 0])
                rotate([90,0,0])
                cylinder(r=circleRad - 0.5, h=2);
            }
        }

    }
/*
    // minkowski was changing the body cube size too much and I didn't fell like working out the math, so I used 'hull' method above.
    // when in doubt, be lazy.
    minkowski()
    {
        cube([bSize, bSize, hSize], center = true);
        cylinder(r=rSize);
        rotate([90,0,0])
        cylinder(r=rSize);
        rotate([0,90,0])
        cylinder(r=rSize);
    }
    */
}

module arm()
{
    difference()
    {
        sphere(r=size * 0.8);
        translate([-size, -size, 0])
        {
            cube(size*2);
        }
        translate([0, -size, -size])
        {
            cube(size*2);
        }
    }
    translate([-size/3, 0, 0])
    {
        cylinder(h=nubHeight, r=size/5);
    }
    
    difference()
    {
        upperArm();
        translate([-size/7, -size, 0])
        {
            cube(size*2);
        }
        
    }
}

module upperArm()
{
    translate([-size/3, 0, nubHeight])
    {
        cylinder(h=nubHeight * 3, r1=size/4, r2 = size/2);
    }

    translate([-size/3, 0, nubHeight * 4])
    {
        difference()
        {
            sphere(r=size/2);
            translate([-size/2, -size/2, -size])
            {
                cube(size);
            }
        }
    }
}

module leg()
{
    fWidth = size/3;
    
    translate([-(llSize)/2, -(lwSize)/ 2, -legNubHeight - 1])
    {
        minkowski()
        {
            cube([llSize, lwSize, legNubHeight]);
            cylinder(r=1);
        }
    }
    
    translate([-(llSize)/2, -(lwSize)/ 2, (-legNubHeight-2)])
    hull()
    {
        minkowski()
        {
            cube([llSize, lwSize, 0.1]);
            cylinder(r=1);
        }
        translate([ -fWidth,  -fWidth, -size * 1.0])
        minkowski()
        {
            cube([llSize+ fWidth, lwSize+fWidth, 0.1]);
            cylinder(r=1);
        }
    }
    
}

// this is really bad letter 'A'. (Not used)  Always good to leave dead code lying around to confuse people.
module letterA()
{
linear_extrude(height = 1, center = true, convexity = 10, twist = 0)
translate([-1.5, -2, 0])
polygon( points=[[0,0],[0,4],[3,4],[3,0],[2,0],[2,1],[1,1],[1,0],[1,2],[1,3],[2,3],[2,2]], paths=[[0,1,2,3,4,5,6,7],[8,9,10,11]] );

}