`timescale 1ns / 1ps

module tzwrtcountry(
    input wire [7:0] country_id,
    output reg  signed [4:0] offset_hrs,
    output reg  signed [5:0] offset_min
    );
    always @(*) begin
            case(country_id)
                8'd1   : begin  offset_hrs =  -1;  offset_min =    0;  end  //Afghanistan                    IST-01:00   UTC+04:30
                8'd2   : begin  offset_hrs =  -4;  offset_min =  -30;  end  //Albania                        IST-04:30   UTC+01:00
                8'd3   : begin  offset_hrs =  -4;  offset_min =  -30;  end  //Algeria                        IST-04:30   UTC+01:00
                8'd4   : begin  offset_hrs =  -4;  offset_min =  -30;  end  //Andorra                        IST-04:30   UTC+01:00
                8'd5   : begin  offset_hrs =  -4;  offset_min =  -30;  end  //Angola                         IST-04:30   UTC+01:00
                8'd6   : begin  offset_hrs =   6;  offset_min =   30;  end  //Antarctica                     IST+06:30   UTC+12:00
                8'd7   : begin  offset_hrs =  -9;  offset_min =  -30;  end  //Antigua and Barbuda            IST-09:30   UTC-04:00
                8'd8   : begin  offset_hrs =  -8;  offset_min =  -30;  end  //Argentina                      IST-08:30   UTC-03:00
                8'd9   : begin  offset_hrs =  -1;  offset_min =  -30;  end  //Armenia                        IST-01:30   UTC+04:00
                8'd10  : begin  offset_hrs =   4;  offset_min =   30;  end  //Australia                      IST+04:30   UTC+10:00
                8'd11  : begin  offset_hrs =  -4;  offset_min =  -30;  end  //Austria                        IST-04:30   UTC+01:00
                8'd12  : begin  offset_hrs =  -1;  offset_min =  -30;  end  //Azerbaijan                     IST-01:30   UTC+04:00
                8'd13  : begin  offset_hrs = -10;  offset_min =  -30;  end  //Bahamas                        IST-10:30   UTC-05:00
                8'd14  : begin  offset_hrs =  -2;  offset_min =  -30;  end  //Bahrain                        IST-02:30   UTC+03:00
                8'd15  : begin  offset_hrs =   0;  offset_min =   30;  end  //Bangladesh                     IST+00:30   UTC+06:00
                8'd16  : begin  offset_hrs =  -9;  offset_min =  -30;  end  //Barbados                       IST-09:30   UTC-04:00
                8'd17  : begin  offset_hrs =  -2;  offset_min =  -30;  end  //Belarus                        IST-02:30   UTC+03:00
                8'd18  : begin  offset_hrs =  -4;  offset_min =  -30;  end  //Belgium                        IST-04:30   UTC+01:00
                8'd19  : begin  offset_hrs = -11;  offset_min =  -30;  end  //Belize                         IST-11:30   UTC-06:00
                8'd20  : begin  offset_hrs =  -4;  offset_min =  -30;  end  //Benin                          IST-04:30   UTC+01:00
                8'd21  : begin  offset_hrs =   0;  offset_min =   30;  end  //Bhutan                         IST+00:30   UTC+06:00
                8'd22  : begin  offset_hrs =  -9;  offset_min =  -30;  end  //Bolivia                        IST-09:30   UTC-04:00
                8'd23  : begin  offset_hrs =  -4;  offset_min =  -30;  end  //Bosnia and Herzegovina         IST-04:30   UTC+01:00
                8'd24  : begin  offset_hrs =  -3;  offset_min =  -30;  end  //Botswana                       IST-03:30   UTC+02:00
                8'd25  : begin  offset_hrs =  -8;  offset_min =  -30;  end  //Brazil                         IST-08:30   UTC-03:00
                8'd26  : begin  offset_hrs =   2;  offset_min =   30;  end  //Brunei                         IST+02:30   UTC+08:00
                8'd27  : begin  offset_hrs =  -3;  offset_min =  -30;  end  //Bulgaria                       IST-03:30   UTC+02:00
                8'd28  : begin  offset_hrs =  -5;  offset_min =  -30;  end  //Burkina Faso                   IST-05:30   UTC+00:00
                8'd29  : begin  offset_hrs =  -3;  offset_min =  -30;  end  //Burundi                        IST-03:30   UTC+02:00
                8'd30  : begin  offset_hrs =   1;  offset_min =   30;  end  //Cambodia                       IST+01:30   UTC+07:00
                8'd31  : begin  offset_hrs =  -4;  offset_min =  -30;  end  //Cameroon                       IST-04:30   UTC+01:00
                8'd32  : begin  offset_hrs = -10;  offset_min =  -30;  end  //Canada                         IST-10:30   UTC-05:00
                8'd33  : begin  offset_hrs =  -6;  offset_min =  -30;  end  //Cape Verde                     IST-06:30   UTC-01:00
                8'd34  : begin  offset_hrs =  -4;  offset_min =  -30;  end  //Central African Republic       IST-04:30   UTC+01:00
                8'd35  : begin  offset_hrs =  -4;  offset_min =  -30;  end  //Chad                           IST-04:30   UTC+01:00
                8'd36  : begin  offset_hrs =  -9;  offset_min =  -30;  end  //Chile                          IST-09:30   UTC-04:00
                8'd37  : begin  offset_hrs =   2;  offset_min =   30;  end  //China                          IST+02:30   UTC+08:00
                8'd38  : begin  offset_hrs = -10;  offset_min =  -30;  end  //Colombia                       IST-10:30   UTC-05:00
                8'd39  : begin  offset_hrs =  -2;  offset_min =  -30;  end  //Comoros                        IST-02:30   UTC+03:00
                8'd40  : begin  offset_hrs =  -4;  offset_min =  -30;  end  //Congo (Republic)               IST-04:30   UTC+01:00
                8'd41  : begin  offset_hrs = -11;  offset_min =  -30;  end  //Costa Rica                     IST-11:30   UTC-06:00
                8'd42  : begin  offset_hrs =  -4;  offset_min =  -30;  end  //Croatia                        IST-04:30   UTC+01:00
                8'd43  : begin  offset_hrs = -10;  offset_min =  -30;  end  //Cuba                           IST-10:30   UTC-05:00
                8'd44  : begin  offset_hrs =  -3;  offset_min =  -30;  end  //Cyprus                         IST-03:30   UTC+02:00
                8'd45  : begin  offset_hrs =  -4;  offset_min =  -30;  end  //Czech Republic                 IST-04:30   UTC+01:00
                8'd46  : begin  offset_hrs =  -4;  offset_min =  -30;  end  //Denmark                        IST-04:30   UTC+01:00
                8'd47  : begin  offset_hrs =  -2;  offset_min =  -30;  end  //Djibouti                       IST-02:30   UTC+03:00
                8'd48  : begin  offset_hrs =  -9;  offset_min =  -30;  end  //Dominica                       IST-09:30   UTC-04:00
                8'd49  : begin  offset_hrs =  -9;  offset_min =  -30;  end  //Dominican Republic             IST-09:30   UTC-04:00
                8'd50  : begin  offset_hrs = -10;  offset_min =  -30;  end  //Ecuador                        IST-10:30   UTC-05:00
                8'd51  : begin  offset_hrs =  -3;  offset_min =  -30;  end  //Egypt                          IST-03:30   UTC+02:00
                8'd52  : begin  offset_hrs = -11;  offset_min =  -30;  end  //El Salvador                    IST-11:30   UTC-06:00
                8'd53  : begin  offset_hrs =  -4;  offset_min =  -30;  end  //Equatorial Guinea              IST-04:30   UTC+01:00
                8'd54  : begin  offset_hrs =  -2;  offset_min =  -30;  end  //Eritrea                        IST-02:30   UTC+03:00
                8'd55  : begin  offset_hrs =  -3;  offset_min =  -30;  end  //Estonia                        IST-03:30   UTC+02:00
                8'd56  : begin  offset_hrs =  -3;  offset_min =  -30;  end  //Eswatini                       IST-03:30   UTC+02:00
                8'd57  : begin  offset_hrs =  -2;  offset_min =  -30;  end  //Ethiopia                       IST-02:30   UTC+03:00
                8'd58  : begin  offset_hrs =   6;  offset_min =   30;  end  //Fiji                           IST+06:30   UTC+12:00
                8'd59  : begin  offset_hrs =  -3;  offset_min =  -30;  end  //Finland                        IST-03:30   UTC+02:00
                8'd60  : begin  offset_hrs =  -4;  offset_min =  -30;  end  //France                         IST-04:30   UTC+01:00
                8'd61  : begin  offset_hrs =  -4;  offset_min =  -30;  end  //Gabon                          IST-04:30   UTC+01:00
                8'd62  : begin  offset_hrs =  -5;  offset_min =  -30;  end  //Gambia                         IST-05:30   UTC+00:00
                8'd63  : begin  offset_hrs =  -1;  offset_min =  -30;  end  //Georgia                        IST-01:30   UTC+04:00
                8'd64  : begin  offset_hrs =  -4;  offset_min =  -30;  end  //Germany                        IST-04:30   UTC+01:00
                8'd65  : begin  offset_hrs =  -5;  offset_min =  -30;  end  //Ghana                          IST-05:30   UTC+00:00
                8'd66  : begin  offset_hrs =  -3;  offset_min =  -30;  end  //Greece                         IST-03:30   UTC+02:00
                8'd67  : begin  offset_hrs =  -9;  offset_min =  -30;  end  //Grenada                        IST-09:30   UTC-04:00
                8'd68  : begin  offset_hrs = -11;  offset_min =  -30;  end  //Guatemala                      IST-11:30   UTC-06:00
                8'd69  : begin  offset_hrs =  -5;  offset_min =  -30;  end  //Guinea                         IST-05:30   UTC+00:00
                8'd70  : begin  offset_hrs =  -5;  offset_min =  -30;  end  //Guinea-Bissau                  IST-05:30   UTC+00:00
                8'd71  : begin  offset_hrs =  -9;  offset_min =  -30;  end  //Guyana                         IST-09:30   UTC-04:00
                8'd72  : begin  offset_hrs = -10;  offset_min =  -30;  end  //Haiti                          IST-10:30   UTC-05:00
                8'd73  : begin  offset_hrs = -11;  offset_min =  -30;  end  //Honduras                       IST-11:30   UTC-06:00
                8'd74  : begin  offset_hrs =  -4;  offset_min =  -30;  end  //Hungary                        IST-04:30   UTC+01:00
                8'd75  : begin  offset_hrs =  -5;  offset_min =  -30;  end  //Iceland                        IST-05:30   UTC+00:00
                8'd76  : begin  offset_hrs =   0;  offset_min =    0;  end  //India                          IST+00:00   UTC+05:30
                8'd77  : begin  offset_hrs =   1;  offset_min =   30;  end  //Indonesia                      IST+01:30   UTC+07:00
                8'd78  : begin  offset_hrs =  -2;  offset_min =    0;  end  //Iran                           IST-02:00   UTC+03:30
                8'd79  : begin  offset_hrs =  -2;  offset_min =  -30;  end  //Iraq                           IST-02:30   UTC+03:00
                8'd80  : begin  offset_hrs =  -5;  offset_min =  -30;  end  //Ireland                        IST-05:30   UTC+00:00
                8'd81  : begin  offset_hrs =  -3;  offset_min =  -30;  end  //Israel                         IST-03:30   UTC+02:00
                8'd82  : begin  offset_hrs =  -4;  offset_min =  -30;  end  //Italy                          IST-04:30   UTC+01:00
                8'd83  : begin  offset_hrs =  -5;  offset_min =  -30;  end  //Ivory Coast                    IST-05:30   UTC+00:00
                8'd84  : begin  offset_hrs = -10;  offset_min =  -30;  end  //Jamaica                        IST-10:30   UTC-05:00
                8'd85  : begin  offset_hrs =   3;  offset_min =   30;  end  //Japan                          IST+03:30   UTC+09:00
                8'd86  : begin  offset_hrs =  -2;  offset_min =  -30;  end  //Jordan                         IST-02:30   UTC+03:00
                8'd87  : begin  offset_hrs =   0;  offset_min =  -30;  end  //Kazakhstan                     IST-00:30   UTC+05:00
                8'd88  : begin  offset_hrs =  -2;  offset_min =  -30;  end  //Kenya                          IST-02:30   UTC+03:00
                8'd89  : begin  offset_hrs =   8;  offset_min =   30;  end  //Kiribati                       IST+08:30   UTC+14:00
                8'd90  : begin  offset_hrs =  -4;  offset_min =  -30;  end  //Kosovo                         IST-04:30   UTC+01:00
                8'd91  : begin  offset_hrs =  -2;  offset_min =  -30;  end  //Kuwait                         IST-02:30   UTC+03:00
                8'd92  : begin  offset_hrs =   0;  offset_min =   30;  end  //Kyrgyzstan                     IST+00:30   UTC+06:00
                8'd93  : begin  offset_hrs =   1;  offset_min =   30;  end  //Laos                           IST+01:30   UTC+07:00
                8'd94  : begin  offset_hrs =  -3;  offset_min =  -30;  end  //Latvia                         IST-03:30   UTC+02:00
                8'd95  : begin  offset_hrs =  -3;  offset_min =  -30;  end  //Lebanon                        IST-03:30   UTC+02:00
                8'd96  : begin  offset_hrs =  -3;  offset_min =  -30;  end  //Lesotho                        IST-03:30   UTC+02:00
                8'd97  : begin  offset_hrs =  -5;  offset_min =  -30;  end  //Liberia                        IST-05:30   UTC+00:00
                8'd98  : begin  offset_hrs =  -3;  offset_min =  -30;  end  //Libya                          IST-03:30   UTC+02:00
                8'd99  : begin  offset_hrs =  -4;  offset_min =  -30;  end  //Liechtenstein                  IST-04:30   UTC+01:00
                8'd100 : begin  offset_hrs =  -3;  offset_min =  -30;  end  //Lithuania                      IST-03:30   UTC+02:00
                8'd101 : begin  offset_hrs =  -4;  offset_min =  -30;  end  //Luxembourg                     IST-04:30   UTC+01:00
                8'd102 : begin  offset_hrs =   2;  offset_min =   30;  end  //Macau                          IST+02:30   UTC+08:00
                8'd103 : begin  offset_hrs =  -2;  offset_min =  -30;  end  //Madagascar                     IST-02:30   UTC+03:00
                8'd104 : begin  offset_hrs =  -3;  offset_min =  -30;  end  //Malawi                         IST-03:30   UTC+02:00
                8'd105 : begin  offset_hrs =   2;  offset_min =   30;  end  //Malaysia                       IST+02:30   UTC+08:00
                8'd106 : begin  offset_hrs =   0;  offset_min =  -30;  end  //Maldives                       IST-00:30   UTC+05:00
                8'd107 : begin  offset_hrs =  -5;  offset_min =  -30;  end  //Mali                           IST-05:30   UTC+00:00
                8'd108 : begin  offset_hrs =  -4;  offset_min =  -30;  end  //Malta                          IST-04:30   UTC+01:00
                8'd109 : begin  offset_hrs =   6;  offset_min =   30;  end  //Marshall Islands               IST+06:30   UTC+12:00
                8'd110 : begin  offset_hrs =  -5;  offset_min =  -30;  end  //Mauritania                     IST-05:30   UTC+00:00
                8'd111 : begin  offset_hrs =  -1;  offset_min =  -30;  end  //Mauritius                      IST-01:30   UTC+04:00
                8'd112 : begin  offset_hrs = -11;  offset_min =  -30;  end  //Mexico                         IST-11:30   UTC-06:00
                8'd113 : begin  offset_hrs =   5;  offset_min =   30;  end  //Micronesia                     IST+05:30   UTC+11:00
                8'd114 : begin  offset_hrs =  -3;  offset_min =  -30;  end  //Moldova                        IST-03:30   UTC+02:00
                8'd115 : begin  offset_hrs =  -4;  offset_min =  -30;  end  //Monaco                         IST-04:30   UTC+01:00
                8'd116 : begin  offset_hrs =   2;  offset_min =   30;  end  //Mongolia                       IST+02:30   UTC+08:00
                8'd117 : begin  offset_hrs =  -4;  offset_min =  -30;  end  //Montenegro                     IST-04:30   UTC+01:00
                8'd118 : begin  offset_hrs =  -4;  offset_min =  -30;  end  //Morocco                        IST-04:30   UTC+01:00
                8'd119 : begin  offset_hrs =  -3;  offset_min =  -30;  end  //Mozambique                     IST-03:30   UTC+02:00
                8'd120 : begin  offset_hrs =   1;  offset_min =    0;  end  //Myanmar                        IST+01:00   UTC+06:30
                8'd121 : begin  offset_hrs =  -3;  offset_min =  -30;  end  //Namibia                        IST-03:30   UTC+02:00
                8'd122 : begin  offset_hrs =   6;  offset_min =   30;  end  //Nauru                          IST+06:30   UTC+12:00
                8'd123 : begin  offset_hrs =   0;  offset_min =   15;  end  //Nepal                          IST+00:15   UTC+05:45
                8'd124 : begin  offset_hrs =  -4;  offset_min =  -30;  end  //Netherlands                    IST-04:30   UTC+01:00
                8'd125 : begin  offset_hrs =   6;  offset_min =   30;  end  //New Zealand                    IST+06:30   UTC+12:00
                8'd126 : begin  offset_hrs = -11;  offset_min =  -30;  end  //Nicaragua                      IST-11:30   UTC-06:00
                8'd127 : begin  offset_hrs =  -4;  offset_min =  -30;  end  //Niger                          IST-04:30   UTC+01:00
                8'd128 : begin  offset_hrs =  -4;  offset_min =  -30;  end  //Nigeria                        IST-04:30   UTC+01:00
                8'd129 : begin  offset_hrs =   3;  offset_min =   30;  end  //North Korea                    IST+03:30   UTC+09:00
                8'd130 : begin  offset_hrs =  -4;  offset_min =  -30;  end  //North Macedonia                IST-04:30   UTC+01:00
                8'd131 : begin  offset_hrs =  -4;  offset_min =  -30;  end  //Norway                         IST-04:30   UTC+01:00
                8'd132 : begin  offset_hrs =  -1;  offset_min =  -30;  end  //Oman                           IST-01:30   UTC+04:00
                8'd133 : begin  offset_hrs =   0;  offset_min =  -30;  end  //Pakistan                       IST-00:30   UTC+05:00
                8'd134 : begin  offset_hrs =   3;  offset_min =   30;  end  //Palau                          IST+03:30   UTC+09:00
                8'd135 : begin  offset_hrs =  -3;  offset_min =  -30;  end  //Palestine                      IST-03:30   UTC+02:00
                8'd136 : begin  offset_hrs = -10;  offset_min =  -30;  end  //Panama                         IST-10:30   UTC-05:00
                8'd137 : begin  offset_hrs =   4;  offset_min =   30;  end  //Papua New Guinea               IST+04:30   UTC+10:00
                8'd138 : begin  offset_hrs =  -8;  offset_min =  -30;  end  //Paraguay                       IST-08:30   UTC-03:00
                8'd139 : begin  offset_hrs = -10;  offset_min =  -30;  end  //Peru                           IST-10:30   UTC-05:00
                8'd140 : begin  offset_hrs =   2;  offset_min =   30;  end  //Philippines                    IST+02:30   UTC+08:00
                8'd141 : begin  offset_hrs =  -4;  offset_min =  -30;  end  //Poland                         IST-04:30   UTC+01:00
                8'd142 : begin  offset_hrs =  -5;  offset_min =  -30;  end  //Portugal                       IST-05:30   UTC+00:00
                8'd143 : begin  offset_hrs =  -2;  offset_min =  -30;  end  //Qatar                          IST-02:30   UTC+03:00
                8'd144 : begin  offset_hrs =  -3;  offset_min =  -30;  end  //Romania                        IST-03:30   UTC+02:00
                8'd145 : begin  offset_hrs =  -2;  offset_min =  -30;  end  //Russia                         IST-02:30   UTC+03:00
                8'd146 : begin  offset_hrs =  -3;  offset_min =  -30;  end  //Rwanda                         IST-03:30   UTC+02:00
                8'd147 : begin  offset_hrs =  -9;  offset_min =  -30;  end  //Saint Kitts and Nevis          IST-09:30   UTC-04:00
                8'd148 : begin  offset_hrs =  -9;  offset_min =  -30;  end  //Saint Lucia                    IST-09:30   UTC-04:00
                8'd149 : begin  offset_hrs =  -9;  offset_min =  -30;  end  //Saint Vincent and Grenadines   IST-09:30   UTC-04:00
                8'd150 : begin  offset_hrs =   7;  offset_min =   30;  end  //Samoa                          IST+07:30   UTC+13:00
                8'd151 : begin  offset_hrs =  -4;  offset_min =  -30;  end  //San Marino                     IST-04:30   UTC+01:00
                8'd152 : begin  offset_hrs =  -5;  offset_min =  -30;  end  //Sao Tome and Principe          IST-05:30   UTC+00:00
                8'd153 : begin  offset_hrs =  -2;  offset_min =  -30;  end  //Saudi Arabia                   IST-02:30   UTC+03:00
                8'd154 : begin  offset_hrs =  -5;  offset_min =  -30;  end  //Senegal                        IST-05:30   UTC+00:00
                8'd155 : begin  offset_hrs =  -4;  offset_min =  -30;  end  //Serbia                         IST-04:30   UTC+01:00
                8'd156 : begin  offset_hrs =  -1;  offset_min =  -30;  end  //Seychelles                     IST-01:30   UTC+04:00
                8'd157 : begin  offset_hrs =  -5;  offset_min =  -30;  end  //Sierra Leone                   IST-05:30   UTC+00:00
                8'd158 : begin  offset_hrs =   2;  offset_min =   30;  end  //Singapore                      IST+02:30   UTC+08:00
                8'd159 : begin  offset_hrs =  -4;  offset_min =  -30;  end  //Slovakia                       IST-04:30   UTC+01:00
                8'd160 : begin  offset_hrs =  -4;  offset_min =  -30;  end  //Slovenia                       IST-04:30   UTC+01:00
                8'd161 : begin  offset_hrs =   5;  offset_min =   30;  end  //Solomon Islands                IST+05:30   UTC+11:00
                8'd162 : begin  offset_hrs =  -2;  offset_min =  -30;  end  //Somalia                        IST-02:30   UTC+03:00
                8'd163 : begin  offset_hrs =  -3;  offset_min =  -30;  end  //South Africa                   IST-03:30   UTC+02:00
                8'd164 : begin  offset_hrs =   3;  offset_min =   30;  end  //South Korea                    IST+03:30   UTC+09:00
                8'd165 : begin  offset_hrs =  -3;  offset_min =  -30;  end  //South Sudan                    IST-03:30   UTC+02:00
                8'd166 : begin  offset_hrs =  -4;  offset_min =  -30;  end  //Spain                          IST-04:30   UTC+01:00
                8'd167 : begin  offset_hrs =   0;  offset_min =    0;  end  //Sri Lanka                      IST+00:00   UTC+05:30
                8'd168 : begin  offset_hrs =  -3;  offset_min =  -30;  end  //Sudan                          IST-03:30   UTC+02:00
                8'd169 : begin  offset_hrs =  -8;  offset_min =  -30;  end  //Suriname                       IST-08:30   UTC-03:00
                8'd170 : begin  offset_hrs =  -4;  offset_min =  -30;  end  //Sweden                         IST-04:30   UTC+01:00
                8'd171 : begin  offset_hrs =  -4;  offset_min =  -30;  end  //Switzerland                    IST-04:30   UTC+01:00
                8'd172 : begin  offset_hrs =  -2;  offset_min =  -30;  end  //Syria                          IST-02:30   UTC+03:00
                8'd173 : begin  offset_hrs =   2;  offset_min =   30;  end  //Taiwan                         IST+02:30   UTC+08:00
                8'd174 : begin  offset_hrs =   0;  offset_min =  -30;  end  //Tajikistan                     IST-00:30   UTC+05:00
                8'd175 : begin  offset_hrs =  -2;  offset_min =  -30;  end  //Tanzania                       IST-02:30   UTC+03:00
                8'd176 : begin  offset_hrs =   1;  offset_min =   30;  end  //Thailand                       IST+01:30   UTC+07:00
                8'd177 : begin  offset_hrs =   3;  offset_min =   30;  end  //Timor-Leste                    IST+03:30   UTC+09:00
                8'd178 : begin  offset_hrs =  -5;  offset_min =  -30;  end  //Togo                           IST-05:30   UTC+00:00
                8'd179 : begin  offset_hrs =   7;  offset_min =   30;  end  //Tonga                          IST+07:30   UTC+13:00
                8'd180 : begin  offset_hrs =  -9;  offset_min =  -30;  end  //Trinidad and Tobago            IST-09:30   UTC-04:00
                8'd181 : begin  offset_hrs =  -4;  offset_min =  -30;  end  //Tunisia                        IST-04:30   UTC+01:00
                8'd182 : begin  offset_hrs =  -2;  offset_min =  -30;  end  //Turkey                         IST-02:30   UTC+03:00
                8'd183 : begin  offset_hrs =   0;  offset_min =  -30;  end  //Turkmenistan                   IST-00:30   UTC+05:00
                8'd184 : begin  offset_hrs =   6;  offset_min =   30;  end  //Tuvalu                         IST+06:30   UTC+12:00
                8'd185 : begin  offset_hrs =  -2;  offset_min =  -30;  end  //Uganda                         IST-02:30   UTC+03:00
                8'd186 : begin  offset_hrs =  -3;  offset_min =  -30;  end  //Ukraine                        IST-03:30   UTC+02:00
                8'd187 : begin  offset_hrs =  -1;  offset_min =  -30;  end  //United Arab Emirates           IST-01:30   UTC+04:00
                8'd188 : begin  offset_hrs =  -5;  offset_min =  -30;  end  //United Kingdom                 IST-05:30   UTC+00:00
                8'd189 : begin  offset_hrs = -10;  offset_min =  -30;  end  //United States                  IST-10:30   UTC-05:00
                8'd190 : begin  offset_hrs =  -8;  offset_min =  -30;  end  //Uruguay                        IST-08:30   UTC-03:00
                8'd191 : begin  offset_hrs =   0;  offset_min =  -30;  end  //Uzbekistan                     IST-00:30   UTC+05:00
                8'd192 : begin  offset_hrs =   5;  offset_min =   30;  end  //Vanuatu                        IST+05:30   UTC+11:00
                8'd193 : begin  offset_hrs =  -4;  offset_min =  -30;  end  //Vatican City                   IST-04:30   UTC+01:00
                8'd194 : begin  offset_hrs =  -9;  offset_min =  -30;  end  //Venezuela                      IST-09:30   UTC-04:00
                8'd195 : begin  offset_hrs =   1;  offset_min =   30;  end  //Vietnam                        IST+01:30   UTC+07:00
                8'd196 : begin  offset_hrs =  -2;  offset_min =  -30;  end  //Yemen                          IST-02:30   UTC+03:00
                8'd197 : begin  offset_hrs =  -3;  offset_min =  -30;  end  //Zambia                         IST-03:30   UTC+02:00
                8'd198 : begin  offset_hrs =  -3;  offset_min =  -30;  end  //Zimbabwe                       IST-03:30   UTC+02:00
                default: begin  offset_hrs =   0;  offset_min =    0;  end  //India
            endcase
    end
endmodule
