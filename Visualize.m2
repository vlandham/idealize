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
    	Version => "0.1", 
    	Date => "May 28, 2013",
    	Authors => {
	     {Name => "Branden Stone", Email => "bstone@bard.edu", HomePage => "http://www.bard.edu/~bstone/"},	     
	     {Name => "Jim Vallandingham", Email => "vlandham@gmail.com", HomePage => "http://vallandingham.me/"}	     
	     },
    	Headline => "Visualize",
    	DebuggingMode => true
    	)

export {
     "visIntegralClosure",
     "visIdeal"
}


------------------------------------------------------------
-- METHODS
------------------------------------------------------------

--input: A string that is an array passed from visIdeal or visIntegralClosure
--output: The Newton polytope of the input array.
--
visIdealOutput = method()
visIdealOutput(String) := S -> (
    local fileName; local openFile; local PATH;
   
    fileName = (toString currentTime() )|".html";
    PATH = "./temp-files/"|fileName;
--    PATH = fileName;
    openOut PATH << 
       get "./templates/visIdeal/temp01.html" << 
       endl << 
       "    var data = "|S|";" << 
       endl << endl <<
       get "./templates/visIdeal/temp02.html" << 
       close;
       
    openFile = "open "|PATH;
    
    return run openFile;
    )

--input: A monomial ideal of a polynomial ring in 2 or 3 variables.
--output: The newton polytope of the of the ideal.
--
visIdeal = method()
visIdeal(Ideal) := J -> (
    local G; local arrayList; local arrayString; 

    G = flatten entries gens J;
    arrayList = new Array from apply(G, i -> new Array from flatten exponents i);
    arrayString = toString arrayList;
    
    return visIdealOutput arrayString; 
    )


--input: A monomial ideal of a polynomial ring in 2 or 3 variables.
--output: The newton polytope of the integral closure of the ideal.
--
visIntegralClosure = method()
visIntegralClosure(Ideal) := J -> (
    local G; local arrayList; local arrayString; 
    local fileName; local openFile;


    G = flatten entries gens integralClosure J;
    arrayList = new Array from apply(G, i -> new Array from flatten exponents i);
    arrayString = toString arrayList;
    
    return visIdealOutput arrayString; 
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
I = ideal"x2,y3,z4"
visIdeal I
visIntegralClosure I
