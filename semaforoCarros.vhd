library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity semaforoCarros_Vertical is
	Port ( 
		clk	:	in STD_LOGIC;
		reset	:	in STD_LOGIC	:= '0';
		verde_semaforoCarros		:	out STD_LOGIC							:= '0';
		amarelo_semaforoCarros	:	out STD_LOGIC							:= '0';
		vermelho_semaforoCarros	:	out STD_LOGIC							:= '1';
		estado_semaforoCarros	: out STD_LOGIC_VECTOR(2 downto 0)	:= "100"
	);
end semaforoCarros_Vertical;

architecture Combined of semaforoCarros_Vertical is

	signal segundos_internal						:	INTEGER		:= 0;
	signal reset_cronometro_internal				:	STD_LOGIC	:= '0';
	signal fim_tempoVerde_carros_internal		:	STD_LOGIC	:= '0';
	signal fim_tempoAmarelo_carros_internal	:	STD_LOGIC	:= '0';
	signal fim_tempoVermelho_carros_internal	:	STD_LOGIC	:= '0';

	component cronometro_semaforoCarros_Vertical
		Port ( 
			clk               :	in STD_LOGIC;
			reset_cronometro	:	in STD_LOGIC := '0';
			segundos          :	out INTEGER := 0
		);
	end component;

	component comparador_semaforoCarros_Vertical
		Port ( 
			clk               :	in STD_LOGIC;
			reset_cronometro	:	in STD_LOGIC	:= '0';
			segundos          :	in INTEGER		:= 0;
			fim_tempoVerde_carros		:	out STD_LOGIC := '0';
			fim_tempoAmarelo_carros		:	out STD_LOGIC := '0';
			fim_tempoVermelho_carros	:	out STD_LOGIC := '0'
		);
  end component;
  
	component FSM_semaforoCarros_Vertical
		Port ( 
			clk								:	in STD_LOGIC;	-- Sinal de entrada de clock
			reset								:	in STD_LOGIC := '0';	-- Sinal de entrada de reset
			fim_tempoVerde_carros		:	in STD_LOGIC := '0';	-- sinal de entrada se o tempo da luz verde atingiu o limite
			fim_tempoAmarelo_carros		:	in STD_LOGIC := '0';	-- sinal de entrada se o tempo da luz amarela atingiu o limite
			fim_tempoVermelho_carros	:	in STD_LOGIC := '0';	-- sinal de entrada se o tempo da luz vermelha atingiu o limite
			verde_semaforoCarros		:	out STD_LOGIC							:= '0';	-- Sinal de saída da luz verde
			amarelo_semaforoCarros	:	out STD_LOGIC							:= '0';	-- Sinal de saída da luz amarela
			vermelho_semaforoCarros	:	out STD_LOGIC							:= '1';	-- Sinal de saída da luz vermelha
			estado_semaforoCarros	:	out STD_LOGIC_VECTOR(2 downto 0) := "100";	-- Sinal de saída do estado do semáforo (vermelho, amarelo, verde)
			reset_cronometro			:	out STD_LOGIC							:= '0'
		);
	end component;

begin
	cronometro_semaforoCarros_Vertical_inst : cronometro_semaforoCarros_Vertical
		port map (
			clk               => clk,
			reset_cronometro  => reset_cronometro_internal,
			segundos          => segundos_internal
		);

	comparador_semaforoCarros_Vertical_inst : comparador_semaforoCarros_Vertical
		port map (
			clk               			=> clk,
			reset_cronometro  			=> reset_cronometro_internal,
			segundos          			=> segundos_internal,
			fim_tempoVerde_carros		=> fim_tempoVerde_carros_internal,
			fim_tempoAmarelo_carros    => fim_tempoAmarelo_carros_internal,
			fim_tempoVermelho_carros	=> fim_tempoVermelho_carros_internal
		);
		
	FSM_semaforoCarros_Vertical_inst : FSM_semaforoCarros_Vertical
		port map (
			clk               => clk,
			reset  				=> reset,
			fim_tempoVerde_carros     => fim_tempoVerde_carros_internal,
			fim_tempoAmarelo_carros    => fim_tempoAmarelo_carros_internal,
			fim_tempoVermelho_carros       => fim_tempoVermelho_carros_internal,
			verde_semaforoCarros		=> verde_semaforoCarros,
			amarelo_semaforoCarros	=>	amarelo_semaforoCarros,
			vermelho_semaforoCarros	=> vermelho_semaforoCarros,
			estado_semaforoCarros => estado_semaforoCarros,
			reset_cronometro	=> reset_cronometro_internal
		);

end Combined;
