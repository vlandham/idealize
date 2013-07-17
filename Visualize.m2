--------------------------------------------------------------------------
-- PURPOSE : Visualize package for Macaulay2 provides the ability to 
-- visualize various algebraic objects in java script using a 
-- modern browser.
--
-- Copyright (C) 2013 Branden Stone and Jim Vallandingham
--
-- This program is free software; you can redistribute it and/or
-- modify it under the terms of the GNU General Public License version 2
-- as published by the Free Software Foundation.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--------------------------------------------------------------------------


newPackage(
	"Visualize",
    	Version => "0.2", 
    	Date => "July 17, 2013",
    	Authors => {
	     {Name => "Branden Stone", Email => "bstone@bard.edu", HomePage => "http://www.bard.edu/~bstone/"},	     
	     {Name => "Jim Vallandingham", Email => "vlandham@gmail.com", HomePage => "http://vallandingham.me/"}	     
	     },
    	Headline => "Visualize",
    	DebuggingMode => true
    	)

export {
    
    -- Options
     "Path",
    
    -- Methods
     "visIntegralClosure",
     "visIdeal"
}


------------------------------------------------------------
-- METHODS
------------------------------------------------------------

--input: A string that is an array passed from visIdeal or visIntegralClosure
--output: The Newton polytope of the input array.
--
visIdealOutput = method(Options => {Path => "./" })
visIdealOutput(String) := opts -> S -> (
    local fileName; local openFile; local PATH;
    
    fileName = (toString currentTime() )|".html";
    PATH = opts.Path|fileName;
    openOut PATH << 
    	replace("visArray", S, get "./templates/visIdeal/visIdeal.html") << 
	close;
        
--  openOut PATH << 
--     get "./templates/visIdeal/temp01.html" << 
--       endl << endl <<
--       "    var data = "|S|";" << 
--       endl << endl <<
--       get "./templates/visIdeal/temp02.html" << 
--       close;
       
    openFile = "open "|PATH;
    
    return run openFile;
    )

--input: A monomial ideal of a polynomial ring in 2 or 3 variables.
--output: The newton polytope of the of the ideal.
--
visIdeal = method(Options => {Path => "./" })
visIdeal(Ideal) := opts -> J -> (
--    local G; 
    local R;
    local arrayList; local arrayString; 
    
    R = ring J;
    arrayList = apply(flatten entries basis(0,infinity, R/J), m -> flatten exponents m );
    arrayList = new Array from apply(arrayList, i -> new Array from i);
    
--    G = flatten entries mingens J;
    
--    arrayList = new Array from apply(G, i -> new Array from flatten exponents i);
    arrayString = toString arrayList;
    
    return visIdealOutput(arrayString, Path => opts.Path );
    )


--input: A monomial ideal of a polynomial ring in 2 or 3 variables.
--output: The newton polytope of the integral closure of the ideal.
--
visIntegralClosure = method(Options => {Path => "./" })
visIntegralClosure(Ideal) := opts -> J -> (
    local G; local arrayList; local arrayString; 
    local fileName; local openFile;

    G = flatten entries mingens integralClosure J;
    arrayList = new Array from apply(G, i -> new Array from flatten exponents i);
    arrayString = toString arrayList;
    
    return visIdealOutput(arrayString, Path => opts.Path ); 
    )


--------------------------------------------------
-- DOCUMENTATION
--------------------------------------------------


beginDocumentation()

document {
     Key => Visualize,
     Headline => "A package to help visualize algebraic objects in the browser using javascript.",
     
     "Lots of cool stuff happens here.",
     
     PARA{}, "For the mathematical background see ",

     
     UL {
	  {"Winfried Bruns and Jürgen Herzog.", EM " Cohen-Macaulay Rings."},
	},
     
     }

-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------

end

-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------

restart
loadPackage"Visualize"

R = QQ[x,y,z]
I = ideal"x20,x2y2z,xy6z3,z8,y8"
I = ideal"x4,xy6z,x2y3,z4,y8"
I = ideal"x4,xy,yz,xz,z6,y5"
visIdeal(I, Path => "~/Dropbox/GitHub/idealize/temp-files/" )
visIntegralClosure(I, Path => "./temp-files/" )

S = QQ[x,y]
J = ideal"x3,y5"
visIdeal( J,  Path => "./temp-files/" )
visIntegralClosure( I,  Path => "./temp-files/" )


R = QQ[x,y,z]
I = ideal"x4,xy6z,x2y3,z4,y8"
G = flatten entries mingens I
ExpList = apply(G, g -> flatten exponents g )
maxX = 0
maxY = 0
maxZ = 0
scan( ExpList, e -> ( 
	  if e#0 > maxX then maxX = e#0;
	  if e#1 > maxY then maxY = e#1;
	  if e#2 > maxZ then maxZ = e#2;
	  )
     )
maxX,maxY,maxZ

divZ = (G,i) -> select(G, g -> (g%z^(i+1) != 0) and (g%z^i == 0) )

data = {{0,0,0}}

L = sort divZ(G,0)
H = unique apply(#L-1, i -> flatten exponents lcm(L#i, L#(i+1) ) )
data = unique join(data, flatten apply(H, h -> toList({0,0,0}..h) ) )

L = sort join(divZ(G,1), apply(L, l -> l*z ) )
H = unique apply(#L-1, i -> flatten exponents lcm(L#i, L#(i+1) ) )
data = unique join(data, flatten apply(H, h -> toList({0,0,0}..h) ) )

L = sort join(divZ(G,2), apply(L, l -> l*z ) )
H = unique apply(#L-1, i -> flatten exponents lcm(L#i, L#(i+1) ) )
data = unique join(data, flatten apply(H, h -> toList({0,0,0}..h) ) )

L = sort join(divZ(G,3), apply(L, l -> l*z ) )
H = unique apply(#L-1, i -> flatten exponents lcm(L#i, L#(i+1) ) )
data = unique join(data, flatten apply(H, h -> toList({0,0,0}..h) ) )

L = sort join(divZ(G,4), apply(L, l -> l*z ) )
H = unique apply(#L-1, i -> flatten exponents lcm(L#i, L#(i+1) ) )
data = unique join(data, flatten apply(H, h -> toList({0,0,0}..h) ) )

new Array from apply(data, i -> new Array from i)




viewHelp basis
S = R/I
data = apply(flatten entries basis(0,infinity, R/I ), m -> flatten exponents m )
new Array from apply(data, i -> new Array from i)

lcm(L_1,L_2,L_3)
H = flatten flatten apply(#L, j -> apply(#L, i -> apply(L, l -> (l, L#i, L#j) ) ))
Hh = unique apply(H, h->  flatten exponents lcm h )
sort Hh

H2 = unique flatten apply(Hh, h -> toList({0,0,0}..h) )
Ll = new Array from apply(H2, i -> new Array from i)
sort H2
