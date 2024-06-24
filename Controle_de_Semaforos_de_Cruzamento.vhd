library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Controle_de_Semaforos_de_Cruzamento is
Port (
    clk : in STD_LOGIC;  -- Clock de 50 MHz da FPGA
    reset : in STD_LOGIC;
    ped_button : in STD_LOGIC;
    N_S : out STD_LOGIC_VECTOR (2 downto 0);
    E_W : out STD_LOGIC_VECTOR (2 downto 0);
    ped_light : out STD_LOGIC_VECTOR (1 downto 0)
);
end Controle_de_Semaforos_de_Cruzamento;

architecture Behavioral of Controle_de_Semaforos_de_Cruzamento is

type state_type is (RED_N_S_GREEN_E_W, RED_N_S_YELLOW_E_W, GREEN_N_S_RED_E_W, YELLOW_N_S_RED_E_W, PED_CROSS);
signal state, next_state : state_type;

signal counter : integer range 0 to 50_000_000 := 0;
signal ped_request : STD_LOGIC := '0';
signal clk_div : STD_LOGIC := '0';
signal clk_counter : integer range 0 to 49_999_999 := 0;

constant RED_TIME : integer := 10; 
constant YELLOW_TIME : integer := 3;
constant GREEN_TIME : integer := 7;
constant PED_TIME : integer := 5;

constant RED : STD_LOGIC_VECTOR(2 downto 0) := "100";
constant YELLOW : STD_LOGIC_VECTOR(2 downto 0) := "010";
constant GREEN : STD_LOGIC_VECTOR(2 downto 0) := "001";
constant PED_RED : STD_LOGIC_VECTOR(1 downto 0) := "10";
constant PED_GREEN : STD_LOGIC_VECTOR(1 downto 0) := "01";

begin

    -- Clock divider process
    process(clk, reset)
    begin
        if reset = '1' then
            clk_counter <= 0;
            clk_div <= '0';
        elsif rising_edge(clk) then
            if clk_counter = 49_999_999 then
                clk_counter <= 0;
                clk_div <= not clk_div;
            else
                clk_counter <= clk_counter + 1;
            end if;
        end if;
    end process;

    -- Main process
    process(clk_div, reset)
    begin
        if reset = '1' then
            state <= RED_N_S_GREEN_E_W;
            counter <= 0;
            ped_request <= '0';
        elsif rising_edge(clk_div) then
            if ped_button = '1' then
                ped_request <= '1';
            end if;

            if counter = 0 then
                state <= next_state;
                case next_state is
                    when RED_N_S_GREEN_E_W => 
                        counter <= RED_TIME;
                    when RED_N_S_YELLOW_E_W => 
                        counter <= YELLOW_TIME;
                    when GREEN_N_S_RED_E_W => 
                        counter <= GREEN_TIME;
                    when YELLOW_N_S_RED_E_W => 
                        counter <= YELLOW_TIME;
                    when PED_CROSS => 
                        counter <= PED_TIME;
                end case;
            else
                counter <= counter - 1;
            end if;
        end if;
    end process;

    process(state, ped_request)
    begin
        case state is
            when RED_N_S_GREEN_E_W => 
                if ped_request = '1' then
                    next_state <= PED_CROSS;
                else
                    next_state <= RED_N_S_YELLOW_E_W;
                end if;
            when RED_N_S_YELLOW_E_W => 
                next_state <= GREEN_N_S_RED_E_W;
            when GREEN_N_S_RED_E_W => 
                next_state <= YELLOW_N_S_RED_E_W;
            when YELLOW_N_S_RED_E_W => 
                if ped_request = '1' then
                    next_state <= PED_CROSS;
                else
                    next_state <= RED_N_S_GREEN_E_W;
                end if;
            when PED_CROSS => 
                next_state <= RED_N_S_GREEN_E_W;
            when others => 
                next_state <= RED_N_S_GREEN_E_W;
        end case;
    end process;

    process(state)
    begin
        case state is
            when RED_N_S_GREEN_E_W => 
                N_S <= RED;
                E_W <= GREEN;
                ped_light <= PED_RED;
            when RED_N_S_YELLOW_E_W => 
                N_S <= RED;
                E_W <= YELLOW;
                ped_light <= PED_RED;
            when GREEN_N_S_RED_E_W => 
                N_S <= GREEN;
                E_W <= RED;
                ped_light <= PED_RED;
            when YELLOW_N_S_RED_E_W => 
                N_S <= YELLOW;
                E_W <= RED;
                ped_light <= PED_RED;
            when PED_CROSS => 
                N_S <= RED;
                E_W <= RED;
                ped_light <= PED_GREEN;
            when others => 
                N_S <= RED;
                E_W <= RED;
                ped_light <= PED_RED;
        end case;
    end process;

end Behavioral;
