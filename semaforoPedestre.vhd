library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity semaforoPedestres_Vertical is
	Port ( 
		clk	:	in STD_LOGIC;
		reset	:	in STD_LOGIC	:= '0';
		verde_semaforoPedestres		:	out STD_LOGIC							:= '1';
		vermelho_semaforoPedestres	:	out STD_LOGIC							:= '0';
		estado_semaforoPedestres	: out STD_LOGIC_VECTOR(1 downto 0)	:= "01"
	);
end semaforoPedestres_Vertical;

architecture Combined of semaforoPedestres_Vertical is

	signal segundos_internal						:	INTEGER		:= 0;
	signal reset_cronometro_internal				:	STD_LOGIC	:= '0';
	signal fim_tempoVerde_pedestres_internal		:	STD_LOGIC	:= '0';
	signal fim_tempoVermelho_pedestres_internal	:	STD_LOGIC	:= '0';

	component cronometro_semaforoPedestres_Vertical
		Port ( 
			clk               :	in STD_LOGIC;
			reset_cronometro	:	in STD_LOGIC := '0';
			segundos          :	out INTEGER := 0
		);
	end component;

	component comparador_semaforoPedestres_Vertical
		Port ( 
			clk               :	in STD_LOGIC;
			reset_cronometro	:	in STD_LOGIC	:= '0';
			segundos          :	in INTEGER		:= 0;
			fim_tempoVerde_pedestres		:	out STD_LOGIC := '0';
			fim_tempoVermelho_pedestres	:	out STD_LOGIC := '0'
		);
  end component;
  
	component FSM_semaforoPedestres_Vertical
		Port ( 
			clk									:	in STD_LOGIC;	-- Sinal de entrada de clock
			reset									:	in STD_LOGIC := '0';	-- Sinal de entrada de reset
			fim_tempoVerde_pedestres		:	in STD_LOGIC := '0';	-- sinal de entrada se o tempo da luz verde atingiu o limite
			fim_tempoVermelho_pedestres	:	in STD_LOGIC := '0';	-- sinal de entrada se o tempo da luz vermelha atingiu o limite
			verde_semaforoPedestres		:	out STD_LOGIC							:= '1';	-- Sinal de saída da luz verde
			vermelho_semaforoPedestres	:	out STD_LOGIC							:= '0';	-- Sinal de saída da luz vermelha
			estado_semaforoPedestres	:	out STD_LOGIC_VECTOR(1 downto 0) := "01";	-- Sinal de saída do estado do semáforo (vermelho, amarelo, verde)
			reset_cronometro				:	out STD_LOGIC							:= '0'
		);
	end component;

begin
	cronometro_semaforoPedestres_Vertical_inst : cronometro_semaforoPedestres_Vertical
		port map (
			clk               => clk,
			reset_cronometro  => reset_cronometro_internal,
			segundos          => segundos_internal
		);

	comparador_semaforoPedestres_Vertical_inst : comparador_semaforoPedestres_Vertical
		port map (
			clk               				=> clk,
			reset_cronometro  				=> reset_cronometro_internal,
			segundos          				=> segundos_internal,
			fim_tempoVerde_pedestres		=> fim_tempoVerde_pedestres_internal,
			fim_tempoVermelho_pedestres	=> fim_tempoVermelho_pedestres_internal
		);
		
	FSM_semaforoPedestres_Vertical_inst : FSM_semaforoPedestres_Vertical
		port map (
			clk               				=> clk,
			reset  								=> reset,
			fim_tempoVerde_pedestres		=> fim_tempoVerde_pedestres_internal,
			fim_tempoVermelho_pedestres	=> fim_tempoVermelho_pedestres_internal,
			verde_semaforoPedestres			=> verde_semaforoPedestres,
			vermelho_semaforoPedestres		=> vermelho_semaforoPedestres,
			estado_semaforoPedestres 		=> estado_semaforoPedestres,
			reset_cronometro					=> reset_cronometro_internal
		);

end Combined;
