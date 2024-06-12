----- FSM do semáforo de carros: FSM_semaforoCarros_Vertical.vhdl -----

---- Bibliotecas necessárias ----
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


---- Definindo uma entidade de semáforo de carros ----
entity FSM_semaforoCarros_Vertical is
	Port ( 
		clk								: in STD_LOGIC;	-- Sinal de entrada de clock
		reset								: in STD_LOGIC := '0';	-- Sinal de entrada de reset
		fim_tempoVerde_carros		: in STD_LOGIC := '0';	-- Sinal de entrada se o tempo da luz verde atingiu o limite
		fim_tempoAmarelo_carros		: in STD_LOGIC := '0';	-- Sinal de entrada se o tempo da luz amarela atingiu o limite
		fim_tempoVermelho_carros	: in STD_LOGIC := '0';	-- Sinal de entrada se o tempo da luz vermelha atingiu o limite
		verde_semaforoCarros		: out STD_LOGIC := '0';	-- Sinal de saída da luz verde do semáforo dos carros
		amarelo_semaforoCarros	: out STD_LOGIC := '0';	-- Sinal de saída da luz amarela do semáforo dos carros
		vermelho_semaforoCarros	: out STD_LOGIC := '1';	-- Sinal de saída da luz vermelha do semáforo dos carros
		estado_semaforoCarros	: out STD_LOGIC_VECTOR(2 downto 0) := "100";	-- Sinal de saída do estado do semáforo (vermelho, amarelo, verde)
		reset_cronometro			: out STD_LOGIC := '0' -- Sinal de saída para resetar o cronômetro		
	);
end FSM_semaforoCarros_Vertical;	---- Finalizada a definição da entidade do semáforo de carros ----


---- Arquitetura do comportamental do semáforo de carros ----
architecture Comportamental of FSM_semaforoCarros_Vertical is
	type StateType is (Vermelho, Amarelo, Verde);	-- Definindo um tipo StateType que armazena os estados
	signal estado : StateType := Vermelho;				-- Definindo um sinal estado que é do tipo StateType, que começa como Vermelho

begin	-- Começando a arquitetura comportamental
	
	process(clk, reset)	-- Processo para fazer a mudança nos estados, sensível ao clock e ao reset
	begin	-- Começando o processo
		if reset = '1' then	-- Caso o reset seja ativado
			verde_semaforoCarros <= '0';	-- Acende a luz verde
			amarelo_semaforoCarros <= '0';	-- Apaga a luz amarela
			vermelho_semaforoCarros <= '1';
			estado <= Vermelho;	-- O semáforo fica Vermelho
			estado_semaforoCarros <= "100";	-- Luz Vermelha ligada			
			reset_cronometro <= '1';
		
		elsif rising_edge(clk) then	-- Se não for resetado e tiver uma borda de subida de clock
			case estado is	-- Analisa o estado do semáforo
				when Vermelho =>	-- Se o semáforo estiver Vermelho
					reset_cronometro <= '0';
					estado_semaforoCarros <= "100";	-- Luz Vermelha ligada
					verde_semaforoCarros <= '0';	-- Acende a luz verde
					amarelo_semaforoCarros <= '0';	-- Apaga a luz amarela
					vermelho_semaforoCarros <= '1';	-- Acende a luz vermelha
					if fim_tempoVermelho_carros = '1' then	-- Se tiver estourado o tempo do Vermelho
						reset_cronometro <= '1';
						vermelho_semaforoCarros <= '0';	-- Apaga a luz vermelha
						amarelo_semaforoCarros <= '0';	-- Apaga a luz amarela
						verde_semaforoCarros <= '1';	-- Acende a luz verde
						estado <= Verde;	-- O semáforo fica Verde
						estado_semaforoCarros <= "001";
					else	-- Caso não tenha estourado o tempo do Vermelho
						estado <= vermelho;	-- O semáforo permanece Vermelho
					end if;	-- Termina a análise do estado Vermelho
				
				when Amarelo =>	-- Se o semáforo estiver Amarelo
					reset_cronometro <= '0';
					estado_semaforoCarros <= "010";	-- Luz Amarela ligada
					verde_semaforoCarros <= '0';	-- Acende a luz verde
					vermelho_semaforoCarros <= '0';	-- Acende a luz vermelha
					amarelo_semaforoCarros <= '1';	-- Acende a luz Amarela
					if fim_tempoAmarelo_carros = '1' then	-- Se tiver estourado o tempo do Amarelo
						reset_cronometro <= '1';
						amarelo_semaforoCarros <= '0';	-- Apaga a luz Amarela
						verde_semaforoCarros <= '0';	-- Acende a luz Verde
						vermelho_semaforoCarros <= '1';	-- Acende a luz vermelha
						estado <= Vermelho;	-- O semáforo fica Vermelho
						estado_semaforoCarros <= "100";
					else	-- Caso não tenha estourado o tempo do Amarelo
						estado <= Amarelo;	-- O semáforo permanece Amarelo
					end if;	-- Termina a análise do estado Amarelo
				
				when Verde =>	-- Se o semáforo estiver Verde
					reset_cronometro <= '0';
					estado_semaforoCarros <= "001";	-- Luz Verde ligada
					verde_semaforoCarros <= '1';	-- Acende a luz verde
					amarelo_semaforoCarros <= '0';	-- Apaga a luz amarela
					vermelho_semaforoCarros <= '0';	-- Acende a luz vermelha
					if fim_tempoVerde_carros = '1' then	-- Se tiver estourado o tempo do Verde
						reset_cronometro <= '1';
						verde_semaforoCarros <= '0';	-- Acende a luz Verde
						vermelho_semaforoCarros <= '0';	-- Apaga a luz vermelha
						amarelo_semaforoCarros <= '1';	-- Acende a luz Amarela
						estado <= Amarelo;	-- O semáforo fica Verde
						estado_semaforoCarros <= "010";
					else	-- Caso não tenha estourado o tempo do Verde
						estado <= Verde;	-- O semáforo permanece Verde
					end if;	-- Termina a análise do estado Verde
				
				when others =>	-- Se o semáforo estiver em qualquer outro estado não declarado
						estado <= Vermelho;	-- O semáforo fica Vermelho
			end case;	-- Termina a análise de estado do semáforo
		end if;	-- Termina a análise do reset e subida de clock
	end process;	-- Termina o processo de mudança de estado

end Comportamental; --- Termina a arquitetura comportamental ---
