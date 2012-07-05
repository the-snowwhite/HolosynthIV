module pitch_control (
    input                iRST_N,
    input [V_WIDTH+E_WIDTH-1:0] xxxx,
    input [V_WIDTH-1:0]  cur_key_adr,
    input [7:0]          cur_key_val,
    input [13:0]         pitch_val,
    input                note_on,
    input [7:0]          data,
    input [6:0]          adr,
    input                write,
    input                osc_sel,
    input                com_sel,
    output [23:0]    osc_pitch_val
);

parameter VOICES = 8;
parameter V_OSC = 4;
parameter V_WIDTH = 3;
parameter O_WIDTH = 2;
parameter E_WIDTH = 3;


    reg           [7:0]rkey_val[VOICES-1:0];

    reg  signed   [7:0]osc_ct[V_OSC-1:0];
    reg  signed   [7:0]osc_ft[V_OSC-1:0];
    reg  signed   [7:0]b_ct[V_OSC-1:0];   // base pitch
    reg  signed   [7:0]b_ft[V_OSC-1:0];  // base tune
    reg  signed   [7:0]k_scale[V_OSC-1:0];

    reg  signed   [7:0]pb_range;
    wire [O_WIDTH-1:0] ox;
    wire [V_WIDTH-1:0] vx;


    integer v1,loop,o1,kloop;


    always @(negedge iRST_N or posedge note_on)begin
        if(!iRST_N)begin
            for (kloop=0;kloop<VOICES;kloop=kloop+1)begin
                rkey_val[kloop] <= 8'hff;
            end

        end
        else
            rkey_val[cur_key_adr] <= cur_key_val;
    end

    always@(negedge iRST_N or negedge write)begin
        if(!iRST_N) begin
            for (loop=0;loop<V_OSC;loop=loop+1)begin
                osc_ct[loop] <= 8'h40;
                osc_ft[loop] <= 8'h40;
                b_ct[loop] <= 8'h40;
                b_ft[loop] <= 8'h40;
                k_scale[loop] <= 8'h0;
            end
            pb_range <= 8'h03;
        end else begin
            if(osc_sel)begin
                for (o1=0;o1<V_OSC;o1=o1+1)begin
                    case (adr)
                        0 +(o1<<4): osc_ct[o1] <= data;
                        1 +(o1<<4): osc_ft[o1] <= data;
                        5 +(o1<<4): k_scale[o1] <= data;
                        8 +(o1<<4): b_ct[o1] <= data;
                        9 +(o1<<4): b_ft[o1] <= data;
                        default:;
                    endcase
                end
            end
            else if(com_sel) begin
                if(adr == 0) pb_range <= data;
            end
        end
    end

    wire [8:0]key = (b_ct[ox] <= 63) ?
        ((rkey_val[vx])-( 64 - b_ct[ox])+128) : ((rkey_val[vx])+(b_ct[ox][5:0])+128);

////////        Internals       ////////
    wire [23:0]ct_res;
    wire [23:0]pb_res;
    wire [23:0]ft_ct_res;
    wire [23:0]ft_pb_res;
    wire [23:0]key_scale;

    constmap constmap(.sound(key), .constant(ct_res));

    wire [8:0] ft_ct_key = (b_ft[ox] <= 63) ? (key-1) : (key+1);
    constmap ct_pb_pitchmap(.sound(ft_ct_key), .constant(ft_ct_res));
// Fine tune  //
        wire [29:0]ft_range_l = (ct_res-ft_ct_res)*(64 - b_ft[ox]);//b_ft(down)
    wire [29:0]ft_range_h = ((ft_ct_res - ct_res)*b_ft[ox][5:0]);// b_ft(up)

    wire [23:0]ft_pitch = (b_ft[ox] <= 63) ? (ct_res- (ft_range_l>>6)) //b_ft(down)
    : ((ct_res + (ft_range_h>>6)));//b_ft(up)

