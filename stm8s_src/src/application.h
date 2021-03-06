#ifndef _APPLICATION_H
#define _APPLICATION_H

#include "stm8s.h"

typedef void (*tp_func)(void);  /* pointer to a function */

#define APP_INIT                0   /* Application states */
#define APP_CALIB               1
#define APP_ALIGNMENT           2
#define APP_START               3
#define APP_RUN                 4
#define APP_STOP                5
#define APP_FAULT               6

#define ADC_SAMPLE_SIZE				32
#define ADC_DOWN_BEMF_SHIFT			93
#define ADC_UP_BEMF_SHIFT			105

typedef struct
{
	unsigned open_loop_finished : 1;
	unsigned us_timeout : 1;
	unsigned us_enable : 1;
	unsigned commutation_enable : 1;
	unsigned reserved : 4;
	unsigned char commutation;
}s_flags;

typedef struct
{
	unsigned int us_cnt_top;
	unsigned int us_cnt;
	unsigned int ms_cnt;

	unsigned int commutation_cnt;
	unsigned int phase_60degree_cnt;
}s_global_value;


void delay_us(unsigned int us);
void delay_ms(unsigned int ms);
void AppInit(void);
void AppCalib(void);
void AppAlignment(void);
void AppStart(void);
void AppRun(void);
void AppStop(void);
void AppFault(void);
void function_test(void);
unsigned short get_adc(unsigned char);
void init_timer2(unsigned short Tcon,unsigned short, unsigned char Pscr);
void timer2_service(void);
void timer2_service_close_loop(void);
void timer2_disable(void);
void delay_us_with_timer(unsigned int us);
void init_timer3(unsigned short Tcon,uint8 Pscr);
void test_timer3(void);
void init_timer1 (uint16 Tcon,uint16 Pscr);
void reload_timer1 (uint16 Tcon,uint16 Pscr);
void timer2_enable(void);

extern unsigned char g_app_state;
extern const tp_func AppStateMachine[];
extern unsigned short g_pwm_on_duty;
extern unsigned short g_counter_ms;
extern s_flags g_flags;
extern s_global_value g_values;

#endif
