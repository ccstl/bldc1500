
#include "control.h"

tBLDC_Param tBC_Param ;
tFlg Error_code;

//=== �������==========
uint8 KLST=0,KSTB=0,KSTBL=0;

//------  VR  --------------

//������в���
const uint8 Tab_StepFan[]={2,3,4,5,6,1};  //��ת
const uint8 Tab_StepZen[]={6,1,2,3,4,5};  //��ת      
uint8 DISP_TAB[]=						//��ʾ���
{
	0x003f,// 00: 0
	0x0006,// 01: 1
	0x005b,// 02: 2
	0x004f,// 03: 3
	0x0066,// 04: 4
	0x006d,// 05: 5
	0x007d,// 06: 6
	0x0007,// 07: 7
	0x007f,// 08: 8
	0x006f,// 09: 9
	//0x14,0xD7,0x4C,0x45,0x87,0x25,0x24,0x57,0x04,0x05,0x06,0xA4,0x3C
};

//*************************************
// �������ƣ�Nop
// �������ܣ���ʱ����
// ��ڲ�������ʱʱ��
// ���ڲ�������
//***************************************/
void Nop(uint8 T_Dly)
{	
	while(T_Dly--);		
	return ;
}


void DISP_Display(void)
{
	static uint8 BitNo = 0;
	uint16 usPos;
	uint8 data;
	uint8 i;

	GPIO_WriteLow(GPIOE,GPIO_PIN_5);

	data = DISP_TAB[BitNo];
	usPos = (0x01<<BitNo);
	
	while (SPI_GetFlagStatus(SPI_FLAG_TXE) == RESET);
	SPI_SendData(usPos);
	while (SPI_GetFlagStatus(SPI_FLAG_TXE) == RESET);
	SPI_SendData(0xFF);
	while (SPI_GetFlagStatus(SPI_FLAG_TXE) == RESET);
	
	GPIO_WriteHigh(GPIOE,GPIO_PIN_5);
	
	BitNo++;
	if (BitNo > 3)
	{
		BitNo = 0;
	}
}

//********************************************
//**********    ����ʼ������	        ******
//*******************************************
void OffSixPin(void)
{
	CNT_AL_OUT_DIS();
	CNT_BL_OUT_DIS();
	CNT_CL_OUT_DIS();
	PWM_AH_OUT_DIS();
	PWM_BH_OUT_DIS();
	PWM_CH_OUT_DIS();

}

//*************************************
// �������ƣ�BldcBak
// �������ܣ����ɲ������
// ��ڲ��������ɲ��ʱ��
// ���ڲ�������
//***************************************/
void BldcBak(void)
{
	PWM_BH_OUT_DIS();
	PWM_BH_OUT_DIS();
	PWM_CH_OUT_DIS();
	CNT_AL_OUT_EN();
	CNT_BL_OUT_EN();
	CNT_CL_OUT_EN();									
}

//OVER CURRENT check
void Timer1_CCR4_Value(uint16 InValue)
{
	ToCMPxH(TIM1->CCR4H,InValue);
	ToCMPxL(TIM1->CCR4L,InValue);		
}

//======= PWM OUT ==========
void Timer1_PWM_Value(uint16 OUT_PWM)
{
	// OUT_PWM = 50;
	ToCMPxH(TIM1->CCR1H,OUT_PWM);
	ToCMPxL(TIM1->CCR1L,OUT_PWM);
	ToCMPxH(TIM1->CCR2H,OUT_PWM);
	ToCMPxL(TIM1->CCR2L,OUT_PWM);
	ToCMPxH(TIM1->CCR3H,OUT_PWM);
	ToCMPxL(TIM1->CCR3L,OUT_PWM);
}

//********************************************
//**********     ���ư���       	        ********
//*******************************************
void Key_Check(void)
{
	Direction = ZEN;

	tBC_Param.R_Err = Error_code.all;
	
	//��״̬	
	if (GPIOE->IDR & GPIO_PIN_1)
	{
		tBC_Param.ucCmdKey = 1;
	}
	else
	{
		tBC_Param.ucCmdKey = 0;
	}

	if(tBC_Param.ucCmdKey != KSTB) 	//��һ�ΰ���
	{
		if (KSTBL++>20)
		{
			KSTB = tBC_Param.ucCmdKey;
			KSTBL = 0;
		}
	}
	else
	{
		KSTBL = 0;
	}
	
	if ((KSTB == 1) && (tBC_Param.ucRunProtect == 0))  //���ذ���
	{
		tBC_Param.RunCmd = 1;
	}			
	else
	{				
		tBC_Param.RunCmd = 0;
	}

	if (tBC_Param.ucRunProtect)
	{
		if (KSTB == 0)
		{
			tBC_Param.ucRunProtect = 0;
		}
	}
	else
	{
		if ((KSTB) && (tBC_Param.R_Err))
		{
			tBC_Param.ucRunProtect = 1;
		}
	}
}

