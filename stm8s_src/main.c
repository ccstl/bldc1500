/**
  ******************************************************************************
  * @file    Project/main.c 
  * @author  MCD Application Team
  * @version V2.2.0
  * @date    30-September-2014
  * @brief   Main program body
   ******************************************************************************
  * @attention
  *
  * <h2><center>&copy; COPYRIGHT 2014 STMicroelectronics</center></h2>
  *
  * Licensed under MCD-ST Liberty SW License Agreement V2, (the "License");
  * You may not use this file except in compliance with the License.
  * You may obtain a copy of the License at:
  *
  *        http://www.st.com/software_license_agreement_liberty_v2
  *
  * Unless required by applicable law or agreed to in writing, software 
  * distributed under the License is distributed on an "AS IS" BASIS, 
  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  * See the License for the specific language governing permissions and
  * limitations under the License.
  *
  ******************************************************************************
  */ 


/* Includes ------------------------------------------------------------------*/
#include "stm8s.h"
#include "control.h"
#include "string.h"

static void AppStopToAlignment(void);
void delay_us(unsigned int us);

unsigned short adc_table[10];


/* Private defines -----------------------------------------------------------*/
/* Private function prototypes -----------------------------------------------*/
/* Private functions ---------------------------------------------------------*/

//*************************************
// �������ƣ�Init_Clk
// �������ܣ�ϵͳʱ�ӳ�ʼ��
// ��ڲ�������
// ���ڲ�������
//***************************************/
void Init_Clk(void)
{
  CLK->CKDIVR = 0x00;   	// 16M
}

