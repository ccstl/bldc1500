   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.8.32 - 23 Mar 2010
   3                     ; Generator V4.3.4 - 23 Mar 2010
  15                     	bsct
  16  0000               _KLST:
  17  0000 00            	dc.b	0
  18  0001               _KSTB:
  19  0001 00            	dc.b	0
  20  0002               _KSTBL:
  21  0002 00            	dc.b	0
  22                     .const:	section	.text
  23  0000               _Tab_StepFan:
  24  0000 02            	dc.b	2
  25  0001 03            	dc.b	3
  26  0002 04            	dc.b	4
  27  0003 05            	dc.b	5
  28  0004 06            	dc.b	6
  29  0005 01            	dc.b	1
  30  0006               _Tab_StepZen:
  31  0006 06            	dc.b	6
  32  0007 01            	dc.b	1
  33  0008 02            	dc.b	2
  34  0009 03            	dc.b	3
  35  000a 04            	dc.b	4
  36  000b 05            	dc.b	5
  37                     	bsct
  38  0003               _DISP_TAB:
  39  0003 3f            	dc.b	63
  40  0004 06            	dc.b	6
  41  0005 5b            	dc.b	91
  42  0006 4f            	dc.b	79
  43  0007 66            	dc.b	102
  44  0008 6d            	dc.b	109
  45  0009 7d            	dc.b	125
  46  000a 07            	dc.b	7
  47  000b 7f            	dc.b	127
  48  000c 6f            	dc.b	111
  88                     ; 36 void Nop(uint8 T_Dly)
  88                     ; 37 {	
  90                     	switch	.text
  91  0000               _Nop:
  93  0000 88            	push	a
  94       00000000      OFST:	set	0
  97  0001               L13:
  98                     ; 38 	while(T_Dly--);		
 100  0001 7b01          	ld	a,(OFST+1,sp)
 101  0003 0a01          	dec	(OFST+1,sp)
 102  0005 4d            	tnz	a
 103  0006 26f9          	jrne	L13
 104                     ; 39 	return ;
 107  0008 84            	pop	a
 108  0009 81            	ret
 111                     	bsct
 112  000d               L53_BitNo:
 113  000d 00            	dc.b	0
 168                     ; 43 void DISP_Display(void)
 168                     ; 44 {
 169                     	switch	.text
 170  000a               _DISP_Display:
 172  000a 5203          	subw	sp,#3
 173       00000003      OFST:	set	3
 176                     ; 50 	GPIO_WriteLow(GPIOE,GPIO_PIN_5);
 178  000c 4b20          	push	#32
 179  000e ae5014        	ldw	x,#20500
 180  0011 cd0000        	call	_GPIO_WriteLow
 182  0014 84            	pop	a
 183                     ; 52 	data = DISP_TAB[BitNo];
 185  0015 b60d          	ld	a,L53_BitNo
 186  0017 5f            	clrw	x
 187  0018 97            	ld	xl,a
 188  0019 e603          	ld	a,(_DISP_TAB,x)
 189                     ; 53 	usPos = (0x01<<BitNo);
 191  001b ae0001        	ldw	x,#1
 192  001e b60d          	ld	a,L53_BitNo
 193  0020 4d            	tnz	a
 194  0021 2704          	jreq	L01
 195  0023               L21:
 196  0023 58            	sllw	x
 197  0024 4a            	dec	a
 198  0025 26fc          	jrne	L21
 199  0027               L01:
 200  0027 1f02          	ldw	(OFST-1,sp),x
 202  0029               L17:
 203                     ; 55 	while (SPI_GetFlagStatus(SPI_FLAG_TXE) == RESET);
 205  0029 a602          	ld	a,#2
 206  002b cd0000        	call	_SPI_GetFlagStatus
 208  002e 4d            	tnz	a
 209  002f 27f8          	jreq	L17
 210                     ; 56 	SPI_SendData(usPos);
 212  0031 7b03          	ld	a,(OFST+0,sp)
 213  0033 cd0000        	call	_SPI_SendData
 216  0036               L77:
 217                     ; 57 	while (SPI_GetFlagStatus(SPI_FLAG_TXE) == RESET);
 219  0036 a602          	ld	a,#2
 220  0038 cd0000        	call	_SPI_GetFlagStatus
 222  003b 4d            	tnz	a
 223  003c 27f8          	jreq	L77
 224                     ; 58 	SPI_SendData(0xFF);
 226  003e a6ff          	ld	a,#255
 227  0040 cd0000        	call	_SPI_SendData
 230  0043               L501:
 231                     ; 59 	while (SPI_GetFlagStatus(SPI_FLAG_TXE) == RESET);
 233  0043 a602          	ld	a,#2
 234  0045 cd0000        	call	_SPI_GetFlagStatus
 236  0048 4d            	tnz	a
 237  0049 27f8          	jreq	L501
 238                     ; 61 	GPIO_WriteHigh(GPIOE,GPIO_PIN_5);
 240  004b 4b20          	push	#32
 241  004d ae5014        	ldw	x,#20500
 242  0050 cd0000        	call	_GPIO_WriteHigh
 244  0053 84            	pop	a
 245                     ; 63 	BitNo++;
 247  0054 3c0d          	inc	L53_BitNo
 248                     ; 64 	if (BitNo > 3)
 250  0056 b60d          	ld	a,L53_BitNo
 251  0058 a104          	cp	a,#4
 252  005a 2502          	jrult	L111
 253                     ; 66 		BitNo = 0;
 255  005c 3f0d          	clr	L53_BitNo
 256  005e               L111:
 257                     ; 68 }
 260  005e 5b03          	addw	sp,#3
 261  0060 81            	ret
 284                     ; 73 void OffSixPin(void)
 284                     ; 74 {
 285                     	switch	.text
 286  0061               _OffSixPin:
 290                     ; 75 	CNT_AL_OUT_DIS();
 292  0061 72115005      	bres	20485,#0
 293                     ; 76 	CNT_BL_OUT_DIS();
 295  0065 72135005      	bres	20485,#1
 296                     ; 77 	CNT_CL_OUT_DIS();
 298  0069 72155005      	bres	20485,#2
 299                     ; 78 	PWM_AH_OUT_DIS();
 301  006d 7211525c      	bres	21084,#0
 302                     ; 79 	PWM_BH_OUT_DIS();
 304  0071 7219525c      	bres	21084,#4
 305                     ; 80 	PWM_CH_OUT_DIS();
 307  0075 7211525d      	bres	21085,#0
 308                     ; 82 }
 311  0079 81            	ret
 334                     ; 90 void BldcBak(void)
 334                     ; 91 {
 335                     	switch	.text
 336  007a               _BldcBak:
 340                     ; 92 	PWM_BH_OUT_DIS();
 342  007a 7219525c      	bres	21084,#4
 343                     ; 93 	PWM_BH_OUT_DIS();
 345  007e 7219525c      	bres	21084,#4
 346                     ; 94 	PWM_CH_OUT_DIS();
 348  0082 7211525d      	bres	21085,#0
 349                     ; 95 	CNT_AL_OUT_EN();
 351  0086 72105005      	bset	20485,#0
 352                     ; 96 	CNT_BL_OUT_EN();
 354  008a 72125005      	bset	20485,#1
 355                     ; 97 	CNT_CL_OUT_EN();									
 357  008e 72145005      	bset	20485,#2
 358                     ; 98 }
 361  0092 81            	ret
 395                     ; 101 void Timer1_CCR4_Value(uint16 InValue)
 395                     ; 102 {
 396                     	switch	.text
 397  0093               _Timer1_CCR4_Value:
 401                     ; 103 	ToCMPxH(TIM1->CCR4H,InValue);
 403  0093 9e            	ld	a,xh
 404  0094 c7526b        	ld	21099,a
 405                     ; 104 	ToCMPxL(TIM1->CCR4L,InValue);		
 407  0097 9f            	ld	a,xl
 408  0098 a4ff          	and	a,#255
 409  009a c7526c        	ld	21100,a
 410                     ; 105 }
 413  009d 81            	ret
 447                     ; 108 void Timer1_PWM_Value(uint16 OUT_PWM)
 447                     ; 109 {
 448                     	switch	.text
 449  009e               _Timer1_PWM_Value:
 451  009e 89            	pushw	x
 452       00000000      OFST:	set	0
 455                     ; 111 	ToCMPxH(TIM1->CCR1H,OUT_PWM);
 457  009f 9e            	ld	a,xh
 458  00a0 c75265        	ld	21093,a
 459                     ; 112 	ToCMPxL(TIM1->CCR1L,OUT_PWM);
 461  00a3 9f            	ld	a,xl
 462  00a4 a4ff          	and	a,#255
 463  00a6 c75266        	ld	21094,a
 464                     ; 113 	ToCMPxH(TIM1->CCR2H,OUT_PWM);
 466  00a9 7b01          	ld	a,(OFST+1,sp)
 467  00ab c75267        	ld	21095,a
 468                     ; 114 	ToCMPxL(TIM1->CCR2L,OUT_PWM);
 470  00ae 7b02          	ld	a,(OFST+2,sp)
 471  00b0 a4ff          	and	a,#255
 472  00b2 c75268        	ld	21096,a
 473                     ; 115 	ToCMPxH(TIM1->CCR3H,OUT_PWM);
 475  00b5 7b01          	ld	a,(OFST+1,sp)
 476  00b7 c75269        	ld	21097,a
 477                     ; 116 	ToCMPxL(TIM1->CCR3L,OUT_PWM);
 479  00ba 7b02          	ld	a,(OFST+2,sp)
 480  00bc a4ff          	and	a,#255
 481  00be c7526a        	ld	21098,a
 482                     ; 117 }
 485  00c1 85            	popw	x
 486  00c2 81            	ret
 513                     ; 122 void Key_Check(void)
 513                     ; 123 {
 514                     	switch	.text
 515  00c3               _Key_Check:
 519                     ; 124 	Direction = ZEN;
 521  00c3 35020014      	mov	_tBC_Param+19,#2
 522                     ; 126 	tBC_Param.R_Err = Error_code.all;
 524  00c7 450029        	mov	_tBC_Param+40,_Error_code
 525                     ; 129 	if (GPIOE->IDR & GPIO_PIN_1)
 527  00ca c65015        	ld	a,20501
 528  00cd a502          	bcp	a,#2
 529  00cf 2706          	jreq	L771
 530                     ; 131 		tBC_Param.ucCmdKey = 1;
 532  00d1 3501002a      	mov	_tBC_Param+41,#1
 534  00d5 2002          	jra	L102
 535  00d7               L771:
 536                     ; 135 		tBC_Param.ucCmdKey = 0;
 538  00d7 3f2a          	clr	_tBC_Param+41
 539  00d9               L102:
 540                     ; 138 	if(tBC_Param.ucCmdKey != KSTB) 	//第一次按下
 542  00d9 b62a          	ld	a,_tBC_Param+41
 543  00db b101          	cp	a,_KSTB
 544  00dd 270f          	jreq	L302
 545                     ; 140 		if (KSTBL++>20)
 547  00df b602          	ld	a,_KSTBL
 548  00e1 3c02          	inc	_KSTBL
 549  00e3 a115          	cp	a,#21
 550  00e5 2509          	jrult	L702
 551                     ; 142 			KSTB = tBC_Param.ucCmdKey;
 553  00e7 452a01        	mov	_KSTB,_tBC_Param+41
 554                     ; 143 			KSTBL = 0;
 556  00ea 3f02          	clr	_KSTBL
 557  00ec 2002          	jra	L702
 558  00ee               L302:
 559                     ; 148 		KSTBL = 0;
 561  00ee 3f02          	clr	_KSTBL
 562  00f0               L702:
 563                     ; 151 	if ((KSTB == 1) && (tBC_Param.ucRunProtect == 0))  //开关按下
 565  00f0 b601          	ld	a,_KSTB
 566  00f2 a101          	cp	a,#1
 567  00f4 260a          	jrne	L112
 569  00f6 3d28          	tnz	_tBC_Param+39
 570  00f8 2606          	jrne	L112
 571                     ; 153 		tBC_Param.RunCmd = 1;
 573  00fa 35010015      	mov	_tBC_Param+20,#1
 575  00fe 2002          	jra	L312
 576  0100               L112:
 577                     ; 157 		tBC_Param.RunCmd = 0;
 579  0100 3f15          	clr	_tBC_Param+20
 580  0102               L312:
 581                     ; 160 	if (tBC_Param.ucRunProtect)
 583  0102 3d28          	tnz	_tBC_Param+39
 584  0104 2708          	jreq	L512
 585                     ; 162 		if (KSTB == 0)
 587  0106 3d01          	tnz	_KSTB
 588  0108 2610          	jrne	L122
 589                     ; 164 			tBC_Param.ucRunProtect = 0;
 591  010a 3f28          	clr	_tBC_Param+39
 592  010c 200c          	jra	L122
 593  010e               L512:
 594                     ; 169 		if ((KSTB) && (tBC_Param.R_Err))
 596  010e 3d01          	tnz	_KSTB
 597  0110 2708          	jreq	L122
 599  0112 3d29          	tnz	_tBC_Param+40
 600  0114 2704          	jreq	L122
 601                     ; 171 			tBC_Param.ucRunProtect = 1;
 603  0116 35010028      	mov	_tBC_Param+39,#1
 604  011a               L122:
 605                     ; 174 }
 608  011a 81            	ret
 632                     ; 176 void SpeedRefAccDec(void)
 632                     ; 177 {
 633                     	switch	.text
 634  011b               _SpeedRefAccDec:
 638                     ; 178 	tBC_Param.R_VRAD = 100;   // debug_winson
 640  011b ae0064        	ldw	x,#100
 641  011e bf22          	ldw	_tBC_Param+33,x
 642                     ; 190 		R_SetPwm = tBC_Param.R_VRAD ;
 644  0120 ae0064        	ldw	x,#100
 645  0123 bf01          	ldw	_tBC_Param,x
 646                     ; 192 }
 649  0125 81            	ret
 674                     ; 198 void CmdPwmSlow(void)
 674                     ; 199 {
 675                     	switch	.text
 676  0126               _CmdPwmSlow:
 680                     ; 200 	if (BldcStatus > STATUS_START)
 682  0126 b609          	ld	a,_tBC_Param+8
 683  0128 a102          	cp	a,#2
 684  012a 2522          	jrult	L542
 685                     ; 202 		if (R_SetPwm == R_CurPwm) // tBC_Param.R_VRAD
 687  012c be01          	ldw	x,_tBC_Param
 688  012e b303          	cpw	x,_tBC_Param+2
 689  0130 2601          	jrne	L742
 690                     ; 204 			return ;
 693  0132 81            	ret
 694  0133               L742:
 695                     ; 206 		else if (R_SetPwm < R_CurPwm)
 697  0133 be01          	ldw	x,_tBC_Param
 698  0135 b303          	cpw	x,_tBC_Param+2
 699  0137 2409          	jruge	L352
 700                     ; 208 			R_CurPwm--;
 702  0139 be03          	ldw	x,_tBC_Param+2
 703  013b 1d0001        	subw	x,#1
 704  013e bf03          	ldw	_tBC_Param+2,x
 706  0140 2007          	jra	L152
 707  0142               L352:
 708                     ; 212 			R_CurPwm ++;
 710  0142 be03          	ldw	x,_tBC_Param+2
 711  0144 1c0001        	addw	x,#1
 712  0147 bf03          	ldw	_tBC_Param+2,x
 713  0149               L152:
 714                     ; 215 		Timer1_PWM_Value(R_CurPwm);
 716  0149 be03          	ldw	x,_tBC_Param+2
 717  014b cd009e        	call	_Timer1_PWM_Value
 719  014e               L542:
 720                     ; 217 }
 723  014e 81            	ret
 726                     	bsct
 727  000e               L752_usChargeCnt:
 728  000e 0000          	dc.w	0
 765                     ; 224 void Run_Ctl(void)
 765                     ; 225 {
 766                     	switch	.text
 767  014f               _Run_Ctl:
 771                     ; 228 	switch (tBC_Param.ucState)
 773  014f b627          	ld	a,_tBC_Param+38
 775                     ; 295 	default:
 775                     ; 296 		break;
 776  0151 4d            	tnz	a
 777  0152 270d          	jreq	L162
 778  0154 4a            	dec	a
 779  0155 274d          	jreq	L362
 780  0157 4a            	dec	a
 781  0158 2603          	jrne	L43
 782  015a cc0204        	jp	L562
 783  015d               L43:
 784  015d ac0a020a      	jpf	L113
 785  0161               L162:
 786                     ; 230 	case 0:
 786                     ; 231 		if (tBC_Param.RunCmd == 1)
 788  0161 b615          	ld	a,_tBC_Param+20
 789  0163 a101          	cp	a,#1
 790  0165 2616          	jrne	L313
 791                     ; 233 			tBC_Param.R_Mode = MODE_ON;
 793  0167 35010026      	mov	_tBC_Param+37,#1
 794                     ; 234 			PWM_OUT_EN();
 796  016b 72155014      	bres	20500,#2
 797                     ; 235 			TEST1_ON();
 799  016f 7219500f      	bres	20495,#4
 800                     ; 236 			tBC_Param.ucState = 1;
 802  0173 35010027      	mov	_tBC_Param+38,#1
 803                     ; 237 			usChargeCnt = 0;
 805  0177 5f            	clrw	x
 806  0178 bf0e          	ldw	L752_usChargeCnt,x
 808  017a cc020a        	jra	L113
 809  017d               L313:
 810                     ; 241 			TIM1_BREAK_DIS();      // Break input (BKIN) disabled
 812  017d 7219526d      	bres	21101,#4
 813                     ; 242 			TIM1_BREAK_IER_DIS();
 815  0181 721f5254      	bres	21076,#7
 816                     ; 243 			TIM1->BKR &= (uint8_t)(~TIM1_BKR_MOE);
 818  0185 721f526d      	bres	21101,#7
 819                     ; 244 			OffSixPin();
 821  0189 cd0061        	call	_OffSixPin
 823                     ; 245 			tBC_Param.R_Mode = MODE_OFF;
 825  018c 3f26          	clr	_tBC_Param+37
 826                     ; 246 			BldcStatus = STATUS_STOP;
 828  018e 3f09          	clr	_tBC_Param+8
 829                     ; 247 			TIM1_CMP4_IEN_DIS();   // CC4 interrupt disabled
 831  0190 72195254      	bres	21076,#4
 832                     ; 248 			Timer1_PWM_Value(0);
 834  0194 5f            	clrw	x
 835  0195 cd009e        	call	_Timer1_PWM_Value
 837                     ; 249 			PWM_OUT_DIS();
 839  0198 72145014      	bset	20500,#2
 840                     ; 250 			TEST1_OFF();
 842  019c 7218500f      	bset	20495,#4
 843                     ; 252 			Error_code.all = 0;  // debug_winson
 845  01a0 3f00          	clr	_Error_code
 846  01a2 2066          	jra	L113
 847  01a4               L362:
 848                     ; 256 	case 1:
 848                     ; 257 		if (usChargeCnt++ < 20)
 850  01a4 be0e          	ldw	x,L752_usChargeCnt
 851  01a6 1c0001        	addw	x,#1
 852  01a9 bf0e          	ldw	L752_usChargeCnt,x
 853  01ab 1d0001        	subw	x,#1
 854  01ae a30014        	cpw	x,#20
 855  01b1 240e          	jruge	L713
 856                     ; 259 			CNT_AL_OUT_EN();
 858  01b3 72105005      	bset	20485,#0
 859                     ; 260 			CNT_BL_OUT_EN();
 861  01b7 72125005      	bset	20485,#1
 862                     ; 261 			CNT_CL_OUT_EN();
 864  01bb 72145005      	bset	20485,#2
 866  01bf 2049          	jra	L113
 867  01c1               L713:
 868                     ; 265 			usChargeCnt = 0;
 870  01c1 5f            	clrw	x
 871  01c2 bf0e          	ldw	L752_usChargeCnt,x
 872                     ; 266 			CNT_AL_OUT_DIS();
 874  01c4 72115005      	bres	20485,#0
 875                     ; 267 			CNT_BL_OUT_DIS();
 877  01c8 72135005      	bres	20485,#1
 878                     ; 268 			CNT_CL_OUT_DIS();
 880  01cc 72155005      	bres	20485,#2
 881                     ; 270 			TIM1_BREAK_ENB();
 883  01d0 7218526d      	bset	21101,#4
 884                     ; 271 			TIM1->SR1 &= (u8)(~BIT7);
 886  01d4 721f5255      	bres	21077,#7
 887                     ; 272 			TIM1_BREAK_IER_ENB();
 889  01d8 721e5254      	bset	21076,#7
 890                     ; 273 			TIM1->BKR |= TIM1_BKR_MOE;
 892  01dc 721e526d      	bset	21101,#7
 893                     ; 274 			Timer1_CCR4_Value(1);
 895  01e0 ae0001        	ldw	x,#1
 896  01e3 cd0093        	call	_Timer1_CCR4_Value
 898                     ; 277 			R_CurPwm = V_PWMSTART;			//当前值					
 900  01e6 ae000f        	ldw	x,#15
 901  01e9 bf03          	ldw	_tBC_Param+2,x
 902                     ; 278 			R_SetPwm= V_PWMRUN_MIN ;		//设定值	
 904  01eb ae0014        	ldw	x,#20
 905  01ee bf01          	ldw	_tBC_Param,x
 906                     ; 279 			tBC_Param.StartStep = 0 ;//正常启动
 908  01f0 5f            	clrw	x
 909  01f1 bf12          	ldw	_tBC_Param+17,x
 910                     ; 280 			BldcStep = V_BLDC_DING ;
 912  01f3 3501000a      	mov	_tBC_Param+9,#1
 913                     ; 281 			T_Dly60C = 0;
 915  01f7 5f            	clrw	x
 916  01f8 bf05          	ldw	_tBC_Param+4,x
 917                     ; 282 			BldcStatus = STATUS_START ;  //启动
 919  01fa 35010009      	mov	_tBC_Param+8,#1
 920                     ; 284 			tBC_Param.ucState = 2;
 922  01fe 35020027      	mov	_tBC_Param+38,#2
 923  0202 2006          	jra	L113
 924  0204               L562:
 925                     ; 288 	case 2:
 925                     ; 289 		if (tBC_Param.RunCmd == 0)
 927  0204 3d15          	tnz	_tBC_Param+20
 928  0206 2602          	jrne	L113
 929                     ; 291 			tBC_Param.ucState = 0;
 931  0208 3f27          	clr	_tBC_Param+38
 932  020a               L762:
 933                     ; 295 	default:
 933                     ; 296 		break;
 935  020a               L113:
 936                     ; 298 }
 939  020a 81            	ret
 963                     ; 300 void Led_Light(void)
 963                     ; 301 {
 964                     	switch	.text
 965  020b               _Led_Light:
 969                     ; 302 	if (BldcStatus == STATUS_STOP)
 971  020b 3d09          	tnz	_tBC_Param+8
 972  020d 2606          	jrne	L533
 973                     ; 304 		LED_RUN_OFF();
 975  020f 7216500f      	bset	20495,#3
 977  0213 2004          	jra	L733
 978  0215               L533:
 979                     ; 308 		LED_RUN_ON();
 981  0215 7217500f      	bres	20495,#3
 982  0219               L733:
 983                     ; 311 	if (tBC_Param.R_Err)
 985  0219 3d29          	tnz	_tBC_Param+40
 986  021b 2706          	jreq	L143
 987                     ; 313 		LED_ERROR_ON();
 989  021d 7215500f      	bres	20495,#2
 991  0221 2004          	jra	L343
 992  0223               L143:
 993                     ; 317 		LED_ERROR_OFF();
 995  0223 7214500f      	bset	20495,#2
 996  0227               L343:
 997                     ; 319 }
1000  0227 81            	ret
1034                     ; 327 void AdcSwitch(uint8 Chanel)
1034                     ; 328 {
1035                     	switch	.text
1036  0228               _AdcSwitch:
1040                     ; 329 	ADC2->CSR = Chanel;	//选择转换通道	
1042  0228 c75400        	ld	21504,a
1043                     ; 330 	ADC2->CR1 |= 0x01 ;		// 启动ADC
1045  022b 72105401      	bset	21505,#0
1047  022f               L563:
1048                     ; 332 	while(!(ADC2->CSR & BIT7));	//等待转换
1050  022f c65400        	ld	a,21504
1051  0232 a580          	bcp	a,#128
1052  0234 27f9          	jreq	L563
1053                     ; 333 	ADC2->CSR &= 0x7f;
1055  0236 721f5400      	bres	21504,#7
1056                     ; 334 }
1059  023a 81            	ret
1095                     ; 338 void Check_BEMF_Voltage(void)
1095                     ; 339 {	
1096                     	switch	.text
1097  023b               _Check_BEMF_Voltage:
1099  023b 89            	pushw	x
1100       00000002      OFST:	set	2
1103                     ; 340 	uint16 Value=0 ;
1105                     ; 343 	switch(BldcStep)
1107  023c b60a          	ld	a,_tBC_Param+9
1109                     ; 365 			break ;
1110  023e 4a            	dec	a
1111  023f 2714          	jreq	L173
1112  0241 4a            	dec	a
1113  0242 2729          	jreq	L373
1114  0244 4a            	dec	a
1115  0245 273e          	jreq	L573
1116  0247 4a            	dec	a
1117  0248 270b          	jreq	L173
1118  024a 4a            	dec	a
1119  024b 2720          	jreq	L373
1120  024d 4a            	dec	a
1121  024e 2735          	jreq	L573
1122  0250               L773:
1123                     ; 363 		default : 
1123                     ; 364 			Value = 0 ;
1125  0250 5f            	clrw	x
1126  0251 1f01          	ldw	(OFST-1,sp),x
1127                     ; 365 			break ;
1129  0253 2046          	jra	L124
1130  0255               L173:
1131                     ; 345 		case 1 : //AB  取 读C点W
1131                     ; 346 		case 4 :
1131                     ; 347 			AdcSwitch(PHASE_C_BEMF_ADC_CHAN);
1133  0255 a603          	ld	a,#3
1134  0257 adcf          	call	_AdcSwitch
1136                     ; 348 			Value = ((uint16)ADC2->DRH<<2) + ADC2->DRL;
1138  0259 c65404        	ld	a,21508
1139  025c 5f            	clrw	x
1140  025d 97            	ld	xl,a
1141  025e 58            	sllw	x
1142  025f 58            	sllw	x
1143  0260 01            	rrwa	x,a
1144  0261 cb5405        	add	a,21509
1145  0264 2401          	jrnc	L44
1146  0266 5c            	incw	x
1147  0267               L44:
1148  0267 02            	rlwa	x,a
1149  0268 1f01          	ldw	(OFST-1,sp),x
1150  026a 01            	rrwa	x,a
1151                     ; 349 			break ;
1153  026b 202e          	jra	L124
1154  026d               L373:
1155                     ; 351 		case 2 : //AC 通  取B点 
1155                     ; 352 		case 5 :
1155                     ; 353 			AdcSwitch(PHASE_B_BEMF_ADC_CHAN);
1157  026d a604          	ld	a,#4
1158  026f adb7          	call	_AdcSwitch
1160                     ; 354 			Value = ((uint16)ADC2->DRH<<2) + ADC2->DRL;
1162  0271 c65404        	ld	a,21508
1163  0274 5f            	clrw	x
1164  0275 97            	ld	xl,a
1165  0276 58            	sllw	x
1166  0277 58            	sllw	x
1167  0278 01            	rrwa	x,a
1168  0279 cb5405        	add	a,21509
1169  027c 2401          	jrnc	L64
1170  027e 5c            	incw	x
1171  027f               L64:
1172  027f 02            	rlwa	x,a
1173  0280 1f01          	ldw	(OFST-1,sp),x
1174  0282 01            	rrwa	x,a
1175                     ; 355 			break ;	
1177  0283 2016          	jra	L124
1178  0285               L573:
1179                     ; 357 		case 3 : //BC  取 读A点 
1179                     ; 358 		case 6 :
1179                     ; 359 			AdcSwitch(PHASE_A_BEMF_ADC_CHAN);
1181  0285 a605          	ld	a,#5
1182  0287 ad9f          	call	_AdcSwitch
1184                     ; 360 			Value = ((uint16)ADC2->DRH<<2) + ADC2->DRL;
1186  0289 c65404        	ld	a,21508
1187  028c 5f            	clrw	x
1188  028d 97            	ld	xl,a
1189  028e 58            	sllw	x
1190  028f 58            	sllw	x
1191  0290 01            	rrwa	x,a
1192  0291 cb5405        	add	a,21509
1193  0294 2401          	jrnc	L05
1194  0296 5c            	incw	x
1195  0297               L05:
1196  0297 02            	rlwa	x,a
1197  0298 1f01          	ldw	(OFST-1,sp),x
1198  029a 01            	rrwa	x,a
1199                     ; 361 			break ;
1201  029b               L124:
1202                     ; 368 	VoCple = Value ;
1204  029b 1e01          	ldw	x,(OFST-1,sp)
1205  029d bf0e          	ldw	_tBC_Param+13,x
1206                     ; 370 	AdcSwitch(ADC_BUS_CHANNEL);// DC BUS 电压
1208  029f a608          	ld	a,#8
1209  02a1 ad85          	call	_AdcSwitch
1211                     ; 371 	tBC_Param.usAD_DCbus = ((uint16)ADC2->DRH<<2) + ADC2->DRL;
1213  02a3 c65404        	ld	a,21508
1214  02a6 5f            	clrw	x
1215  02a7 97            	ld	xl,a
1216  02a8 58            	sllw	x
1217  02a9 58            	sllw	x
1218  02aa 01            	rrwa	x,a
1219  02ab cb5405        	add	a,21509
1220  02ae 2401          	jrnc	L25
1221  02b0 5c            	incw	x
1222  02b1               L25:
1223  02b1 b71b          	ld	_tBC_Param+26,a
1224  02b3 9f            	ld	a,xl
1225  02b4 b71a          	ld	_tBC_Param+25,a
1226                     ; 372 	M_VoCple = tBC_Param.usAD_DCbus>>1;
1228  02b6 be1a          	ldw	x,_tBC_Param+25
1229  02b8 54            	srlw	x
1230  02b9 bf10          	ldw	_tBC_Param+15,x
1231                     ; 373 }
1234  02bb 85            	popw	x
1235  02bc 81            	ret
1272                     ; 376 uint8 TstAndSwit(void)
1272                     ; 377 {	
1273                     	switch	.text
1274  02bd               _TstAndSwit:
1276  02bd 88            	push	a
1277       00000001      OFST:	set	1
1280                     ; 378 	uint8 F_OK = 0 ;
1282  02be 0f01          	clr	(OFST+0,sp)
1283                     ; 397 	if(Direction == FAN)  //反转
1285  02c0 b614          	ld	a,_tBC_Param+19
1286  02c2 a101          	cp	a,#1
1287  02c4 2703cc0348    	jrne	L574
1288                     ; 399 		switch(BldcStep)
1290  02c9 b60a          	ld	a,_tBC_Param+9
1292                     ; 443 			default : 
1292                     ; 444 				break ;
1293  02cb 4a            	dec	a
1294  02cc 2713          	jreq	L324
1295  02ce 4a            	dec	a
1296  02cf 2721          	jreq	L524
1297  02d1 4a            	dec	a
1298  02d2 272f          	jreq	L724
1299  02d4 4a            	dec	a
1300  02d5 273d          	jreq	L134
1301  02d7 4a            	dec	a
1302  02d8 274b          	jreq	L334
1303  02da 4a            	dec	a
1304  02db 2759          	jreq	L534
1305  02dd acbc03bc      	jpf	L715
1306  02e1               L324:
1307                     ; 401 			case 1 : //AB   C DOWN
1307                     ; 402 				if(VoCple < M_VoCple)
1309  02e1 be0e          	ldw	x,_tBC_Param+13
1310  02e3 b310          	cpw	x,_tBC_Param+15
1311  02e5 2503          	jrult	L65
1312  02e7 cc03bc        	jp	L715
1313  02ea               L65:
1314                     ; 404 					F_OK = 1 ;
1316  02ea a601          	ld	a,#1
1317  02ec 6b01          	ld	(OFST+0,sp),a
1318  02ee acbc03bc      	jpf	L715
1319  02f2               L524:
1320                     ; 408 			case 2 : //AC   B UP
1320                     ; 409 				if(VoCple > M_VoCple)
1322  02f2 be0e          	ldw	x,_tBC_Param+13
1323  02f4 b310          	cpw	x,_tBC_Param+15
1324  02f6 2203          	jrugt	L06
1325  02f8 cc03bc        	jp	L715
1326  02fb               L06:
1327                     ; 411 					F_OK = 1 ;
1329  02fb a601          	ld	a,#1
1330  02fd 6b01          	ld	(OFST+0,sp),a
1331  02ff acbc03bc      	jpf	L715
1332  0303               L724:
1333                     ; 415 			case 3 : //BC   A DOWN
1333                     ; 416 				if(VoCple < M_VoCple)
1335  0303 be0e          	ldw	x,_tBC_Param+13
1336  0305 b310          	cpw	x,_tBC_Param+15
1337  0307 2503          	jrult	L26
1338  0309 cc03bc        	jp	L715
1339  030c               L26:
1340                     ; 418 					F_OK = 1 ;
1342  030c a601          	ld	a,#1
1343  030e 6b01          	ld	(OFST+0,sp),a
1344  0310 acbc03bc      	jpf	L715
1345  0314               L134:
1346                     ; 422 			case 4 : //BA   C UP	
1346                     ; 423 				if(VoCple > M_VoCple)
1348  0314 be0e          	ldw	x,_tBC_Param+13
1349  0316 b310          	cpw	x,_tBC_Param+15
1350  0318 2203          	jrugt	L46
1351  031a cc03bc        	jp	L715
1352  031d               L46:
1353                     ; 425 					F_OK = 1 ;
1355  031d a601          	ld	a,#1
1356  031f 6b01          	ld	(OFST+0,sp),a
1357  0321 acbc03bc      	jpf	L715
1358  0325               L334:
1359                     ; 429 			case 5 ://CA  B DWON 		
1359                     ; 430 				if(VoCple < M_VoCple)
1361  0325 be0e          	ldw	x,_tBC_Param+13
1362  0327 b310          	cpw	x,_tBC_Param+15
1363  0329 2503          	jrult	L66
1364  032b cc03bc        	jp	L715
1365  032e               L66:
1366                     ; 432 					F_OK = 1 ;				
1368  032e a601          	ld	a,#1
1369  0330 6b01          	ld	(OFST+0,sp),a
1370  0332 acbc03bc      	jpf	L715
1371  0336               L534:
1372                     ; 436 			case 6 ://CB  A UP
1372                     ; 437 				if(VoCple > M_VoCple)
1374  0336 be0e          	ldw	x,_tBC_Param+13
1375  0338 b310          	cpw	x,_tBC_Param+15
1376  033a 2202          	jrugt	L07
1377  033c 207e          	jp	L715
1378  033e               L07:
1379                     ; 439 					F_OK = 1 ;
1381  033e a601          	ld	a,#1
1382  0340 6b01          	ld	(OFST+0,sp),a
1383  0342 2078          	jra	L715
1384  0344               L734:
1385                     ; 443 			default : 
1385                     ; 444 				break ;
1387  0344 2076          	jra	L715
1388  0346               L105:
1390  0346 2074          	jra	L715
1391  0348               L574:
1392                     ; 449 		switch(BldcStep)
1394  0348 b60a          	ld	a,_tBC_Param+9
1396                     ; 505 			default : 
1396                     ; 506 				break ;
1397  034a 4a            	dec	a
1398  034b 2711          	jreq	L144
1399  034d 4a            	dec	a
1400  034e 2722          	jreq	L344
1401  0350 4a            	dec	a
1402  0351 272b          	jreq	L544
1403  0353 4a            	dec	a
1404  0354 273c          	jreq	L744
1405  0356 4a            	dec	a
1406  0357 2745          	jreq	L154
1407  0359 4a            	dec	a
1408  035a 2756          	jreq	L354
1409  035c 205e          	jra	L715
1410  035e               L144:
1411                     ; 451 			case 1 : //AB   C UP
1411                     ; 452 				if(VoCple > M_VoCple)
1413  035e be0e          	ldw	x,_tBC_Param+13
1414  0360 b310          	cpw	x,_tBC_Param+15
1415  0362 2358          	jrule	L715
1416                     ; 454 					F_OK = 1 ;
1418  0364 a601          	ld	a,#1
1419  0366 6b01          	ld	(OFST+0,sp),a
1420                     ; 455 					if ( BldcStatus == STATUS_START)
1422  0368 b609          	ld	a,_tBC_Param+8
1423  036a a101          	cp	a,#1
1424  036c 264e          	jrne	L715
1425                     ; 457 						F_OK = 0;
1427  036e 0f01          	clr	(OFST+0,sp)
1428  0370 204a          	jra	L715
1429  0372               L344:
1430                     ; 462 			case 2 : //AC   B DOWN
1430                     ; 463 				if(VoCple < M_VoCple)
1432  0372 be0e          	ldw	x,_tBC_Param+13
1433  0374 b310          	cpw	x,_tBC_Param+15
1434  0376 2444          	jruge	L715
1435                     ; 465 					F_OK = 1 ;						
1437  0378 a601          	ld	a,#1
1438  037a 6b01          	ld	(OFST+0,sp),a
1439  037c 203e          	jra	L715
1440  037e               L544:
1441                     ; 469 			case 3 : //BC   A UP
1441                     ; 470 				if(VoCple > M_VoCple)
1443  037e be0e          	ldw	x,_tBC_Param+13
1444  0380 b310          	cpw	x,_tBC_Param+15
1445  0382 2338          	jrule	L715
1446                     ; 472 					F_OK = 1 ;
1448  0384 a601          	ld	a,#1
1449  0386 6b01          	ld	(OFST+0,sp),a
1450                     ; 473 					if ( BldcStatus == STATUS_START)
1452  0388 b609          	ld	a,_tBC_Param+8
1453  038a a101          	cp	a,#1
1454  038c 262e          	jrne	L715
1455                     ; 475 						F_OK = 0;
1457  038e 0f01          	clr	(OFST+0,sp)
1458  0390 202a          	jra	L715
1459  0392               L744:
1460                     ; 480 			case 4 : //BA   C DOWN	
1460                     ; 481 				if(VoCple < M_VoCple)
1462  0392 be0e          	ldw	x,_tBC_Param+13
1463  0394 b310          	cpw	x,_tBC_Param+15
1464  0396 2424          	jruge	L715
1465                     ; 483 					F_OK = 1 ;
1467  0398 a601          	ld	a,#1
1468  039a 6b01          	ld	(OFST+0,sp),a
1469  039c 201e          	jra	L715
1470  039e               L154:
1471                     ; 487 			case 5 ://CA  B UP
1471                     ; 488 				if(VoCple > M_VoCple)
1473  039e be0e          	ldw	x,_tBC_Param+13
1474  03a0 b310          	cpw	x,_tBC_Param+15
1475  03a2 2318          	jrule	L715
1476                     ; 490 					F_OK = 1 ;
1478  03a4 a601          	ld	a,#1
1479  03a6 6b01          	ld	(OFST+0,sp),a
1480                     ; 491 					if ( BldcStatus == STATUS_START)
1482  03a8 b609          	ld	a,_tBC_Param+8
1483  03aa a101          	cp	a,#1
1484  03ac 260e          	jrne	L715
1485                     ; 493 						F_OK = 0;
1487  03ae 0f01          	clr	(OFST+0,sp)
1488  03b0 200a          	jra	L715
1489  03b2               L354:
1490                     ; 498 			case 6 ://CB  A DOWN
1490                     ; 499 				if(VoCple < M_VoCple)
1492  03b2 be0e          	ldw	x,_tBC_Param+13
1493  03b4 b310          	cpw	x,_tBC_Param+15
1494  03b6 2404          	jruge	L715
1495                     ; 501 					F_OK = 1 ;
1497  03b8 a601          	ld	a,#1
1498  03ba 6b01          	ld	(OFST+0,sp),a
1499  03bc               L554:
1500                     ; 505 			default : 
1500                     ; 506 				break ;
1502  03bc               L325:
1503  03bc               L715:
1504                     ; 511 	if(F_OK)
1506  03bc 0d01          	tnz	(OFST+0,sp)
1507  03be 2728          	jreq	L745
1508                     ; 513 		if (tBC_Param.ucZeroCrossFlag)
1510  03c0 3d2b          	tnz	_tBC_Param+42
1511  03c2 271e          	jreq	L155
1512                     ; 515 			if (Direction == FAN)
1514  03c4 b614          	ld	a,_tBC_Param+19
1515  03c6 a101          	cp	a,#1
1516  03c8 260c          	jrne	L355
1517                     ; 517 				BldcStep = Tab_StepFan[BldcStep-1];
1519  03ca b60a          	ld	a,_tBC_Param+9
1520  03cc 5f            	clrw	x
1521  03cd 97            	ld	xl,a
1522  03ce 5a            	decw	x
1523  03cf d60000        	ld	a,(_Tab_StepFan,x)
1524  03d2 b70a          	ld	_tBC_Param+9,a
1526  03d4 2012          	jra	L745
1527  03d6               L355:
1528                     ; 521 				BldcStep = Tab_StepZen[BldcStep-1];
1530  03d6 b60a          	ld	a,_tBC_Param+9
1531  03d8 5f            	clrw	x
1532  03d9 97            	ld	xl,a
1533  03da 5a            	decw	x
1534  03db d60006        	ld	a,(_Tab_StepZen,x)
1535  03de b70a          	ld	_tBC_Param+9,a
1536  03e0 2006          	jra	L745
1537  03e2               L155:
1538                     ; 526 			tBC_Param.ucZeroCrossFlag = 1 ;
1540  03e2 3501002b      	mov	_tBC_Param+42,#1
1541                     ; 527 			F_OK = 0 ;
1543  03e6 0f01          	clr	(OFST+0,sp)
1544  03e8               L745:
1545                     ; 531 	return  F_OK  ;
1547  03e8 7b01          	ld	a,(OFST+0,sp)
1550  03ea 5b01          	addw	sp,#1
1551  03ec 81            	ret
1588                     ; 536 void BldcLik(void)
1588                     ; 537 {		
1589                     	switch	.text
1590  03ed               _BldcLik:
1592  03ed 88            	push	a
1593       00000001      OFST:	set	1
1596                     ; 538 	uint8 i =0 ;
1598  03ee 0f01          	clr	(OFST+0,sp)
1599                     ; 540 	if(T_DlyTest != 0)
1601  03f0 be0c          	ldw	x,_tBC_Param+11
1602  03f2 2709          	jreq	L775
1603                     ; 542 		T_DlyTest-- ;
1605  03f4 be0c          	ldw	x,_tBC_Param+11
1606  03f6 1d0001        	subw	x,#1
1607  03f9 bf0c          	ldw	_tBC_Param+11,x
1608                     ; 543 		return ;
1611  03fb 84            	pop	a
1612  03fc 81            	ret
1613  03fd               L775:
1614                     ; 546 	return;  // debug_winson
1617  03fd 84            	pop	a
1618  03fe 81            	ret
1645                     ; 562 void BldcRun(void)
1645                     ; 563 {	
1646                     	switch	.text
1647  03ff               _BldcRun:
1651                     ; 564 	if(T_DlyTest != 0) 
1653  03ff be0c          	ldw	x,_tBC_Param+11
1654  0401 2701          	jreq	L116
1655                     ; 565 		return ;
1658  0403 81            	ret
1659  0404               L116:
1660                     ; 567 	if(T_Dly60C > 15000)		
1662  0404 be05          	ldw	x,_tBC_Param+4
1663  0406 a33a99        	cpw	x,#15001
1664  0409 2508          	jrult	L316
1665                     ; 569 		T_Dly60C = 0 ;
1667  040b 5f            	clrw	x
1668  040c bf05          	ldw	_tBC_Param+4,x
1669                     ; 570 		Error_code.bit.ErRun = 1 ;	
1671  040e 72120000      	bset	_Error_code,#1
1672                     ; 571 		return ;
1675  0412 81            	ret
1676  0413               L316:
1677                     ; 574 	if(TstAndSwit())
1679  0413 cd02bd        	call	_TstAndSwit
1681  0416 4d            	tnz	a
1682  0417 273b          	jreq	L516
1683                     ; 577 		T_Dly30C = T_Dly60C ;
1685  0419 be05          	ldw	x,_tBC_Param+4
1686  041b bf07          	ldw	_tBC_Param+6,x
1687                     ; 583 		T_Dly30C -= 1 ; //减去滤波的时间
1689  041d be07          	ldw	x,_tBC_Param+6
1690  041f 1d0001        	subw	x,#1
1691  0422 bf07          	ldw	_tBC_Param+6,x
1692                     ; 585 		if(T_ReRun != 0)
1694  0424 3d0b          	tnz	_tBC_Param+10
1695  0426 270f          	jreq	L716
1696                     ; 587 			T_ReRun -- ;			
1698  0428 3a0b          	dec	_tBC_Param+10
1699                     ; 588 			BLDC_RUN_ONESTEP(BldcStep);	
1701  042a b60a          	ld	a,_tBC_Param+9
1702  042c ad48          	call	_BLDC_RUN_ONESTEP
1704                     ; 589 			T_DlyTest =  T_Dly30C>>1 ;	
1706  042e be07          	ldw	x,_tBC_Param+6
1707  0430 54            	srlw	x
1708  0431 bf0c          	ldw	_tBC_Param+11,x
1709                     ; 590 			T_Dly60C = 0 ;	
1711  0433 5f            	clrw	x
1712  0434 bf05          	ldw	_tBC_Param+4,x
1713                     ; 591 			return ;
1716  0436 81            	ret
1717  0437               L716:
1718                     ; 594 		BldcStatus = STATUS_DLY3C;
1720  0437 350b0009      	mov	_tBC_Param+8,#11
1721                     ; 596 		T_DlyTest = (T_Dly30C >> 1);
1723  043b be07          	ldw	x,_tBC_Param+6
1724  043d 54            	srlw	x
1725  043e bf0c          	ldw	_tBC_Param+11,x
1726                     ; 598 		if(R_CurPwm > 800)
1728  0440 be03          	ldw	x,_tBC_Param+2
1729  0442 a30321        	cpw	x,#801
1730  0445 250d          	jrult	L516
1731                     ; 600 			T_DlyTest += (T_Dly30C / 6) ;//20	
1733  0447 be07          	ldw	x,_tBC_Param+6
1734  0449 90ae0006      	ldw	y,#6
1735  044d 65            	divw	x,y
1736  044e 72bb000c      	addw	x,_tBC_Param+11
1737  0452 bf0c          	ldw	_tBC_Param+11,x
1738  0454               L516:
1739                     ; 603 }
1742  0454 81            	ret
1767                     ; 609 void  AutoRunOne(void)
1767                     ; 610 {
1768                     	switch	.text
1769  0455               _AutoRunOne:
1773                     ; 611 	if (Direction == FAN)
1775  0455 b614          	ld	a,_tBC_Param+19
1776  0457 a101          	cp	a,#1
1777  0459 260e          	jrne	L336
1778                     ; 613 		if(++BldcStep == 7)
1780  045b 3c0a          	inc	_tBC_Param+9
1781  045d b60a          	ld	a,_tBC_Param+9
1782  045f a107          	cp	a,#7
1783  0461 260e          	jrne	L736
1784                     ; 614 			BldcStep = 1 ;		
1786  0463 3501000a      	mov	_tBC_Param+9,#1
1787  0467 2008          	jra	L736
1788  0469               L336:
1789                     ; 618 		if(--BldcStep == 0)
1791  0469 3a0a          	dec	_tBC_Param+9
1792  046b 2604          	jrne	L736
1793                     ; 619 			BldcStep = 6 ;		
1795  046d 3506000a      	mov	_tBC_Param+9,#6
1796  0471               L736:
1797                     ; 622 	BLDC_RUN_ONESTEP(BldcStep);
1799  0471 b60a          	ld	a,_tBC_Param+9
1800  0473 ad01          	call	_BLDC_RUN_ONESTEP
1802                     ; 623 }
1805  0475 81            	ret
1839                     ; 632 void BLDC_RUN_ONESTEP(uint8 STEP)
1839                     ; 633 {
1840                     	switch	.text
1841  0476               _BLDC_RUN_ONESTEP:
1845                     ; 634 	TIM1->CNTRH = 0 ;  //计数器清0
1847  0476 725f525e      	clr	21086
1848                     ; 635 	TIM1->CNTRL = 0 ;
1850  047a 725f525f      	clr	21087
1851                     ; 637 	switch(STEP)
1854                     ; 741 		default : 	
1854                     ; 742 			break ;
1855  047e 4a            	dec	a
1856  047f 271f          	jreq	L346
1857  0481 4a            	dec	a
1858  0482 2758          	jreq	L546
1859  0484 4a            	dec	a
1860  0485 2603cc050c    	jreq	L746
1861  048a 4a            	dec	a
1862  048b 2603          	jrne	L201
1863  048d cc0547        	jp	L156
1864  0490               L201:
1865  0490 4a            	dec	a
1866  0491 2603          	jrne	L401
1867  0493 cc0575        	jp	L356
1868  0496               L401:
1869  0496 4a            	dec	a
1870  0497 2603          	jrne	L601
1871  0499 cc05af        	jp	L556
1872  049c               L601:
1873  049c ace305e3      	jpf	L107
1874  04a0               L346:
1875                     ; 639 		case 1 : // AB
1875                     ; 640 			TIM1->CCMR1 =0x6c; 
1877  04a0 356c5258      	mov	21080,#108
1878                     ; 641 			TIM1->CCMR2 =0; 
1880  04a4 725f5259      	clr	21081
1881                     ; 642 			TIM1->CCMR3 =0; 
1883  04a8 725f525a      	clr	21082
1884                     ; 643 			PWM_AH_OUT_EN();
1886  04ac 7210525c      	bset	21084,#0
1887                     ; 644 			PWM_AL_OUT_EN();		// reyno added
1889  04b0 c6525c        	ld	a,21084
1890  04b3 aa0c          	or	a,#12
1891  04b5 c7525c        	ld	21084,a
1892                     ; 646 			PWM_BH_OUT_DIS();
1894  04b8 7219525c      	bres	21084,#4
1895                     ; 647 			PWM_BL_OUT_DIS();		// reyno added			
1897  04bc 721d525c      	bres	21084,#6
1898                     ; 648 			CNT_BH_OUT_DIS();
1900  04c0 7215500a      	bres	20490,#2
1901                     ; 649 			CNT_BL_OUT_EN();
1903  04c4 72125005      	bset	20485,#1
1904                     ; 651 			PWM_CH_OUT_DIS();
1906  04c8 7211525d      	bres	21085,#0
1907                     ; 652 			PWM_CL_OUT_DIS();		// reyno added
1909  04cc 7215525d      	bres	21085,#2
1910                     ; 653 			CNT_CH_OUT_DIS();
1912  04d0 7217500a      	bres	20490,#3
1913                     ; 654 			CNT_CL_OUT_DIS();
1915  04d4 72155005      	bres	20485,#2
1916                     ; 655 			break ;
1918  04d8 ace305e3      	jpf	L107
1919  04dc               L546:
1920                     ; 656 		case 2 :	//AC
1920                     ; 657 			PWM_AH_OUT_EN();
1922  04dc 7210525c      	bset	21084,#0
1923                     ; 658 			PWM_AL_OUT_EN();		// reyno added
1925  04e0 c6525c        	ld	a,21084
1926  04e3 aa0c          	or	a,#12
1927  04e5 c7525c        	ld	21084,a
1928                     ; 660 			PWM_BH_OUT_DIS();
1930  04e8 7219525c      	bres	21084,#4
1931                     ; 661 			PWM_BL_OUT_DIS();		// reyno added
1933  04ec 721d525c      	bres	21084,#6
1934                     ; 662 			CNT_BH_OUT_DIS();
1936  04f0 7215500a      	bres	20490,#2
1937                     ; 663 			CNT_BL_OUT_DIS();
1939  04f4 72135005      	bres	20485,#1
1940                     ; 665 			PWM_CH_OUT_DIS();
1942  04f8 7211525d      	bres	21085,#0
1943                     ; 666 			PWM_CL_OUT_DIS();		// reyno added			
1945  04fc 7215525d      	bres	21085,#2
1946                     ; 667 			CNT_CH_OUT_DIS();
1948  0500 7217500a      	bres	20490,#3
1949                     ; 668 			CNT_CL_OUT_EN();
1951  0504 72145005      	bset	20485,#2
1952                     ; 669 			break ;
1954  0508 ace305e3      	jpf	L107
1955  050c               L746:
1956                     ; 670 		case 3 : //BC
1956                     ; 671 			TIM1->CCMR1 =0; 
1958  050c 725f5258      	clr	21080
1959                     ; 672 			TIM1->CCMR2 =0; 
1961  0510 725f5259      	clr	21081
1962                     ; 673 			TIM1->CCMR3 =0x6c; 
1964  0514 356c525a      	mov	21082,#108
1965                     ; 674 			PWM_AH_OUT_DIS();
1967  0518 7211525c      	bres	21084,#0
1968                     ; 675 			PWM_AL_OUT_DIS();		// reyno added
1970  051c 7215525c      	bres	21084,#2
1971                     ; 676 			CNT_AH_OUT_DIS();		// reyno added
1973  0520 7213500a      	bres	20490,#1
1974                     ; 677 			CNT_AL_OUT_EN();		// reyno added
1976  0524 72105005      	bset	20485,#0
1977                     ; 679 			PWM_BH_OUT_DIS();
1979  0528 7219525c      	bres	21084,#4
1980                     ; 680 			PWM_BL_OUT_DIS();
1982  052c 721d525c      	bres	21084,#6
1983                     ; 681 			CNT_BH_OUT_DIS();		// reyno added
1985  0530 7215500a      	bres	20490,#2
1986                     ; 682 			CNT_BL_OUT_DIS();		// reyno added
1988  0534 72135005      	bres	20485,#1
1989                     ; 684 			PWM_CH_OUT_EN();
1991  0538 7210525d      	bset	21085,#0
1992                     ; 685 			PWM_CL_OUT_EN();		// reyno added			
1994  053c c6525d        	ld	a,21085
1995  053f aa0c          	or	a,#12
1996  0541 c7525d        	ld	21085,a
1997                     ; 688 			break ;
1999  0544 cc05e3        	jra	L107
2000  0547               L156:
2001                     ; 689 		case 4 ://BA
2001                     ; 690 			PWM_AH_OUT_DIS();
2003  0547 7211525c      	bres	21084,#0
2004                     ; 691 			PWM_AL_OUT_DIS();		// reyno added
2006  054b 7215525c      	bres	21084,#2
2007                     ; 692 			CNT_AH_OUT_DIS();		// reyno added
2009  054f 7213500a      	bres	20490,#1
2010                     ; 693 			CNT_AL_OUT_DIS();		// reyno added
2012  0553 72115005      	bres	20485,#0
2013                     ; 695 			PWM_BH_OUT_DIS();
2015  0557 7219525c      	bres	21084,#4
2016                     ; 696 			PWM_BL_OUT_DIS();
2018  055b 721d525c      	bres	21084,#6
2019                     ; 697 			CNT_BH_OUT_DIS();		// reyno added
2021  055f 7215500a      	bres	20490,#2
2022                     ; 698 			CNT_BL_OUT_EN();		// reyno added
2024  0563 72125005      	bset	20485,#1
2025                     ; 700 			PWM_CH_OUT_EN();
2027  0567 7210525d      	bset	21085,#0
2028                     ; 701 			PWM_CL_OUT_EN();		// reyno added
2030  056b c6525d        	ld	a,21085
2031  056e aa0c          	or	a,#12
2032  0570 c7525d        	ld	21085,a
2033                     ; 704 			break ;
2035  0573 206e          	jra	L107
2036  0575               L356:
2037                     ; 705 		case 5 ://CA
2037                     ; 706 			TIM1->CCMR1 =0; 
2039  0575 725f5258      	clr	21080
2040                     ; 707 			TIM1->CCMR2 =0x6c; 
2042  0579 356c5259      	mov	21081,#108
2043                     ; 708 			TIM1->CCMR3 =0; 
2045  057d 725f525a      	clr	21082
2046                     ; 710 			PWM_AH_OUT_DIS();
2048  0581 7211525c      	bres	21084,#0
2049                     ; 711 			PWM_AL_OUT_DIS();
2051  0585 7215525c      	bres	21084,#2
2052                     ; 712 			CNT_AH_OUT_DIS();		// reyno added
2054  0589 7213500a      	bres	20490,#1
2055                     ; 713 			CNT_AL_OUT_DIS();		// reyno added
2057  058d 72115005      	bres	20485,#0
2058                     ; 715 			PWM_BH_OUT_EN();
2060  0591 7218525c      	bset	21084,#4
2061                     ; 716 			PWM_BL_OUT_EN();
2063  0595 c6525c        	ld	a,21084
2064  0598 aac0          	or	a,#192
2065  059a c7525c        	ld	21084,a
2066                     ; 720 			PWM_CH_OUT_DIS();
2068  059d 7211525d      	bres	21085,#0
2069                     ; 721 			PWM_CL_OUT_DIS();
2071  05a1 7215525d      	bres	21085,#2
2072                     ; 722 			CNT_CH_OUT_DIS();		// reyno added
2074  05a5 7217500a      	bres	20490,#3
2075                     ; 723 			CNT_CL_OUT_EN();		// reyno added
2077  05a9 72145005      	bset	20485,#2
2078                     ; 724 			break ;
2080  05ad 2034          	jra	L107
2081  05af               L556:
2082                     ; 725 		case 6 :	//CB
2082                     ; 726 			PWM_AH_OUT_DIS();
2084  05af 7211525c      	bres	21084,#0
2085                     ; 727 			PWM_AL_OUT_DIS();
2087  05b3 7215525c      	bres	21084,#2
2088                     ; 728 			CNT_AH_OUT_DIS();		// reyno added
2090  05b7 7213500a      	bres	20490,#1
2091                     ; 729 			CNT_AL_OUT_EN();		// reyno added
2093  05bb 72105005      	bset	20485,#0
2094                     ; 731 			PWM_BH_OUT_EN();
2096  05bf 7218525c      	bset	21084,#4
2097                     ; 732 			PWM_BL_OUT_EN();
2099  05c3 c6525c        	ld	a,21084
2100  05c6 aac0          	or	a,#192
2101  05c8 c7525c        	ld	21084,a
2102                     ; 733 			CNT_BH_OUT_DIS();
2104  05cb 7215500a      	bres	20490,#2
2105                     ; 734 			CNT_BL_OUT_EN();
2107  05cf 72125005      	bset	20485,#1
2108                     ; 736 			PWM_CH_OUT_DIS();
2110  05d3 7211525d      	bres	21085,#0
2111                     ; 737 			PWM_CL_OUT_DIS();
2113  05d7 7215525d      	bres	21085,#2
2114                     ; 738 			CNT_CH_OUT_DIS();		// reyno added
2116  05db 7217500a      	bres	20490,#3
2117                     ; 739 			CNT_CL_OUT_DIS();		// reyno added
2119  05df 72155005      	bres	20485,#2
2120                     ; 740 			break ;		
2122  05e3               L756:
2123                     ; 741 		default : 	
2123                     ; 742 			break ;
2125  05e3               L107:
2126                     ; 744 }
2129  05e3 81            	ret
2542                     	xdef	_TstAndSwit
2543                     	xdef	_Nop
2544                     	xdef	_DISP_TAB
2545                     	xdef	_Tab_StepZen
2546                     	xdef	_Tab_StepFan
2547                     	xdef	_KSTBL
2548                     	xdef	_KSTB
2549                     	xdef	_KLST
2550                     	xdef	_BLDC_RUN_ONESTEP
2551                     	xdef	_AutoRunOne
2552                     	xdef	_BldcRun
2553                     	xdef	_BldcLik
2554                     	xdef	_Check_BEMF_Voltage
2555                     	xdef	_SpeedRefAccDec
2556                     	xdef	_CmdPwmSlow
2557                     	xdef	_DISP_Display
2558                     	xdef	_BldcBak
2559                     	xdef	_Key_Check
2560                     	xdef	_Run_Ctl
2561                     	xdef	_Led_Light
2562                     	xdef	_Timer1_PWM_Value
2563                     	xdef	_Timer1_CCR4_Value
2564                     	xdef	_AdcSwitch
2565                     	xdef	_OffSixPin
2566                     	switch	.ubsct
2567  0000               _Error_code:
2568  0000 00            	ds.b	1
2569                     	xdef	_Error_code
2570  0001               _tBC_Param:
2571  0001 000000000000  	ds.b	46
2572                     	xdef	_tBC_Param
2573                     	xref	_SPI_GetFlagStatus
2574                     	xref	_SPI_SendData
2575                     	xref	_GPIO_WriteLow
2576                     	xref	_GPIO_WriteHigh
2596                     	end