void SpeedRefAccDec(void)
{
	tBC_Param.R_VRAD = 100;   // debug_winson
	
	if (tBC_Param.R_VRAD > TIMER1_CNT)
	{
		R_SetPwm = TIMER1_CNT;
	}
	else if (tBC_Param.R_VRAD <= V_MINSPEED)
	{
		R_SetPwm = V_MINSPEED ;
	}
	else
	{
		R_SetPwm = tBC_Param.R_VRAD ;
	}
}


//********************************************
//**********    PWMռ�ձ�������       ********
//********************************************
void CmdPwmSlow(void)
{
	if (BldcStatus > STATUS_START)
	{
		if (R_SetPwm == R_CurPwm) // tBC_Param.R_VRAD
		{		
			return ;
		}
		else if (R_SetPwm < R_CurPwm)
		{
			R_CurPwm--;
		}
		else
		{		
			R_CurPwm ++;
		}			
		
		Timer1_PWM_Value(R_CurPwm);
	}
}


//********************************************
//**********    �������             ********
//*******************************************
//�������������ֹͣ
void Run_Ctl(void)
{
	static uint16 usChargeCnt = 0;
	
	switch (tBC_Param.ucState)
	{
	case 0:
		if (tBC_Param.RunCmd == 1)
		{
			tBC_Param.R_Mode = MODE_ON;
			PWM_OUT_EN();
			TEST1_ON();
			tBC_Param.ucState = 1;
			usChargeCnt = 0;
		}
		else
		{
			TIM1_BREAK_DIS();      // Break input (BKIN) disabled
			TIM1_BREAK_IER_DIS();
			TIM1->BKR &= (uint8_t)(~TIM1_BKR_MOE);
			OffSixPin();
			tBC_Param.R_Mode = MODE_OFF;
			BldcStatus = STATUS_STOP;
			TIM1_CMP4_IEN_DIS();   // CC4 interrupt disabled
			Timer1_PWM_Value(0);
			PWM_OUT_DIS();
			TEST1_OFF();
			
			Error_code.all = 0;  // debug_winson
		}
		break;
		
	case 1:
		if (usChargeCnt++ < 20)
		{
			CNT_AL_OUT_EN();
			CNT_BL_OUT_EN();
			CNT_CL_OUT_EN();
		}
		else
		{
			usChargeCnt = 0;
			CNT_AL_OUT_DIS();
			CNT_BL_OUT_DIS();
			CNT_CL_OUT_DIS();
			
			TIM1_BREAK_ENB();
			TIM1->SR1 &= (u8)(~BIT7);
			TIM1_BREAK_IER_ENB();
			TIM1->BKR |= TIM1_BKR_MOE;
			Timer1_CCR4_Value(1);
			
			//PWM ռ�ձ�����							
			R_CurPwm = V_PWMSTART;			//��ǰֵ					
			R_SetPwm= V_PWMRUN_MIN ;		//�趨ֵ	
			tBC_Param.StartStep = 0 ;//��������
			BldcStep = V_BLDC_DING ;
			T_Dly60C = 0;
			BldcStatus = STATUS_START ;  //����

			tBC_Param.ucState = 2;
		}
		break;
		
	case 2:
		if (tBC_Param.RunCmd == 0)
		{
			tBC_Param.ucState = 0;
		}
		break;

	default:
		break;
	}
}

void Led_Light(void)
{
	if (BldcStatus == STATUS_STOP)
	{
		LED_RUN_OFF();
	}
	else
	{
		LED_RUN_ON();
	}

	if (tBC_Param.R_Err)
	{
		LED_ERROR_ON();
	}
	else
	{
		LED_ERROR_OFF();
	}
}

//*************************************
// �������ƣ�AdcSwitch
// ��������:    ��ͨ��ģʽ��ת��ĳһͨ����ADֵ
// ��ڲ�����Ҫת����ADͨ����
// ���ڲ�������
/***************************************/
void AdcSwitch(uint8 Chanel)
{
	ADC2->CSR = Chanel;	//ѡ��ת��ͨ��	
	ADC2->CR1 |= 0x01 ;		// ����ADC

	while(!(ADC2->CSR & BIT7));	//�ȴ�ת��
	ADC2->CSR &= 0x7f;
}


