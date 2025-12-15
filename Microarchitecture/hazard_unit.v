module hazard_unit (
    output reg stallF, stallD, flushD, flushE,
    output reg [1:0] ForwardAE, ForwardBE,
    input [4:0] RS1D, RS2D, RS1E, RS2E, RDE, RDM, RDW,
    input PCSrcE, ResultSrcE,
    input RegWriteM, RegWriteW
);

    reg lwStall;

    always @(*) begin
        // defaults
        ForwardAE = 2'b00;
        ForwardBE = 2'b00;
        stallF    = 1'b0;
        stallD    = 1'b0;
        flushD    = 1'b0;
        flushE    = 1'b0;
        lwStall   = 1'b0;

        // forwarding to EX stage operands
        if ((RS1E == RDM) && RegWriteM && (RS1E != 5'b0))
            ForwardAE = 2'b10;
        else if ((RS1E == RDW) && RegWriteW && (RS1E != 5'b0))
            ForwardAE = 2'b01;

        if ((RS2E == RDM) && RegWriteM && (RS2E != 5'b0))
            ForwardBE = 2'b10;
        else if ((RS2E == RDW) && RegWriteW && (RS2E != 5'b0))
            ForwardBE = 2'b01;

        // load-use stall detection
        lwStall = ResultSrcE && ((RS1D == RDE) || (RS2D == RDE));

        // stalls
        stallF = lwStall;
        stallD = lwStall;

        // flushes
        flushD = PCSrcE;
        flushE = lwStall | PCSrcE;
    end

endmodule 