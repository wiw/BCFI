sourceDir = getDirectory("Choose Source Directory ");
destDir = getDirectory("Choose Destination Directory ");

list=getFileList(sourceDir);
	for (i=0; i<=list.length; i++) {
	count = i;
}
count = count/2;

for (g=1; g<=count; g++) {
imageNumber=g;
open(""+sourceDir+"bw"+imageNumber+".jpg");
open(""+sourceDir+"fluor"+imageNumber+".jpg");

selectWindow("fluor"+imageNumber+".jpg");
	run("8-bit Color", "number=256");

selectWindow("bw"+imageNumber+".jpg");
	run("8-bit");
	run("Merge Channels...", "c1=fluor"+imageNumber+".jpg c4=bw"+imageNumber+".jpg create keep");

setTool("line");
title = "Hello";
msg = "Please draw line of horizontal chromosomes, then click \"OK\".";
	waitForUser(title, msg);
	getSelectionCoordinates(x, y);

selectWindow("Composite");
	grad = getAngle(x[0], y[0], x[1], y[1]);
	run("Rotate... ", "angle="+grad+" grid=1 interpolation=None keep");
run("Select None");

setTool("rectangle");

title = "Hello";
msg = "Please select part of chromosome, then click \"OK\".";
	waitForUser(title, msg);
	getSelectionCoordinates(z, w);

makeSelection("polygon", z, w);
run("Crop");
run("Select None");

selectWindow("bw"+imageNumber+".jpg");
	run("Rotate... ", "angle="+grad+" grid=1 interpolation=None keep");
	makeSelection("polygon", z, w);
	run("Crop");
	run("Select None");

selectWindow("fluor"+imageNumber+".jpg");
	run("Rotate... ", "angle="+grad+" grid=1 interpolation=None keep");
	makeSelection("polygon", z, w);
	run("Crop");
	run("Select None");

selectWindow("bw"+imageNumber+".jpg");
run("RGB Color");
	
selectWindow("fluor"+imageNumber+".jpg");
run("RGB Color");
	
selectWindow("Composite");
run("RGB Color");
	
run("Images to Stack", "name=Stack title=[]");
run("Make Montage...", "columns=1 rows=3 scale=1 first=1 last=3 increment=1 border=0 font=12");

selectWindow("Montage");
saveAs("Jpeg", ""+destDir+imageNumber+"montage.jpg");

run("Close All");
}

function getAngle(x1, y1, x2, y2) {
      q1=0; q2orq3=2; q4=3; //quadrant
      dx = x2-x1;
      dy = y1-y2;
      if (dx!=0)
          angle = atan(dy/dx);
      else {
          if (dy>=0)
              angle = PI/2;
          else
              angle = -PI/2;
      }
      angle = (180/PI)*angle;
      if (dx>=0 && dy>=0)
           quadrant = q1;
      else if (dx<0)
          quadrant = q2orq3;
      else
          quadrant = q4;
      if (quadrant==q2orq3)
          angle = angle+180.0;
      else if (quadrant==q4)
          angle = angle+360.0;
      return angle;
  }