// ��ȡ���綯��״̬
void Check_BEMF_Voltage(void)
{	
	uint16 Value=0 ;
		
	//  �����綯��
	switch(BldcStep)
	{
		case 1 : //AB  ȡ ��C��W
		case 4 :
			AdcSwitch(PHASE_C_BEMF_ADC_CHAN);
			Value = ((uint16)ADC2->DRH<<2) + ADC2->DRL;
			break ;
							
		case 2 : //AC ͨ  ȡB�� 
		case 5 :
			AdcSwitch(PHASE_B_BEMF_ADC_CHAN);
			Value = ((uint16)ADC2->DRH<<2) + ADC2->DRL;
			break ;	

		case 3 : //BC  ȡ ��A�� 
		case 6 :
			AdcSwitch(PHASE_A_BEMF_ADC_CHAN);
			Value = ((uint16)ADC2->DRH<<2) + ADC2->DRL;
			break ;
					
		default : 
			Value = 0 ;
			break ;
	}			

	VoCple = Value ;

	AdcSwitch(ADC_BUS_CHANNEL);// DC BUS ��ѹ
	tBC_Param.usAD_DCbus = ((uint16)ADC2->DRH<<2) + ADC2->DRL;
	M_VoCple = tBC_Param.usAD_DCbus>>1;
}

// ��ⷴ�綯����� ,�����Ч����1	
uint8 TstAndSwit(void)
{	
	uint8 F_OK = 0 ;

// CW Steps
//A-Channel1, B-Channel2, C-Channel3
//A(Hi), B(Lo), C-looking, BEMF Falling
//A(Hi), C(Lo), B-looking, BEMF Rising
//B(Hi), C(Lo), A-looking, BEMF Falling
//B(Hi), A(Lo), C-looking, BEMF Rising
//C(Hi), A(Lo), B-looking, BEMF Falling
//C(Hi), B(Lo), C-looking, BEMF Rising
// CCW Steps
//A-Channel1, B-Channel2, C-Channel3
//A(Hi), B(Lo), C-looking, BEMF Rising
//C(Hi), B(Lo), A-looking, BEMF Falling
//C(Hi), A(Lo), B-looking, BEMF Rising
//B(Hi), A(Lo), C-looking, BEMF Falling
//B(Hi), C(Lo), A-looking, BEMF Rising
//A(Hi), C(Lo), B-looking, BEMF Falling
			
	if(Direction == FAN)  //��ת
	{							
		switch(BldcStep)
		{				
			case 1 : //AB   C DOWN
				if(VoCple < M_VoCple)
				{
					F_OK = 1 ;
				}			
				break ;
								
			case 2 : //AC   B UP
				if(VoCple > M_VoCple)
				{
					F_OK = 1 ;
				}
				break ;
								
			case 3 : //BC   A DOWN
				if(VoCple < M_VoCple)
				{
					F_OK = 1 ;
				}
				break ;
								
			case 4 : //BA   C UP	
				if(VoCple > M_VoCple)
				{
					F_OK = 1 ;
				}	
				break ;
								
			case 5 ://CA  B DWON 		
				if(VoCple < M_VoCple)
				{
					F_OK = 1 ;				
				}	
				break ;
								
			case 6 ://CB  A UP
				if(VoCple > M_VoCple)
				{
					F_OK = 1 ;
				}	
				break ;
								
			default : 
				break ;
		}	
	}
	else		//��ת
	{
		switch(BldcStep)
		{					
			case 1 : //AB   C UP
				if(VoCple > M_VoCple)
				{
					F_OK = 1 ;
					if ( BldcStatus == STATUS_START)
					{
						F_OK = 0;
					}
				}			
				break ;
								
			case 2 : //AC   B DOWN
				if(VoCple < M_VoCple)
				{
					F_OK = 1 ;						
				}
				break ;
								
			case 3 : //BC   A UP
				if(VoCple > M_VoCple)
				{
					F_OK = 1 ;
					if ( BldcStatus == STATUS_START)
					{
						F_OK = 0;
					}
				}
				break ;
								
			case 4 : //BA   C DOWN	
				if(VoCple < M_VoCple)
				{
					F_OK = 1 ;
				}	
				break ;
								
			case 5 ://CA  B UP
				if(VoCple > M_VoCple)
				{
					F_OK = 1 ;
					if ( BldcStatus == STATUS_START)
					{
						F_OK = 0;
					}
				}	
				break ;
								
			case 6 ://CB  A DOWN
				if(VoCple < M_VoCple)
				{
					F_OK = 1 ;
				}	
				break ;
								
			default : 
				break ;
		}
	}
	
	//--�ж�������Ϊȷ������---------------------
	if(F_OK)
	{
		if (tBC_Param.ucZeroCrossFlag)
		{
			if (Direction == FAN)
			{
				BldcStep = Tab_StepFan[BldcStep-1];
			}
			else
			{
				BldcStep = Tab_StepZen[BldcStep-1];
			}		
		}
		else
		{
			tBC_Param.ucZeroCrossFlag = 1 ;
			F_OK = 0 ;
		}
	}	

	return  F_OK  ;
}