//*************************************
// �������ƣ�Init_Timer1_PWM
// �������ܣ���ʱ��1��PWM���ʱ��ʼ��
// ��ڲ�����PWM�ȼ� ÿ��0.125U (1000*0.125 = 12.5U = 8K)
// ���ڲ�������
/***************************************/
void Init_Timer1_PWM (uint16 Tcon,uint16 Pscr)
{

	//16Mϵͳʱ�Ӿ�Ԥ��Ƶf=fck/(PSCR+1)  
	//f=16M/2=8M��ÿ����������0.125U
	TIM1->PSCRH = (Pscr >> 8) & 0xff ;
	TIM1->PSCRL = Pscr & 0xff ;
	
	//�趨��װ��ʱ�ļĴ���ֵ��255�����ֵ			
	TIM1->ARRH = (Tcon >> 8) & 0xff ;
	TIM1->ARRL = Tcon & 0xff ;
	
	//PWM1ģʽ,TIM1_CNT<TIM1_CCR1ʱ��Ч		
	TIM1->CCMR1 =0x6C ; 
	//PWM1ģʽ,TIM1_CNT<TIM1_CCR1ʱ��Ч		
	TIM1->CCMR2 =0x6C ; 
	//PWM1ģʽ,TIM1_CNT<TIM1_CCR1ʱ��Ч		
	TIM1->CCMR3 =0x6C ; 
	//����ģʽ,TIM1_CNT<TIM1_CCR1ʱ��Ч		
	TIM1->CCMR4 =0x08 ; 
		
	//PWM ռ�ձ� ��0
	TIM1->CCR1H = 0;
	TIM1->CCR1L = 0;
	TIM1->CCR2H = 0;
	TIM1->CCR2L = 0;
	TIM1->CCR3H = 0;
	TIM1->CCR3L = 0;
		
	//����Ƚ�4�ж�
	//TIM1->IER |= BIT4 ;
	
	PWM_AH_OUT_DIS();
	PWM_BH_OUT_DIS();
	PWM_CH_OUT_DIS();
		
	TIM1->EGR = BIT0 ; //UG = 1 ;��ʼ�������� Ԥװ������Ӱ�ӼĴ�����
	TIM1->CNTRH = 0 ;   //��������0
	TIM1->CNTRL = 0 ;
	
	TIM1->CR1 |= TIM1_CR1_CEN;

	//TIM1->CR2 |= 1;

	//����ɲ���Ĵ���
	//TIM1->BKR = (TIM1_BREAKPOLARITY_LOW|TIM1_BREAK_ENABLE|TIM1_OSSISTATE_ENABLE|TIM1_LOCKLEVEL_2);
	//TIM1->BKR = 0x08;
	TIM1->BKR |= TIM1_BKR_MOE;

	//enable break interrupt
	//TIM1->IER |= BIT7;

/*
	TIM1->EGR |= 0x01;   //���³�ʼ��TIM1 
    TIM1->CR1 = 0x00;   //B7(0)����ֱ��д�� B65(00)��Ե����ģʽB4(0)���ϼ���B3(0)��������ֹͣ���������¼�
    TIM1->RCR = 0x00;  
    TIM1->PSCRH =0;     //�趨Ԥ��ƵΪ,16��Ƶ 1M
    TIM1->PSCRL =0x80;  //PWM��ʱ�� Ӱ������
    TIM1->CCER1 = 0x0F; //CC2ER1����1,2,�ߵ�ƽ��Ч
    TIM1->CCMR1 = 0x60; //PWMģʽ1,CC1���������
    TIM1->ARRH = 0;     //�趨��װ��ֵ
    TIM1->ARRL = 0xFF;  //PWM������ 
    TIM1->CCR1H = 0;
    TIM1->CCR1L = 0x80;  // ռ�ձ�ֵ
    TIM1->CR1 |= 0x01; //ʹ��TIM1������
    TIM1->BKR |= 0x80;

	while(1);
*/

/*
	TIM1->ARRH = 0x00;		 // ��������
	TIM1->ARRL = 0x20;
	TIM1->CCR1H = 0x00;		  // TIM1�Ƚ�/����Ĵ���1
	TIM1->CCR1L = 0x0b;
	TIM1->CCR2H = 0x00;
	TIM1->CCR2L = 0x0b;
	TIM1->PSCRH = 0; 			   // ��Ƶ��
	TIM1->PSCRL = 1;

	TIM1->CR1 |= 0x20;		 // CMS(01) : Center-aligned mode 1
	TIM1->CR1 |= 0x80;		 // set ARPE
	TIM1->IER |= 0x03;
	TIM1->IER |= 0x04;
	//TIM1_IER |= 0x20;
	//TIM1_IER |= 0x40;
	//TIM1_IER |= 0x80;
	TIM1->CCMR1 |= 0x60; 	   // OC1M(110) : PWM Mode 1
	TIM1->CCMR1 |= 0x08; 				// set OC1PE
	TIM1->CCMR2 |= 0x60; 
	TIM1->CCMR2 |= 0x08; 
	TIM1->CCER1 |= 0x01; 	   // set CC1E
	TIM1->CCER1 |= 0x08; 	   // set CC1NP
	TIM1->CCER1 |= 0x04; 	   // set CC1NE
	TIM1->CCER1 |= 0x02;
	TIM1->CCER1 |= 0x10; 	   // set CC1E
	TIM1->CCER1 |= 0x20; 	   // set CC1NP
	TIM1->CCER1 |= 0x40; 	   // set CC1NE
	TIM1->CCER1 |= 0x80;
	TIM1->CR2 |= 0x01;		 // set CCPC
	TIM1->CR2 |= 0x04;
	TIM1->CR2 |= 0x04;
	TIM1->EGR |= 0x20;		 // set COMG
	TIM1->DTR = 0x05;		// Deadtime generator
	TIM1->BKR |= 0x08;		 // set OSSR
	TIM1->BKR |= 0x80;		 // set MOE
	TIM1->CR1 |= 0x01;		 // ��������?
	TIM1->OISR |= 0x0f;
*/
}

