-- vhdl-linter-disable type-resolved
library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity led8x8 is
  port (
    clk:in std_logic;
    rst:in std_logic;
    col:out std_logic_vector(7 downto 0);
    row:out std_logic_vector(7 downto 0)
  ) ;
end led8x8; 

architecture arch of led8x8 is
type table8x8 is array (0 to 7) of std_logic_vector(0 to 41);
constant frame0 : table8x8 :=(("000000000000000000000000000000000000000000"),
                              ("000000001000100000111110000011111000000000"),
                              ("000000001000100001000001000000100000000000"),
                              ("000000001000100001000001000000100000000000"),
                              ("000000001111100001000001000000100000000000"),
                              ("000000001000100001000001000000100000000000"),
                              ("000000001000100001000001000000100000000000"),
                              ("000000001000100000111110000000100000000000"));
constant frame1 : table8x8 :=(("000000000000000000000000000000000000000000"),
                              ("000000000111000011100010000001111000000000"),
                              ("000000001000100100010010000001000100000000"),
                              ("000000001000000100010010000001000100000000"),
                              ("000000001000000100010010000001000100000000"),
                              ("000000001000100100010010000001000100000000"),
                              ("000000000111000011100011111001111000000000"),
                              ("000000000000000000000000000000000000000000"));
signal rowCounter:integer range 0 to 7;
signal scanClk:std_logic;
signal startPoint:integer range 0 to 34:=0;
begin
    freq: process(clk, rst)
    variable count:integer range 0 to 10000:=0;
    variable count2:integer range 0 to 5000000:=0;
    begin
        if rst='0' then
            count:=0;
        elsif clk'event and clk='1' then
            if count<10000 then
                count:=count+1;
            else
                scanClk<=not scanClk;
                count:=0;
            end if;
            if count2<5000000 then
                count2:=count2+1;
            else
                count2:=0;
                if startPoint<34 then
                    startPoint<=startPoint+1;
                else
                    startPoint<=0;
                end if;
            end if;
        end if;

    end process freq;

    display: process(scanClk, rst)
    -- variable ram:std_logic_vector(7 downto 0);
    begin
      if rst='0' then
        rowCounter<=0;
      elsif scanClk'event and scanClk='1' then
        col<=frame1(rowCounter)(startPoint to startPoint+7);
        case rowCounter is
            when 0=>row<=not "10000000";
            when 1=>row<=not "01000000";
            when 2=>row<=not "00100000";
            when 3=>row<=not "00010000";
            when 4=>row<=not "00001000";
            when 5=>row<=not "00000100";
            when 6=>row<=not "00000010";
            when 7=>row<=not "00000001";
            when others=>row<=not "00000000";
        end case;
        if rowCounter<7 then
            rowCounter<=rowCounter+1;
        else
            rowCounter<=0;
        end if;
      end if;
    end process display;
end architecture ;