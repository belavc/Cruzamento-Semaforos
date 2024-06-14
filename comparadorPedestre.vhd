----- Comparador para controle do semáforo: comparador_semaforoPedestres_Vertical.vhdl -----

---- Bibliotecas necessárias ----
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Definindo uma entidade do comparador ----
entity comparador_semaforoPedestres_Vertical is
	Port ( 
		clk					:	in STD_LOGIC; -- Sinal de entrada de clock
		reset_cronometro	:	in STD_LOGIC	:= '0'; -- Sinal de entrada de reset do cronômetro
		segundos				:	in INTEGER		:= 0; -- Sinal de entrada de quantos segundos passaram	
		fim_tempoVerde_pedestres		:	out STD_LOGIC	:= '0'; -- Sinal se o tempo da luz verde do semáforo de carros atingiu o limite
		fim_tempoVermelho_pedestres	:	out STD_LOGIC	:= '0' -- Sinal se o tempo da luz vermelha do semáforo de carros atingiu o limite
	);
end comparador_semaforoPedestres_Vertical;	---- Finalizada a definição da entidade do comparador ----

---- Arquitetura do comportamental do comparador ----
architecture Comportamental of comparador_semaforoPedestres_Vertical is
constant GREEN_TIME_PEDESTRES	:	INTEGER := 9; -- Segundos definidos para o tempo do led verde do semáforo de carros
constant RED_TIME_PEDESTRES	:	INTEGER := 15; -- Segundos definidos para o tempo do led vermelho do semáforo de carros
	
begin	-- Começando a arquitetura comportamental
	process(clk, reset_cronometro) -- Processo sensível ao clock e ao reset
	begin	-- Começando o processo
		if reset_cronometro = '1' then -- Se resetar o cronômetro, eu reseto todas as confirmações de fim de tempo dos leds
			fim_tempoVermelho_pedestres <= '0'; 
			fim_tempoVerde_pedestres <= '0';
			
		elsif rising_edge(clk) then -- Se ocorrer uma borda de clock
			if segundos >= RED_TIME_PEDESTRES then -- Se o segundos for maior ou igual o tempo máximo do vermelho dos carros em ação
				fim_tempoVermelho_pedestres <= '1'; -- Indica que o tempo do vermelho dos carros acabou		
			elsif segundos >= GREEN_TIME_PEDESTRES then -- Se o segundos for maior ou igual o tempo máximo do verde dos carros em ação
				fim_tempoVerde_pedestres <= '1'; -- Indica que o tempo do verde dos carros acabou
			end if;

		end if;
		
	end process;	-- Termina o processo de mudança de estado

end Comportamental; --- Termina a arquitetura comportamental ---
