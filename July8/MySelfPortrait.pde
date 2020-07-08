size(700,700);
//create a brown face
fill(165,113,78);
stroke(165,113,78);
ellipse(350,350,300,400);
//create a nose with a black outline
stroke(0,0,0);
triangle(350,330,320,400,380,400);
//create two eyes that are white
stroke(255,255,255);
fill(255,255,255);
ellipse(290,310,80,30);
ellipse(410,310,80,30);
//add black hair and two pupils
stroke(0,0,0);
fill(0,0,0);
arc(350, 250, 250, 220, radians(180), radians(360), CHORD);
ellipse(412,310,30,28);
ellipse(292,310,30,28);
//add red lips
stroke(200,0,0);
fill(200,0,0);
arc(350, 430, 150, 50, 0, radians(180));

//This is the start of the environment (a book)
//Main middle book rectangle
stroke(217,157,41);
fill(217,157,41);
rect(20,20,150,220);
fill(255,255,255);
//Bottom parallelogram
rect(20,240,150,20);
triangle(20,240,20,260,10,260);
fill(204,204,204); //grey background color
triangle(170,240,170,260,160,260);
//Side parallelogram
stroke(0,0,0);
fill(217,157,41);
rect(10,20,10,220);
triangle(20,240,10,240,10,260);
fill(204,204,204);
triangle(20,20,10,20,10,40);
