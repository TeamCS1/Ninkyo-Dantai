/// draw_healthbar_circular(Prec,X,Y,Amount,Rot,Rad1,Rad2)
/// GMLscripts.com/license

var Prec,A,B,X,Y,Pos,Rot,Rad1,Rad2,N;
Prec=abs(argument0);            //Precision
X=argument1;                    //x position
Y=argument2;                    //y position
Pos=Prec*(argument3/100);       //amount (0 - 100)
Rot=argument4;                  //rotation
Rad1=argument5;                 //radius 1
Rad2=argument6;                 //radius 2

draw_primitive_begin(pr_trianglestrip)
for(N=0; N>=-Pos; N-=1)
{
    A=X+lengthdir_x(Rad1,Rot+360*N/Prec);
    B=Y+lengthdir_y(Rad1,Rot+360*N/Prec);
    draw_vertex(A,B);
    
    A=X+lengthdir_x(Rad2,Rot+360*N/Prec);
    B=Y+lengthdir_y(Rad2,Rot+360*N/Prec);
    draw_vertex(A,B);
}
draw_primitive_end();