//*************************************
// �������ƣ�Init_Timer4
// �������ܣ���ʱ��4��ʼ�� 0.25U����һ��
// ��ڲ�������ʱ����������
// ���ڲ�������
/***************************************/
void Init_TIM4(uint8 Tcon,uint8 Pscr)
{								
	TIM4->IER = 0x00 ;		// ��ֹ�ж�
	TIM4->EGR = 0x01 ;		// ������������¼�
	TIM4->PSCR = Pscr ;		// ������ʱ��=16MHZ/16=1M
							// ����������Ϊ 1uS 
													
	//�趨��װ��ʱ�ļĴ���ֵ��255�����ֵ													
	TIM4->ARR = Tcon;			// 1U*20 = 20U   
	TIM4->CNTR = 0;				// �趨�������ĳ�ֵ
												
	// b0 = 1,������������� b1 = 0,�������
	// ���ÿ�������������ʱ��
	TIM4->CR1 |= 0 ;

	// ��������ж�
	TIM4->IER |= 0x01;
	TIM4->CR1 |= 0x01;
}

//*************************************
// �������ƣ�Init_Io
// �������ܣ�IO ��ʼ��
// ��ڲ�������
// ���ڲ�������
/***************************************/
void Init_Io(void)
{
	GPIOA->DDR = 0b11111111;
	GPIOA->CR1 = 0xFF;
	GPIOA->CR2 = 0;

	GPIOB->DDR = 0b00000111;   // UL,VL,WL, ADC
	GPIOB->CR1 = 0b00000111;
	GPIOB->CR2 = 0;

	GPIOC->DDR = 0b11111111;   // NULL,AH,BH,CH,NONE,SCK,MOSI,MISO
	GPIOC->CR1 = 0b11111111;
	GPIOC->CR2 = 0;

	GPIOD->DDR = 0b11111101;   // NONE,SWIM,LED-ERR,LED-RUN,T1,T2,T3,T4
	GPIOD->CR1 = 0b11111101;
	GPIOD->CR2 = 0;

	GPIOE->DDR = 0b11110101;  // NONE,RUN,PWM-EN,BKIN,NULL,RCK,NULL,NULL
	GPIOE->CR1 = 0b11110111;
	GPIOE->CR2 = 0;
		
	PWM_OUT_DIS();
	//CNT_AL_OUT_DIS();
	//CNT_BL_OUT_DIS();
	//CNT_CL_OUT_DIS();

	LED_ERROR_OFF();
	LED_RUN_OFF();
}

//*************************************
// �������ƣ�Init_AD
// �������ܣ���AD��ʼ��
// ��ڲ�������
// ���ڲ�������
/***************************************/
void Init_ADC( void )
{
	u8 value;
	u16 ADC_TDR_tmp;

	ADC2->CR1 = 0;

	//select phase input
	ADC2->CSR = PHASE_C_BEMF_ADC_CHAN;

	ADC_TDR_tmp = 0;
	ADC_TDR_tmp |= (u16)(1) << PHASE_A_BEMF_ADC_CHAN;
	ADC_TDR_tmp |= (u16)(1) << PHASE_B_BEMF_ADC_CHAN;
	ADC_TDR_tmp |= (u16)(1) << PHASE_C_BEMF_ADC_CHAN;
	ADC_TDR_tmp |= (u16)(1) << ADC_CURRENT_CHANNEL;
	ADC_TDR_tmp |= (u16)(1) << ADC_BUS_CHANNEL;
	ADC_TDR_tmp |= (u16)(1) << PHASE_REF_ADC_CHAN;
	ADC_TDR_tmp |= (u16)(1) << PHASE_FED_ADC_CHAN;

	ToCMPxH( ADC2->TDRH, ADC_TDR_tmp);
	ToCMPxL( ADC2->TDRL, ADC_TDR_tmp);

	//enable ADC
	ADC2->CR1 |= BIT0;
	//allow ADC to stabilize
	value=30;
	while(value--);                    
	//clear interrupt flag
	ADC2->CSR &= (u8)(~BIT7);
	
	//ADC2->CSR |= BIT5; // Bit 5 EOCIE: Interrupt enable for EOC
}

unsigned short get_adc(void)
{
	unsigned short value;
	AdcSwitch(PHASE_C_BEMF_ADC_CHAN);
	value = ((uint16)ADC2->DRH<<2) + ADC2->DRL;
	return value; 
}

