32 nm CMOS logic comparison: xor_dcvsl
**********************************Libs**********************************
.inc	'../models/32nm_bulk.txt'	32n
*********************************Inverter*******************************
.SUBCKT	INV	in	out
M1	out	in	0	0	nmos	L=Lmin	W=Wpmos
M2	out	in	Vdin	Vdin	pmos	L=Lmin	W=Wpmos
Vsupply	Vdin	0	vd
.ENDS INV
*******************************XOR/XNOR*********************************
X1	A	A_bar	INV
X2	B	B_bar	INV
*******************PMOS*******************
M1	out		out_bar	vdd		vdd		pmos	L=Lmin	W=Wpmos
M2	out_bar	out		vdd		vdd		pmos	L=Lmin	W=Wpmos
*******************NMOS*******************
M3	out		B		N1		gnd		nmos	L=Lmin	W=Wnmos
M4	out_bar	B_bar	N1		gnd		nmos	L=Lmin	W=Wnmos
M5	out_bar	B		N2		gnd		nmos	L=Lmin	W=Wnmos
M6	out		B_bar	N2		gnd		nmos	L=Lmin	W=Wnmos
M7	N1		A		gnd		gnd		nmos	L=Lmin	W=Wnmos
M8	N2		A_bar	gnd		gnd		nmos	L=Lmin	W=Wnmos
*********************************INPUTS*********************************
Vg	gnd 0   0V
Vs	vdd 0   vd
VA	A	0	PWL	0n	0,	20n	0, 	'20n+t'	vd,	40n		vd,	'40n+t'	0,	60n	0,	'60n+t'	vd, 80n	vd
VB	B	0	PWL	0n	vd,	40n	vd,	'40n+t'	0,	80n		0
*******************************PARAMETERS*******************************
.param  Lmin = 32n
+ Wmin = 32n
+ Wnmos = Wmin
+ Wpmos = '2*Wmin'
+ vd = 1V
+ t = 15p
*******************************SIMULATION*******************************
.op
.tran	    1p	    80n

.measure	tran	tpd		    trig	        V(A)	    td=20n	    val='vd/2'	    cross=1
+targ	    V(out)	td=20n	    val='vd/2'	    cross=1

.measure	tran	out0avg		AVG		power	from=0			to=20n
.measure	tran	out0:1avg	AVG		power	from=20n		to='20n+t'
.measure	tran	out1:0avg	AVG		power	from=60n		to='60n+t'

.print	tran	V(out)
+V(out_bar)
+V(A)
+V(B)

.end