// ����ʱ�����㲢����
// 8k ��Ƶ��ִ��
void BldcLik(void)
{		
	uint8 i =0 ;
		
	if(T_DlyTest != 0)
	{
		T_DlyTest-- ;
		return ;
	}

	return;  // debug_winson
		
	if(TstAndSwit())
	{			
		T_DlyTest = 100;//100 200 300
		T_Dly60C = 0 ;
		T_ReRun = V_RERUN ;
				
		BLDC_RUN_ONESTEP(BldcStep);
		BldcStatus = STATUS_RUN	;
	}
}

//********************************************
//**********     bldc RUN         	********
//********************************************
void BldcRun(void)
{	
	if(T_DlyTest != 0) 
		return ;

	if(T_Dly60C > 15000)		
	{
		T_Dly60C = 0 ;
		Error_code.bit.ErRun = 1 ;	
		return ;
	}
	
	if(TstAndSwit())
	{		
#ifdef	DLY_ADVANCED
		T_Dly30C = T_Dly60C ;
#else
		T_Dly30C = T_Dly60C>>1;
		T_Dly60C = 0 ;	
#endif

		T_Dly30C -= 1 ; //��ȥ�˲���ʱ��
				
		if(T_ReRun != 0)
		{				
			T_ReRun -- ;			
			BLDC_RUN_ONESTEP(BldcStep);	
			T_DlyTest =  T_Dly30C>>1 ;	
			T_Dly60C = 0 ;	
			return ;
		}
				
		BldcStatus = STATUS_DLY3C;
				
		T_DlyTest = (T_Dly30C >> 1);
				
		if(R_CurPwm > 800)
		{
			T_DlyTest += (T_Dly30C / 6) ;//20	
		}			
	}
}

//********************************************
//**********     BLDC����           	********
//********************************************
// ����ʱ��
void  AutoRunOne(void)
{
	if (Direction == FAN)
	{
		if(++BldcStep == 7)
			BldcStep = 1 ;		
	}
	else
	{
		if(--BldcStep == 0)
			BldcStep = 6 ;		
	}

	BLDC_RUN_ONESTEP(BldcStep);
}

//*************************************
// �������ƣ�BLDC_RUN_ONESTEP
// �������ܣ�BLDC��������
// ��ڲ�������
// ���ڲ�������
// �� �� ֵ����
//***************************************/
void BLDC_RUN_ONESTEP(uint8 STEP)
{
	TIM1->CNTRH = 0 ;  //��������0
	TIM1->CNTRL = 0 ;
	
	switch(STEP)
	{
		case 1 : // AB
			PWM_AH_OUT_EN();
			PWM_BH_OUT_DIS();
			PWM_CH_OUT_DIS();
			CNT_AL_OUT_DIS();
			CNT_BL_OUT_EN();
			CNT_CL_OUT_DIS();
			break ;
		case 2 :	//AC
			PWM_AH_OUT_EN();
			PWM_BH_OUT_DIS();
			PWM_CH_OUT_DIS();
			CNT_AL_OUT_DIS();
			CNT_BL_OUT_DIS();
			CNT_CL_OUT_EN();
			break ;
		case 3 : //BC
			PWM_AH_OUT_DIS();
			PWM_BH_OUT_EN();
			PWM_CH_OUT_DIS();
			CNT_AL_OUT_DIS();
			CNT_BL_OUT_DIS();
			CNT_CL_OUT_EN();
			break ;
		case 4 ://BA
			PWM_AH_OUT_DIS();
			PWM_BH_OUT_EN();
			PWM_CH_OUT_DIS();
			CNT_AL_OUT_EN();
			CNT_BL_OUT_DIS();
			CNT_CL_OUT_DIS();
			break ;
		case 5 ://CA
			PWM_AH_OUT_DIS();
			PWM_BH_OUT_DIS();
			PWM_CH_OUT_EN();
			CNT_AL_OUT_EN();
			CNT_BL_OUT_DIS();
			CNT_CL_OUT_DIS();
			break ;
		case 6 :	//CB
			PWM_AH_OUT_DIS();
			PWM_BH_OUT_DIS();
			PWM_CH_OUT_EN();
			CNT_AL_OUT_DIS();
			CNT_BL_OUT_EN();
			CNT_CL_OUT_DIS();
			break ;		
		default : 	
			break ;
	}
}