void init_timer2(void)
{								
	TIM2->IER = 0x00 ;		// ��ֹ�ж�
	TIM2->EGR = 0x01 ;		// ������������¼�
	TIM2->PSCR = 32768 ;		// ������ʱ��=16MHZ/16=1M
													
	TIM2->ARRH = 60;
	TIM2->ARRL = 200;

	TIM2->CNTRH = 0;				// �趨�������ĳ�ֵ
	TIM2->CNTRL = 0;				// �趨�������ĳ�ֵ												
	// b0 = 1,������������� b1 = 0,�������
	// ���ÿ�������������ʱ��
	TIM2->CR1 |= 0 ;

	// ��������ж�
	TIM2->IER |= 0x01;
	TIM2->CR1 |= 0x01;
}

void delay_us(unsigned int us)
{
	unsigned int i;
	for (i = 0; i < us; i++)
	{
		
	}
}

void delay_ms(unsigned int ms)
{
	unsigned int i,j;
	for (j = 0; j < ms; j++)
	{
		for (i = 0; i < 1000; i++)
		{
			
		}
	}
}

void bldc_one_loop(unsigned short duty, unsigned int ms)
{
	unsigned char flag = 1;
	Timer1_PWM_Value(duty);

	for (flag = 1; flag <= 6; flag++)
	{
		BLDC_RUN_ONESTEP(flag);
		delay_ms(ms);
	}
}

void bldc_open_loop(void)
{
	unsigned short duty;
	unsigned int ms = 121;
	static unsigned char step = 1;
	unsigned int i;
	static unsigned short adc_value = 0;
/*
	for (duty = 1; duty < 120; ms--)
	{
		bldc_one_loop(duty, ms);
	}
*/
/*
	bldc_one_loop(10, 100);
	bldc_one_loop(20, 80);
	bldc_one_loop(30, 60);
	bldc_one_loop(40, 50);
	bldc_one_loop(50, 40);
	bldc_one_loop(60, 30);
	bldc_one_loop(70, 20);
*/
	for (i = 0; i < 10; i++)
	{
		bldc_one_loop(70, 28);
	}
			
	for (i = 0; i < 10; i++)
	{
		bldc_one_loop(100, 15);
	}

	for (i = 0; i < 10; i++)
	{
		bldc_one_loop(200, 4);
	}

	for (i = 0; i < 10; i++)
	{
		bldc_one_loop(200, 8);
	}
while(1)
{
	for (i = 0; i < 10; i++)
	{
		bldc_one_loop(200, 8);
	}
}
	for (i = 0; i < 100; i++)
	{
		bldc_one_loop(200, 3);
	}
	
	for (i = 0; i < 100; i++)
	{
		bldc_one_loop(280,2);
	}

	while(1)
	{
		bldc_one_loop(300,2);
	}

#if 0
	i = 0;
	while(1)
	{
		if (step == 5)
		{
			if (i == 10)
				i = 0;
		}
		BLDC_RUN_ONESTEP(step++);
		if (step == 8)
		{
			adc_value = get_adc();
			adc_table[i++] = adc_value;
			delay_us(300);
			
			adc_value = get_adc();
			adc_table[i++] = adc_value;
			delay_us(300);
			
			adc_value = get_adc();
			adc_table[i++] = adc_value;
			delay_us(300);
			
			adc_value = get_adc();
			adc_table[i++] = adc_value;
			delay_us(300);
			
			adc_value = get_adc();
			adc_table[i++] = adc_value;
			delay_us(300);
			
			adc_value = get_adc();
			adc_table[i++] = adc_value;
			delay_us(300);
			
			adc_value = get_adc();
			adc_table[i++] = adc_value;
			delay_us(300);
			
			adc_value = get_adc();
			adc_table[i++] = adc_value;
			delay_us(300);
			
			adc_value = get_adc();
			adc_table[i++] = adc_value;
			delay_us(300);
			
			adc_value = get_adc();
			adc_table[i++] = adc_value;
			delay_us(300);
		}
		
		delay_ms(8);
		if (step > 6){
			step = 1;
		}
	}
#endif
}