// Pitch bend  //
    wire [8:0] pitch_key = (pitch_val <= 14'h1fff) ? (key-pb_range) : (key+pb_range);
    constmap pitchmap_pb(.sound(pitch_key), .constant(pb_res));

    wire [8:0] pb_pitch_key = (pitch_val <= 14'h1fff) ? (key-(pb_range+1)) : (key+(pb_range+1));
    constmap ft_pb_pitchmap(.sound(pb_pitch_key), .constant(ft_pb_res));

    wire [36:0]pb_range_l = (ft_pitch-pb_res)*(14'h2000-pitch_val);//pb(down)
    wire [36:0]pb_range_h = ((pb_res - ft_pitch)*pitch_val[12:0]);//pb(up)

    wire [42:0]pb_ft_range_l = (b_ft[ox] <= 63) ? (pb_res - ft_pb_res)*(14'h2000-pitch_val)*(64-b_ft[ox])
    : (pb_res - ft_pb_res)*(14'h2000-pitch_val)*b_ft[ox][5:0];

    wire [42:0]pb_ft_range_h = (b_ft[ox] <= 63) ? ((ft_pb_res - pb_res)*pitch_val[12:0]*(64-b_ft[ox]))//pb_up b_ft(down)
    : ((ft_pb_res - pb_res)*pitch_val[12:0]*b_ft[ox][5:0]);// pb(up) b_ft(up)

    wire [23:0]pitch_ = (pitch_val <= 14'h1fff) ? (b_ft[ox] <= 63) ? (ft_pitch-(pb_range_l>>13)-(pb_ft_range_l>>19))//pb(down) b_ft(down)
    : (ft_pitch-(pb_range_l>>13)+(pb_ft_range_l>>19)) //pb(down) b_ft_(up)
    : (b_ft[ox] <= 63) ? (ft_pitch+(pb_range_h>>13)-(pb_ft_range_h>>19))//pb(up) b_ft(down)
    : (ft_pitch+(pb_range_h>>13)+(pb_ft_range_h>>19));// pb(up)



// keyboard rate scaling //
    wire [23:0]base_pitch_val;
    assign base_pitch_val = pitch_ + (k_scale[ox] << 4);

    wire [30:0]osc_res;
    wire [30:0]osc_res_l;
    wire [30:0]osc_res_h;
    wire [23:0]osc_transp_range_l;
    wire [23:0]osc_transp_range_h;
    wire [30:0]osc_transp_val_l;
    wire [30:0]osc_transp_val_h;
    wire [7:0]osc_ct_64;
//    reg [O_WIDTH+V_WIDTH-1:0]x;// not double size !
    assign ox = xxxx[O_WIDTH:1];
    assign vx = xxxx[V_WIDTH+O_WIDTH:O_WIDTH+1];
    reg signed [23:0]osc_index_val;

    assign osc_pitch_val =  (osc_ft[ox] <= 8'h40) ?
                    (osc_res - (osc_transp_val_l>>6)) :
                    (osc_res + (osc_transp_val_h>>6));

        assign osc_ct_64 = (osc_ct[ox] <= 8'd64) ?
            (64-osc_ct[ox]+1):(osc_ct[ox][5:0]+1);

    assign osc_res =  (osc_ct[ox] <= 8'd64) ?// M:C Ratio
        (base_pitch_val / (osc_ct_64)):
        (base_pitch_val * (osc_ct_64));

    assign osc_res_l =  (osc_ct[ox] <= 8'd64) ?// M:C Ratio
        (base_pitch_val / (osc_ct_64+1)):
        (base_pitch_val * (osc_ct_64-1));

    assign osc_res_h =  (osc_ct[ox] <= 8'd63) ?// M:C Ratio
        (base_pitch_val / ((osc_ct_64)-1)):
        (base_pitch_val * (osc_ct_64+1));

    assign osc_transp_range_l = osc_res - osc_res_l;
    assign osc_transp_range_h = osc_res_h - osc_res;
    assign osc_transp_val_l = (64 - osc_ft[ox]) * osc_transp_range_l;  //
    assign osc_transp_val_h = (osc_ft[ox][5:0]) * osc_transp_range_h;    //

endmodule
