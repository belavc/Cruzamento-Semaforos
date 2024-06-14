library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity semaforo_Vertical is
	Port ( 
		clk	:	in STD_LOGIC;
		reset	:	in STD_LOGIC	:= '0';
		verde_semaforoCarros			:	out STD_LOGIC							:= '0';
		amarelo_semaforoCarros		:	out STD_LOGIC							:= '0';
		vermelho_semaforoCarros		:	out STD_LOGIC							:= '1';
		estado_semaforoCarros		: out STD_LOGIC_VECTOR(2 downto 0)	:= "100";
		verde_semaforoPedestres		:	out STD_LOGIC							:= '1';
		vermelho_semaforoPedestres	:	out STD_LOGIC							:= '0';
		estado_semaforoPedestres	: out STD_LOGIC_VECTOR(1 downto 0)	:= "01"		
	);
end semaforo_Vertical;

architecture Combined of semaforo_Vertical is

	component semaforoCarros_Vertical
		Port ( 
		clk	:	in STD_LOGIC;
		reset	:	in STD_LOGIC	:= '0';
		verde_semaforoCarros		:	out STD_LOGIC							:= '0';
		amarelo_semaforoCarros	:	out STD_LOGIC							:= '0';
		vermelho_semaforoCarros	:	out STD_LOGIC							:= '1';
		estado_semaforoCarros	:	out STD_LOGIC_VECTOR(2 downto 0)	:= "100"
		);
	end component;

	component semaforoPedestres_Vertical
		Port ( 
			clk	:	in STD_LOGIC;
			reset	:	in STD_LOGIC	:= '0';
			verde_semaforoPedestres		:	out STD_LOGIC							:= '1';
			vermelho_semaforoPedestres	:	out STD_LOGIC							:= '0';
			estado_semaforoPedestres	: out STD_LOGIC_VECTOR(1 downto 0)	:= "01"
		);
  end component;

begin
	semaforoCarros_Vertical_inst : semaforoCarros_Vertical
		port map (
			clk               		=> clk,
			reset 						=> reset,
			verde_semaforoCarros		=> verde_semaforoCarros,
			amarelo_semaforoCarros	=> amarelo_semaforoCarros,
			vermelho_semaforoCarros	=> vermelho_semaforoCarros,
			estado_semaforoCarros	=> estado_semaforoCarros
		);

	semaforoPedestres_Vertical_inst : semaforoPedestres_Vertical
		port map (
			clk               			=> clk,
			reset  							=> reset,
			verde_semaforoPedestres		=> verde_semaforoPedestres,
			vermelho_semaforoPedestres	=> vermelho_semaforoPedestres,
			estado_semaforoPedestres	=> estado_semaforoPedestres
		);

end Combined;
