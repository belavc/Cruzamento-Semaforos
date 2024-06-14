----- FSM do semáforo de carros: FSM_semaforoPedestres_Vertical.vhdl -----

---- Bibliotecas necessárias ----
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


---- Definindo uma entidade de semáforo de carros ----
entity FSM_semaforoPedestres_Vertical is
	Port ( 
		clk									: in STD_LOGIC;	-- Sinal de entrada de clock
		reset									: in STD_LOGIC := '0';	-- Sinal de entrada de reset
		fim_tempoVerde_pedestres		: in STD_LOGIC := '0';	-- Sinal de entrada se o tempo da luz verde atingiu o limite
		fim_tempoVermelho_pedestres	: in STD_LOGIC := '0';	-- Sinal de entrada se o tempo da luz vermelha atingiu o limite
		verde_semaforoPedestres		: out STD_LOGIC 							:= '1';	-- Sinal de saída da luz verde do semáforo dos carros
		vermelho_semaforoPedestres	: out STD_LOGIC 							:= '0';	-- Sinal de saída da luz vermelha do semáforo dos carros
		estado_semaforoPedestres	: out STD_LOGIC_VECTOR(1 downto 0)	:= "01";	-- Sinal de saída do estado do semáforo (vermelho, amarelo, verde)
		reset_cronometro				: out STD_LOGIC 							:= '0' -- Sinal de saída para resetar o cronômetro		
	);
end FSM_semaforoPedestres_Vertical;	---- Finalizada a definição da entidade do semáforo de carros ----


---- Arquitetura do comportamental do semáforo de carros ----
architecture Comportamental of FSM_semaforoPedestres_Vertical is
	type StateType is (Vermelho, Verde);	-- Definindo um tipo StateType que armazena os estados
	signal estado : StateType := Vermelho;				-- Definindo um sinal estado que é do tipo StateType, que começa como Vermelho

begin	-- Começando a arquitetura comportamental
	
	process(clk, reset)	-- Processo para fazer a mudança nos estados, sensível ao clock e ao reset
	begin	-- Começando o processo
		if reset = '1' then	-- Caso o reset seja ativado
			verde_semaforoPedestres <= '1';	-- Acende a luz verde
			vermelho_semaforoPedestres <= '0';
			estado <= Verde;	-- O semáforo fica Vermelho
			estado_semaforoPedestres <= "01";	-- Luz Vermelha ligada			
			reset_cronometro <= '1';
		
		elsif rising_edge(clk) then	-- Se não for resetado e tiver uma borda de subida de clock
			case estado is	-- Analisa o estado do semáforo
				when Vermelho =>	-- Se o semáforo estiver Vermelho
					reset_cronometro <= '0';
					estado_semaforoPedestres <= "10";	-- Luz Vermelha ligada
					verde_semaforoPedestres <= '0';	-- Acende a luz verde
					vermelho_semaforoPedestres <= '1';	-- Acende a luz vermelha
					if fim_tempoVermelho_pedestres = '1' then	-- Se tiver estourado o tempo do Vermelho
						reset_cronometro <= '1';
						vermelho_semaforoPedestres <= '0';	-- Apaga a luz vermelha
						verde_semaforoPedestres <= '1';	-- Apaga a luz amarela
						estado <= Verde;	-- O semáforo fica Verde
						estado_semaforoPedestres <= "01";
					else	-- Caso não tenha estourado o tempo do Vermelho
						estado <= Vermelho;	-- O semáforo permanece Vermelho
					end if;	-- Termina a análise do estado Vermelho
				
				when Verde =>	-- Se o semáforo estiver Verde
					reset_cronometro <= '0';
					estado_semaforoPedestres <= "01";	-- Luz Verde ligada
					vermelho_semaforoPedestres <= '0';	-- Acende a luz vermelha
					verde_semaforoPedestres <= '1';	-- Acende a luz verde
					if fim_tempoVerde_pedestres = '1' then	-- Se tiver estourado o tempo do Verde
						reset_cronometro <= '1';
						verde_semaforoPedestres <= '0';	-- Acende a luz Verde
						vermelho_semaforoPedestres <= '1';	-- Apaga a luz vermelha
						estado <= Vermelho;	-- O semáforo fica Verde
						estado_semaforoPedestres <= "10";
					else	-- Caso não tenha estourado o tempo do Verde
						estado <= Verde;	-- O semáforo permanece Verde
					end if;	-- Termina a análise do estado Verde
				
				when others =>	-- Se o semáforo estiver em qualquer outro estado não declarado
						estado <= Vermelho;	-- O semáforo fica Vermelho
			end case;	-- Termina a análise de estado do semáforo
		end if;	-- Termina a análise do reset e subida de clock
	end process;	-- Termina o processo de mudança de estado

end Comportamental; --- Termina a arquitetura comportamental ---
