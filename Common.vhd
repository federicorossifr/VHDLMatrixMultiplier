library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;        -- for addition & counting
use ieee.numeric_std.all;               -- for type conversions
/*
	This package contains the type definition for the 
	core matrix type used by all modules in this project.

	Unconstrained std_ulogic_vector is available since VHDL-2008,
	instantiation is delegated to client modules. 
*/
package Common is
	type BitMatrix is array(natural range<>,natural range<>) of std_ulogic_vector;
end Common;

package body Common is
end Common;
