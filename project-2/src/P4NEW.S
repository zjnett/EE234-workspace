.text
.global main

.equ LED_DATA, 0x41210000
.equ SW_DATA, 0x41220000
.equ PWM_EN0, 0x43C00000
.equ PWM_EN1, 0x43C00010
.equ PWM_EN2, 0x43C00020
.equ PWM_EN3, 0x43C00030
.equ PWM_EN4, 0x43C00040
.equ PWM_EN5, 0x43C00050
.equ PWM_PERIOD0, 0x43C00004
.equ PWM_PERIOD1, 0x43C00014
.equ PWM_PERIOD2, 0x43C00024
.equ PWM_PERIOD3, 0x43C00034
.equ PWM_PERIOD4, 0x43C00044
.equ PWM_PERIOD5, 0x43C00054
.equ PWM_WIDTH0, 0x43C00008
.equ PWM_WIDTH1, 0x43C00018
.equ PWM_WIDTH2, 0x43C00028
.equ PWM_WIDTH3, 0x43C00038
.equ PWM_WIDTH4, 0x43C00048
.equ PWM_WIDTH5, 0x43C00058

main:

	loop:
	ldr r4,=PWM_EN0
	ldr r5,=PWM_WIDTH0
	ldr r6,=PWM_PERIOD0
	@ load switches to register r0
	ldr r1,=SW_DATA
	ldr r0,[r1]
	@ select channel
	lsr r0,#9 @ shift right 9 bits (for selection bits)

	bl disable_all_pwm_channels

	// shift addresses:
	// shift address for enable
	mov r2,r4
	bl shift_address
	mov r4,r2

	// shift address for width
	mov r2,r5
	bl shift_address
	mov r5,r2

	// shift address for period/duty
	mov r2,r6
	bl shift_address
	mov r6,r2

	@ always set window and duty -- even if PWM is disabled
	bl set_pwm_window
	bl set_pwm_duty

	cmp r0,#0
	blne enable_pwm_channel

	b loop

enable_pwm_channel: @ register r0 is temporary variable, r4 contains enable address
	push {r0,r4}
		orr r0,r0,#1
		str r0,[r4]
	pop {r0,r4}
	bx lr

disable_pwm_channel:
	push {r0,r4}
		and r0,r0,#0
		str r0,[r4]
	pop {r0,r4}
	bx lr

disable_all_pwm_channels:
	@ backup r0 & lr
	mov r8,lr
	mov r7,r0
	mov r9,r4
	//using stack (push/pop) broke program
	// r7 = r0 backup, r8 = lr backup, r9 = r4 backup

	mov r0,#0
	mov r2,r4
	bl shift_address
	mov r4,r2
	bl disable_pwm_channel

	mov r0,#1
	mov r2,r4
	bl shift_address
	mov r4,r2
	bl disable_pwm_channel

	mov r0,#2
	mov r2,r4
	bl shift_address
	mov r4,r2
	bl disable_pwm_channel

	mov r0,#3
	mov r2,r4
	bl shift_address
	mov r4,r2
	bl disable_pwm_channel

	mov r0,#4
	mov r2,r4
	bl shift_address
	mov r4,r2
	bl disable_pwm_channel

	mov r0,#5
	mov r2,r4
	bl shift_address
	mov r4,r2
	bl disable_pwm_channel

	//mov r0,r9
	//mov lr,r8 @ restore lr backup
	mov lr,r8
	mov r0,r7
	mov r4,r9
	bx lr

set_pwm_window:
	push {r3,r5}
		mov r3,#9999
		str r3,[r5]
	pop {r3,r5}
	bx lr

set_pwm_duty: @ r2/r0 is duty
	push {r2,r6}
		mov r2,#1
		str r2,[r6]
	bx lr

shift_address: @register to be modified in temp. r2, r0 switches, r1 is to be added to r0
	push {r0,r1,r3}
	mov r1,#1 @ initialize r1 with 1
	cmp r0,#0
		bxeq lr
	cmp r0,#1
		mov r3,#0
		muleq r1,r1,r3
	cmp r0,#2
		mov r3,#0x00000010
		muleq r1,r1,r3
	cmp r0,#3
		mov r3,#0x00000020
		muleq r1,r1,r3
	cmp r0,#4
		mov r3,#0x00000030
		muleq r1,r1,r3
	cmp r0,#5
		mov r3,#0x00000040
		muleq r1,r1,r3
	cmp r0,#6
		mov r3,#0x00000050
		muleq r1,r1,r3
	add r2,r1
	pop {r0,r1,r3}
	bx lr
.end
