library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;        -- for addition & counting
use ieee.numeric_std.all;               -- for type conversions
use ieee.math_real.all;                 -- for the ceiling and log constant calculation functions
library work;
use work.Common.all;
/*
	This module implements the core matrix multiplication logic, via a VHDL function "matmu"
*/
entity MatrixMultiplier is
	generic (
			matrixAColNumber : positive;
			matrixBColNumber : positive;
			matrixARowNumber : positive;
			matrixBRowNumber : positive
		);
	port (
		matrixA : in BitMatrix(0 to matrixARowNumber-1,0 to matrixAColNumber-1)(3 downto 0);
		matrixB : in BitMatrix(0 to matrixBRowNumber-1,0 to matrixBColNumber-1)(3 downto 0);
		-- Cell sizing for product matrix done according to computations done in Report 
		matrixP : out BitMatrix(0 to matrixARowNumber-1,0 to matrixBColNumber-1)(integer(real(7)+floor(log2(real(matrixAColNumber)))) downto 0 )
	);
end MatrixMultiplier;

architecture MatrixMultiplier_arc of MatrixMultiplier is
	function  Multiply  ( a : BitMatrix; b:BitMatrix) return BitMatrix is
	variable i,j,k : integer:=0;
	variable product : BitMatrix(0 to matrixARowNumber-1,0 to matrixBColNumber-1)(integer(real(7)+floor(log2(real(matrixAColNumber)))) downto 0 ):=(others => (others => (others => '0')));
	begin
		for i in 0 to matrixARowNumber-1 loop
			for j in 0 to matrixBColNumber-1 loop
				for k in 0 to matrixAColNumber-1 loop
					/*
					  Right-hand operation inside the curve brackets will never overflow
					  because:
					  1)Product is automatically resized into a signed of 8 bits
					  2)Sum of signed is resized to the # of digits of the longest
					  	operand, in this case signed(product(i,j)). This dimension
					  	has been proven to be sufficient to contain the overall arithmetic
					  	operation in the Report.
					  SOURCE: https://www.csee.umbc.edu/portal/help/VHDL/numeric_std.vhdl
					*/ 
		   			product(i,j) := std_ulogic_vector(signed(product(i,j)) + (signed(a(i,k)) * signed(b(k,j))));
				end loop;
			end loop;
		end loop;
		return product;
	end Multiply;	
begin
	matrixP <= Multiply(matrixA,matrixB);
end MatrixMultiplier_arc;

