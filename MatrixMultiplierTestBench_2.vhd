library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;        -- for addition & counting
use ieee.numeric_std.all;               -- for type conversions
use ieee.math_real.all;                 -- for the ceiling and log constant calculation functions
library work;
use work.all;
use work.Common.all;
entity MatrixMultiplierTestBench_2 is
end MatrixMultiplierTestBench_2;
/*
	In this test we pick the left matrix with the first row all set to (-8) {base 10}, other values at 0
	The right matrix with first column all set to (-8) {base 10}, other values at 0.
	We expect to obtain (-8*-8*3)=(192) {base 10}
*/
architecture MatrixMultiplierTestBench_2_arc of MatrixMultiplierTestBench_2 is
	component MatrixMultiplierArchitecture
		generic (
				matrixAColNumber : positive;
				matrixBColNumber : positive;
				matrixARowNumber : positive;
				matrixBRowNumber : positive
			);
		port (
			clock	: in std_ulogic;
			reset	: in std_ulogic;
			matrixA : in BitMatrix(0 to matrixARowNumber-1,0 to matrixAColNumber)(3 downto 0);
			matrixB : in BitMatrix(0 to matrixBRowNumber-1,0 to matrixBColNumber)(3 downto 0);
			matrixP : out BitMatrix(0 to matrixARowNumber-1,0 to matrixBColNumber)(integer(real(7)+ceil(log2(real(matrixAColNumber)))) downto 0 )
		);
	end component MatrixMultiplierArchitecture;
	signal tbMa: BitMatrix(0 to 1,0 to 2)(3 downto 0):=(("1000","1000","1000"),("0000","0000","0000"));
	signal tbMb: BitMatrix(0 to 2,0 to 3)(3 downto 0):=(("1000","0000","0000","0000"),("1000","0000","0000","0000"),("1000","0000","0000","0000"));
	signal tbMOut: BitMatrix(0 to 1,0 to 3)(8 downto 0):=(others => (others => (others => '0')));
	signal clock: std_ulogic:='0';
	signal reset: std_ulogic:='1';
begin
	clock <= not clock after 50 ns;
	myMultiplier: MatrixMultiplierArchitecture generic map(matrixAColNumber => 3,matrixARowNumber => 2,matrixBColNumber => 4,matrixBRowNumber=>3) port map(matrixA => tbMa,matrixB =>tbMb,matrixP=>tbMOut, clock => clock, reset=> reset);
	drive : process 
	begin
		reset <= '1';
		wait until rising_edge(clock);
		reset <= '0';
		wait;
	end process drive;	
end MatrixMultiplierTestBench_2_arc;
