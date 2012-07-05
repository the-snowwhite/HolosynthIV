module synth_clk_gen (
input 		iRST_N,
input 		OSC_CLK,  		//  180.555556 MHz
input 		AUDIO_CLK,		//  16.964286  MHz
output reg  LRCK_1X,
output reg  sCLK_XVXOSC,
output reg  sCLK_XVXENVS,
output reg  oAUD_BCK
);
parameter   VOICES 			= 8;
parameter   V_OSC 			= 4; // oscs per Voice
parameter   V_ENVS 			= 2*V_OSC;
parameter 	SYNTH_CHANNELS = 1;
//parameter   OSC_CLK_RATE       =   271428571;  //  271.428571 MHz
//parameter   OSC_CLK_RATE       =   180633600;  //  180.633600 MHz
parameter   OSC_CLK_RATE       =   180555556;  //  180.555556 MHz
//parameter   AUDIO_REF_CLK         =   16964286;   //  16.964286   MHz
parameter   AUDIO_REF_CLK         =   16927083;   //  16.927083   MHz
//parameter   AUDIO_REF_CLK         =   11284722;   //  11.284722   MHz
parameter   SAMPLE_RATE     =   44080;      //  44.1      KHz
parameter   DATA_WIDTH      =   16;         //  16      Bits
parameter   CHANNEL_NUM     =   2;          //  Dual Channel
//parameter   CHANNEL_NUM     =   1;          //  Mono

parameter XVOSC_DIV = OSC_CLK_RATE/((SAMPLE_RATE*SYNTH_CHANNELS*VOICES*V_OSC*2)-1);
parameter XVXENVS_DIV = OSC_CLK_RATE/((SAMPLE_RATE*SYNTH_CHANNELS*VOICES*V_ENVS*2)-1);
parameter LRCK_DIV = AUDIO_REF_CLK/((SAMPLE_RATE*2)-1);
parameter BCK_DIV_FAC = AUDIO_REF_CLK/((SAMPLE_RATE*DATA_WIDTH*CHANNEL_NUM*2)-1);

//  Internal Registers and Wires
reg     [8:0]   BCK_DIV;
reg     [12:0]  LRCK_1X_DIV;
//reg       [10:0]  LRCK_8X_DIV;
reg     [11:0]   sCLK_XVXOSC_DIV;
reg     [10:0]   sCLK_XVXENVS_DIV;


////////////////////////////////////
always@(posedge AUDIO_CLK or negedge iRST_N)
begin
    if(!iRST_N)
    begin
        LRCK_1X_DIV     <=  0;
        LRCK_1X     <=  0;
        BCK_DIV     <=  0;
        oAUD_BCK    <=  0;
    end
    else
    begin
////////////    AUD_LRCK Generator  //////////////
        //  LRCK 1X
        if(LRCK_1X_DIV >= LRCK_DIV )
        begin
            LRCK_1X_DIV <=  1;
            LRCK_1X <=  ~LRCK_1X;
        end
        else
        LRCK_1X_DIV     <=  LRCK_1X_DIV+1;
 /////////// AUD_BCK Generator   //////////////
       //  AUD_BCK
        if(BCK_DIV >= BCK_DIV_FAC )
        begin
            BCK_DIV     <=  1;
            oAUD_BCK    <=  ~oAUD_BCK;
        end
        else
        BCK_DIV     <=  BCK_DIV+1;
    end
end
//////////////////////////////////////////////////
always@(negedge OSC_CLK or negedge iRST_N)
begin
    if(!iRST_N)
    begin
        sCLK_XVXOSC_DIV     <=  0;
        sCLK_XVXENVS_DIV    <=  0;
        sCLK_XVXOSC <=  0;
        sCLK_XVXENVS    <=  0;
    end
    else
    begin
        if(sCLK_XVXOSC_DIV >= XVOSC_DIV)
        begin
            sCLK_XVXOSC_DIV <=  1;
            sCLK_XVXOSC <=  ~sCLK_XVXOSC;
        end
        else
        sCLK_XVXOSC_DIV     <=  sCLK_XVXOSC_DIV+1;
        
        if(sCLK_XVXENVS_DIV >= XVXENVS_DIV)
        begin
            sCLK_XVXENVS_DIV    <=  1;
            sCLK_XVXENVS    <=  ~sCLK_XVXENVS;
        end
        else
        sCLK_XVXENVS_DIV        <=  sCLK_XVXENVS_DIV+1; 
    end 
end

endmodule
