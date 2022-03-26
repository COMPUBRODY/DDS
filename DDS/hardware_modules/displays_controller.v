//module displays_controller (seg0,seg1,seg2,seg3,num );
module displays_controller (
										clock,
										seg0,
										seg1,
										seg2,
										seg3,
										seg4,
										seg5,
										num );
//input	[15:0]	num;

input clock;
input	[23:0]	num;

//output	[6:0]	seg0,seg1,seg2,seg3;
output	[6:0]	seg0,seg1,seg2,seg3,seg4,seg5;

display_7seg	u0	(	seg0,num[3:0]		);
display_7seg	u1	(	seg1,num[7:4]		);
display_7seg	u2	(	seg2,num[11:8]	);
display_7seg 	u3	(	seg3,num[15:12]	);
display_7seg	u4	(	seg4,num[19:16]	);
display_7seg	u5	(	seg5,num[23:20]	);



endmodule
