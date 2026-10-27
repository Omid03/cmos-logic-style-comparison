32 nm CMOS logic comparison: mux_static
**********************************Libs**********************************
.inc	'../models/32nm_bulk.txt'	32n
*********************************Inverter*******************************
.SUBCKT	INV	in	out
M1	out	in	0	0	nmos	L=Lmin	W=Wnmos
M2	out	in	Vdin	Vdin	pmos	L=Lmin	W=Wpmos
Vsupply	Vdin	0	vd
.ENDS INV
*********************************MUX2:1*********************************
X1	A	A_bar	INV
X2	B	B_bar	INV
X3	S	S_bar	INV
*******************PMOS*******************
M1	N1	S_bar	vdd	vdd	pmos	L=Lmin	W=Wpmos
M2	N2	S		vdd	vdd	pmos	L=Lmin	W=Wpmos
M3	out	A_bar	N1	vdd	pmos	L=Lmin	W=Wpmos
M4	out	B_bar	N2	vdd	pmos	L=Lmin	W=Wpmos
*******************NMOS*******************
M5	out	B_bar	N3	gnd	nmos	L=Lmin	W=Wnmos
M6	out	S		N3	gnd	nmos	L=Lmin	W=Wnmos
M7	N3	A_bar	gnd	gnd	nmos	L=Lmin	W=Wnmos
M8	N3	S_bar	gnd	gnd	nmos	L=Lmin	W=Wnmos
*********************************INPUTS*********************************
Vg	gnd 0   0V
Vs	vdd 0   vd
VA	A	0	PWL	0n	0,	60n	0, 	'60n+t'	vd,	120n	vd
VB	B	0	PWL	0n	vd,	60n	vd,	'60n+t'	0,	120n	0
Vss	S	0	PWL	0n	0,	20n	0,	'20n+t'	vd,	40n	vd,'40n+t'	0,	80n	0,	'80+t'	vd,	120	vd
*******************************PARAMETERS*******************************
.param  Lmin = 32n
+ Wmin = 32n
+ Wnmos = Wmin
+ Wpmos = '2*Wmin'
+ vd = 1V
+ t = 15p

*******************************SIMULATION*******************************
.op
.tran	    1p	    120n

.measure	tran	tpd1	    trig	        V(S)	    td=20n	    val='vd/2'	    cross=1
+targ	    V(out)	td=20n	    val='vd/2'	    cross=1

.measure	tran	out0avg		AVG		power	from='20n+t'	to=40n
.measure	tran	out0:1avg	AVG		power	from=40n		to='40n+t'
.measure	tran	out1:0avg	AVG		power	from=20n		to='20n+t'

.print	tran	V(out)
+V(S)
+V(A)
+V(B)

.end