static void AppStopToAlignment(void)
{
	Timer1_PWM_Value(400);
	PWM_AH_OUT_DIS();
	PWM_BH_OUT_DIS();
	PWM_CH_OUT_EN();
	CNT_AL_OUT_EN();
	CNT_BL_OUT_EN();
	CNT_CL_OUT_DIS();

	delay_ms(100);

	Timer1_PWM_Value(50);
	PWM_AH_OUT_DIS();
	PWM_BH_OUT_DIS();
	PWM_CH_OUT_DIS();
	CNT_AL_OUT_DIS();
	CNT_BL_OUT_DIS();
	CNT_CL_OUT_DIS();	
}

void main(void)
{
	static uint16 flag = 0;
	_asm("sim");
	
	Init_Clk();
	Init_Io();
	memset(&tBC_Param, 0, sizeof(tBC_Param));
	Init_Timer1_PWM(2400, TIM1_DIV2);  // 8k
	Init_ADC();
	//init_timer2();
/*
	while(1)
	{
		if (flag == 0){
			LED_RUN_ON();
			delay_ms(1000);
			flag = 1;
		}else{		
			LED_RUN_OFF();
			delay_ms(1000);
			flag = 0;
		}
	}
*/	
	_asm("rim");
	Timer1_PWM_Value(50);
	AppStopToAlignment();
	bldc_open_loop();
#if 0
	while(1)
	{
		BLDC_RUN_ONESTEP(1);
		delay_ms(200);		
		BLDC_RUN_ONESTEP(2);
		delay_ms(200);
		BLDC_RUN_ONESTEP(3);
		delay_ms(200);
		BLDC_RUN_ONESTEP(4);
		delay_ms(200);
		BLDC_RUN_ONESTEP(5);
		delay_ms(200);
		BLDC_RUN_ONESTEP(6);
		delay_ms(200);
		/*
		if (flag == 0){
			LED_RUN_ON();
			delay_ms(1);
			flag = 1;
		}else{		
			LED_RUN_OFF();
			delay_ms(1);
			flag = 0;
		}
		*/
	}
#endif
	
	while (1)
	{
		if (tBC_Param.usTick1ms & 0x01)
		{
			Run_Ctl();
			SpeedRefAccDec();
		}
		else if (tBC_Param.usTick1ms & 0x02)
		{
			if (BldcStatus == STATUS_STOP)
			{
				AdcSwitch(ADC_BUS_CHANNEL);
				tBC_Param.usAD_DCbus = ((uint16)ADC2->DRH<<2) + ADC2->DRL;
			}
			FILTER_LP(tBC_Param.lDCbusVoltAcc, tBC_Param.usAD_DCbus, 4);
			tBC_Param.usDCbusVolt = tBC_Param.lDCbusVoltAcc>>16;

			if (tBC_Param.usDCbusVolt > 930)  // 410V ��ѹ
			{
				Error_code.bit.OverVoltage = 1;
			}
			else if (tBC_Param.usDCbusVolt < 453)  // 200V Ƿѹ 
			{
				if (BldcStatus != STATUS_STOP)
				{
					//Error_code.bit.UnderVoltage = 1;
				}
				tBC_Param.ucPowerOn = 0;
			}
			else if (tBC_Param.usDCbusVolt > 470)
			{
				tBC_Param.ucPowerOn = 1;
			}
			
			Key_Check();
		}
		else
		{
			Led_Light();
		}
	}
}

#ifdef USE_FULL_ASSERT

/**
  * @brief  Reports the name of the source file and the source line number
  *   where the assert_param error has occurred.
  * @param file: pointer to the source file name
  * @param line: assert_param error line source number
  * @retval : None
  */
void assert_failed(u8* file, u32 line)
{ 
  /* User can add his own implementation to report the file name and line number,
     ex: printf("Wrong parameters value: file %s on line %d\r\n", file, line) */

  /* Infinite loop */
  while (1)
  {
  }
}
#endif


/************************ (C) COPYRIGHT STMicroelectronics *****END OF FILE****/
