class scoreboard;
    mailbox scb_mbx;
    reg_item refq[256];

    task run();
        forever begin
            reg_item item;
            scb_mbx.get(item);
            item.print("Scoreboard");

            if (item.wr) begin
                if (refq[item.addr] == null)
                    refq[item.addr] = new;

                refq[item.addr] = item;
                $display("T=%0t [Scoreboard] Store addr=0x%0h wr=0x%0h data=0x%0h",
                         $time, item.addr, item.wr, item.data);
            end

            if (!item.wr) begin
                if (refq[item.addr] == null)
                    if (item.rdata != 'h1234)
                        $display("T=%0t [Scoreboard] ERROR! First Time Read, addr=0x%0h wr=0x%0h data=0x%0h",
                                 $time, item.addr, item.wr, item.data);
                    else
                        $display("T=%0t [Scoreboard] PASS! First Time Read, addr=0x%0h wr=0x%0h data=0x%0h",
                                 $time, item.addr, item.wr, item.data);
                else
                    if (item.rdata != refq[item.addr].wdata)
                        $display("T=%0t [Scoreboard] ERROR! addr=0x%0h wr=0x%0h data=0x%0h",
                                 $time, item.addr, item.wr, item.data);
                    else
                        $display("T=%0t [Scoreboard] PASS! addr=0x%0h wr=0x%0h data=0x%0h",
                                 $time, item.addr, item.wr, item.data);
            end
        end
    endtask
endclass
