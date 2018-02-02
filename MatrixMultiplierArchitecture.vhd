library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;        -- for addition & counting
use ieee.numeric_std.all;               -- for type conversions
use ieee.math_real.all;                 -- for the ceiling and log constant calculation functions
library work;
use work.all;
use work.Common.all;
/*
	This is the overall architecture of the multiplier including input/output registers,
	as described in the Report (section 2.1)
*/
entity MatrixMultiplierArchitecture is
	generic (
			matrixAColNumber : positive;
			matrixBColNumber : positive;
			matrixARowNumber : positive;
			matrixBRowNumber : positive
		);
	port (
		clock	: in std_ulogic;
		reset   : in std_ulogic;
		matrixA : in BitMatrix(0 to matrixARowNumber-1,0 to matrixAColNumber-1)(3 downto 0);
		matrixB : in BitMatrix(0 to matrixBRowNumber-1,0 to matrixBColNumber-1)(3 downto 0);
		matrixP : out BitMatrix(0 to matrixARowNumber-1,0 to matrixBColNumber-1)(integer(real(7)+floor(log2(real(matrixAColNumber)))) downto 0 )
	);
end MatrixMultiplierArchitecture;

architecture MatrixMultiplierArchitecture_arc of MatrixMultiplierArchitecture is
	-- We define output sizing as a constant to ease readability later on.
	constant outBits : positive := integer(real(7)+floor(log2(real(matrixAColNumber))));
	component MatrixRegister
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
	end component MatrixRegister;

	component MatrixMultiplier
		generic (
			matrixAColNumber : positive;
			matrixBColNumber : positive;
			matrixARowNumber : positive;
			matrixBRowNumber : positive
		);
		port (
			matrixA : in BitMatrix(0 to matrixARowNumber-1,0 to matrixAColNumber-1)(3 downto 0);
			matrixB : in BitMatrix(0 to matrixBRowNumber-1,0 to matrixBColNumber-1)(3 downto 0);
			matrixP : out BitMatrix(0 to matrixARowNumber-1,0 to matrixBColNumber-1)(outBits downto 0 )
		);
	end component MatrixMultiplier;

	signal regAOut : BitMatrix(0 to matrixARowNumber-1,0 to matrixAColNumber-1)(3 downto 0);
	signal regBOut : BitMatrix(0 to matrixBRowNumber-1,0 to matrixBColNumber-1)(3 downto 0);
	signal multOut : BitMatrix(0 to matrixARowNumber-1,0 to matrixBColNumber-1)(outBits downto 0 );
begin

inMatrixAReg : MatrixRegister 	generic map (
									matrixColNumber => matrixAColNumber, 
									matrixRowNumber => matrixARowNumber, 
									cellBits => 3
								) 
						      	port map (dIn => matrixA,clock => clock, reset => reset,dOut => regAOut);
inMatrixBReg : MatrixRegister 	generic map (
									matrixColNumber => matrixBColNumber,
									matrixRowNumber => matrixBRowNumber,
									cellBits => 3
								) 
							  	port map (dIn => matrixB,clock => clock, reset => reset,dOut => regBOut);
myMultiplier : MatrixMultiplier generic map(
									matrixAColNumber => matrixAColNumber,
									matrixARowNumber => matrixARowNumber,
									matrixBColNumber => matrixBColNumber,
									matrixBRowNumber=>matrixBRowNumber
								) 
							    port map(matrixA => regAOut,matrixB =>regBOut,matrixP=>multOut);
outMatrixReg : MatrixRegister 	generic map (
									matrixColNumber => matrixBColNumber, 
									matrixRowNumber => matrixARowNumber, 
									cellBits => outBits
								) 
							  	port map(dIn =>multOut, dOut=>matrixP, clock => clock, reset => reset);
end MatrixMultiplierArchitecture_arc;
