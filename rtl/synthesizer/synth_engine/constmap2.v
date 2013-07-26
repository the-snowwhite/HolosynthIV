module constmap2
(
    // Input Ports
    input [8:0]sound,
	input clk,
    // Output Ports
    output [23:0]constant
);
`define _271MhzOscs // if not defined defaults to 180 Mhz oscilator clock

`ifdef _271MhzOscs
constmaprom271	constmaprom_inst (
	.address ( sound[7:0] ),
	.clock ( clk ),
	.q ( constant )
	);
`else
constmaprom	constmaprom_inst (
	.address ( sound[7:0] ),
	.clock ( clk ),
	.q ( constant )
	);
`endif

/*
assign constant = pmconstant[23:0];
wire [27:0]pmconstant;
// A function must declare one or more input arguments.  It must also
// execute in a single simulation cycle; therefore, it cannot contain
// timing controls or tasks.  You set the return value of a 
// function by assigning to the function name as if it were a variable.

function  note(input [9:0]data,input [3:0]snote);
    // Optional Block Item Declarations, e.g. Local Variables
    integer i,found;
        begin
        for(i=0,found=0;i<=20;i=i+1)begin
            note = 0;
            if(data == ((i*12)+snote))begin
                found = found +1;
            end
            if (found > 0) note = 1;
        end
    end
endfunction

wire E = note(sound,0);
wire F = note(sound,1);
wire Fh = note(sound,2);
wire G = note(sound,3);
wire Gh = note(sound,4);
wire A = note(sound,5);
wire Ah = note(sound,6);
wire B = note(sound,7);
wire C = note(sound,8);
wire Ch = note(sound,9);
wire D = note(sound,10);
wire Dh = note(sound,11);

wire [12:0] lconstant;
    assign lconstant=(    //channel-1 frequency
        (E)?  2608 :(
        (F)?  2763 :(
        (Fh)? 2927 :(
        (G)?  3101 :(
        (Gh)? 3286 :(
        (A)?  3481 :(
        (Ah)? 3688 :(
        (B)?  3908 :(
        (C)?  4140 :(
        (Ch)? 4386 :(
        (D)?  4647 :(
        (Dh)? 4923 :1
        )))))))))))
    );
wire [3:0] octup;       
    assign octup=(
    (sound < 12)  ? 10 :(
    (sound < 24)  ? 9 :(
    (sound < 36)  ? 8 :(
    (sound < 48)  ? 7 :(
    (sound < 60)  ? 6 :(
    (sound < 72)  ? 5 :(
    (sound < 84)  ? 4 :(
    (sound < 96)  ? 3 :(
    (sound < 108) ? 2 :(
    (sound < 120) ? 1 :(
    (sound < 132) ? 0 :(
    (sound < 144) ? 1 :(
    (sound < 156) ? 2 :(
    (sound < 168) ? 3 :(
    (sound < 180) ? 4 :(
    (sound < 192) ? 5 :(
    (sound < 204) ? 6 :(
    (sound < 216) ? 7 :(
    (sound < 228) ? 8 :(
    (sound < 240) ? 9 :(
    (sound < 252) ? 10 :(
    (sound < 264) ? 11 :(
    (sound < 278) ? 12 :(
    (sound < 290) ? 13 :(
    (sound < 302) ? 14 :(
    (sound < 314) ? 15 :16
    )))))))))))))))))))))))))
    );
assign  pmconstant = (sound > 119) ? (lconstant << octup) : (lconstant >> octup);
*/
endmodule
