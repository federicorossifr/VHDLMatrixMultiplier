library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;        -- for addition & counting
library work;
use work.Common.all;
/*
	This module has the task to hold a matrix like a D-FLIP FLOP.
*/
entity MatrixRegister is
	generic (
			matrixRowNumber : positive;
			matrixColNumber : positive;
			cellBits		: positive
	);
	port (
		clock : in std_ulogic;
		reset : in std_ulogic;
		dIn   : in BitMatrix(0 to matrixRowNumber-1,0 to matrixColNumber-1)(cellBits downto 0);
		dOut  : out BitMatrix(0 to matrixRowNumber-1,0 to matrixColNumber-1)(cellBits downto 0)
	);
end MatrixRegister;

architecture MatrixRegister_arc of MatrixRegister is
begin	
	matReg: process(clock,reset)
		begin
			-- Synchronous reset/IN->OUT behaviour
			if (clock='1' and clock'event) then
				if(reset = '1') then
					dOut<=(others => (others => (others => '0')));
				else
					dOut <= dIn;
				end if;
			end if;
		end process matReg;
end MatrixRegister_arc;
