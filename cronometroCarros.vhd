----- Cronômetro para controle do semáforo: cronometro_semaforoCarros_Vertical.vhdl -----

---- Bibliotecas necessárias ----
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Definindo uma entidade do cronômetro ----
entity cronometro_semaforoCarros_Vertical is
	Port ( 
		clk					:	in STD_LOGIC;	-- Sinal de entrada de clock
		reset_cronometro	:	in STD_LOGIC	:= '0';	-- Sinal de entrada de reset do cronômetro (reinicia a contagem)
		segundos				:	out INTEGER		:= 0	-- Sinal de saída dos segundos convertidos a partir do clock
	);
end cronometro_semaforoCarros_Vertical;	---- Finalizada a definição da entidade do cronômetro ----

---- Arquitetura do comportamental do cronômetro ----
architecture Comportamental of cronometro_semaforoCarros_Vertical is

	
begin	-- Começando a arquitetura comportamental
	process(clk, reset_cronometro)	-- Processo sensível ao clock e ao reset
	variable contador			:	INTEGER	:= 0;	-- Definindo um sinal contador, que vai contar o número de ciclos de clock
	variable temp_segundos	:	INTEGER	:= 0;
	
	begin	-- Começando o processo
		if reset_cronometro = '1' then -- Se eu resetar o cronômetro
			contador := 0; -- O contador zera
			temp_segundos := 0; -- O temp_segundos zera
			segundos <= 0; -- A saída dos segundos zera
			
		elsif rising_edge(clk) then -- Mas se der uma borda de clock
			if reset_cronometro = '1' then
				contador := 0; -- O contador zera
				temp_segundos := 0; -- O temp_segundos zera
				segundos <= 0; -- A saída dos segundos zera
				
			else 
				contador := contador + 1; -- Soma 1 no contador
				if contador = 5 then -- Se o contador atingir o número de clocks em 1 segundo (trocar para 50000000 quando for implementar)
					contador := 0;  -- Zera o contador
					temp_segundos := temp_segundos + 1; -- O temp_segundos soma 1
					segundos <= temp_segundos; -- O segundos recebe o temp_segundos
				end if;
				
			end if;
			
		end if;
		
	end process;	-- Termina o processo de mudança de estado

end Comportamental; --- Termina a arquitetura comportamental ---
