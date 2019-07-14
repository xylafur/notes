entity full_adder is
generic(
    num_bits    :   integer := 2;
);
port(
    A           :   in  std_logic_vector(num_bits - 1 downto 0);
    B           :   in  std_logic_vector(num_bits - 1 downto 0);

    SUM         :   out std_logic_vector(num_bits - 1 downto 0);
    CARRY       :   out std_logic;
);
end full_adder;


architecture behavior of full_adder is
    signal s1   :   std_logic;
    signal c1   :   std_logic;
    signal c2   :   std_logic;
begin
    process(A, B)
    begin
        c1 <= A(0) XOR B(0);
        s1 <= A(0) AND B(0);

        c2 <= s1 XOR A(1) XOR B(1);

        SUM  <= A(1) AND B(1) OR A(1) AND c1 OR B(1) AND c1;
        CARRY <= c1 or c2;
    end process:

end behavior;
