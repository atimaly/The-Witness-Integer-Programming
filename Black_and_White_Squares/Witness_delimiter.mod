// Create a record to hold information about each arc

int Side = ...;   // Number of rows
range Rows = 1..Side;
range SmRows =1..Side-1;
int BigNumb = Side*Side;

int Exit = ...;
// Get the supply (positive) and demand (negative)
// at each node

int Entries[SmRows][SmRows] = ...;

tuple arc {
   key int fromnode_x;
   key int fromnode_y;
   key int tonode_x;
   key int tonode_y;
}

// Get the set of arcs

{arc} Arcs = ...;

dvar int+ Flow[a in Arcs] in 0 .. 1;
dvar int+ Y_help[SmRows][SmRows] in 0 .. Side;
dvar int+ Z_help[SmRows][SmRows] in 0 .. Side;
dvar int+ Potential[Rows][Rows];

dexpr float TotalFlow = sum (a in Arcs) Flow[a];
minimize TotalFlow;

subject to {
  	// Preserve flows at each node.  Note the use of slicing
   	forall (i in Rows, j in Rows) {
     		ctNodeFlow:
      		sum (<i,j,k,l> in Arcs) Flow[<i,j,k,l>]
   		- sum (<k,l,i,j> in Arcs) Flow[<k,l,i,j>] == 0;
   	}    
    	Flow[<1, Exit, 0, 0>] == 1;
	Flow[<Side+1, Side, Side, Side>] == 1;
		
	//Separation
	forall (i in SmRows, j in SmRows) {
	  if(Entries[i][j] == 1) {
	  	 sum (jm in 1..j) Flow[<i+1,jm,i,jm>]
	  	 + sum (jm in 1..j) Flow[<i,jm,i+1,jm>] == 2*Y_help[i][j] + 1;
	  	}
	  if(Entries[i][j] == 2) {
	  	 sum (jm in 1..j) Flow[<i+1,jm,i,jm>]
	  	 + sum (jm in 1..j) Flow[<i,jm,i+1,jm>] == 2*Z_help[i][j];
	  	} 
	 }
	 
	 //No cycle
	 //Potential[Side][Side] == 0;
	 forall (a in Arcs) {
	   	if(a.tonode_x != 0 && a.fromnode_x != Side+1) //Not the Exit or the Entry nodes
	   		Potential[a.tonode_x][a.tonode_y] >= Potential[a.fromnode_x][a.fromnode_y]+1-BigNumb*(1-Flow[a]);
	   		//Flow[a]*(Potential[a.tonode_x][a.tonode_y]-Potential[a.fromnode_x][a.fromnode_y]) >= 1;
	  }
}

execute DISPLAY {
   writeln("\n<from node,to node,Flow[a]>\n");
   for(var a in Arcs)
      if(Flow[a] > 0)
         writeln("<",a.fromnode_x,",",a.fromnode_y, " -> ", a.tonode_x,",", a.tonode_y,";",Flow[a],">");
   writeln("<",TotalFlow,">");
}


