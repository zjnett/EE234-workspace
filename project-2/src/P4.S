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
.equ PWM_WIDTH, 0x43C00008
.equ PWM_WIDTH, 0x43C00018
.equ PWM_WIDTH, 0x43C00028
.equ PWM_WIDTH, 0x43C00038
.equ PWM_WIDTH, 0x43C00048
.equ PWM_WIDTH, 0x43C00058

main:
	loop:
		bl disable_pwm_channel
		bl enable_pwm_channel
		bl set_pwm_window
		bl set_pwm_duty
	b loop

enable_pwm_channel: @r0 = which channel (top 3 bits), @r1 = PWM
	ldr r2,=SW_DATA
	ldr r0,[r2] @ load switches into r0
	and r0,#1110000000000 @ mask all but top 3 of r0
	lsr r0,#10 @ shift right 10
	cmp r0,#7
	bge lr @ branch if not 0 <= # <= 6
	cmp r0,#1
		ldr r1,=PWM_EN0
		str #1,[r1]
	cmp r0,#2
		ldr r1,=PWM_EN1
		str #1,[r1]
	cmp r0,#3
		ldr r1,=PWM_EN2
		str #1,[r1]
	cmp r0,#4
		ldr r1,=PWM_EN3
		str #1,[r1]
	cmp r0,#5
		ldr r1,=PWM_EN4
		str #1,[r1]
	cmp r0,#6
		ldr r1,=PWM_EN5
		str #1,[r1]
	bx lr

disable_pwm_channel: @r0 = which channel to disable (top 3 bits)
	ldr r2,=SW_DATA
	ldr r0,[r2] @ load switches into r0
	and r0,#1110000000000 @ mask all but top 3 of r0
	lsr r0,#10 @ shift right 10
	cmp r0,#0
	bge lr @ branch if not 0
	ldr r1,=PWM_EN0
	str #0,[r1]
	ldr r1,=PWM_EN1
	str #0,[r1]
	ldr r1,=PWM_EN2
	str #0,[r1]
	ldr r1,=PWM_EN3
	str #0,[r1]
	ldr r1,=PWM_EN4
	str #0,[r1]
	ldr r1,=PWM_EN5
	str #0,[r1]
	bx lr

set_pwm_window: @ r1 is window
	@ window should be maximum of possible switches - 2^32 bit
	@ value based on scaled pwm duty value
	ldr r1,=PWM_WIDTH0
	str #0x100000000,[r1]
	ldr r1,=PWM_WIDTH1
	str #0x100000000,[r1]
	ldr r1,=PWM_WIDTH2
	str #0x100000000,[r1]
	ldr r1,=PWM_WIDTH3
	str #0x100000000,[r1]
	ldr r1,=PWM_WIDTH4
	str #0x100000000,[r1]
	ldr r1,=PWM_WIDTH5
	str #0x100000000,[r1]
	bx lr

set_pwm_duty: @ r2/r0 is duty
	ldr r2,=SW_DATA
	ldr r0,[r2] @ load switches into r0
	and r0,#000111111111 @ mask only top 3 switches
	lsl r0,#23 @ bit shift left 23 (9-bit -> 32-bit num)
	ldr r1,=PWM_PERIOD0
	str r0,[r1]
	ldr r1,=PWM_PERIOD1
	str r0,[r1]
	ldr r1,=PWM_PERIOD2
	str r0,[r1]
	ldr r1,=PWM_PERIOD3
	str r0,[r1]
	ldr r1,=PWM_PERIOD4
	str r0,[r1]
	ldr r1,=PWM_PERIOD5
	str r0,[r1]
	bx lr

.end

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
	mov r7,#0 @ previous instruction was 0

	loop:

	ldr r4,=PWM_EN0
	ldr r5,=PWM_WIDTH0
	ldr r6,=PWM_PERIOD0
	@ load switches to register r0
	ldr r1,=SW_DATA
	ldr r0,[r1]
	@ select channel
	lsr r0,#9 @ shift right 9 bits (for selection bits)



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

	// LOGIC: If switches have changed, previous channel must be disabled.

	cmp r0,r7 @ see if switches have changed between this and previous instruction
		blne switches_changed
		bleq switches_unchanged

		mov r7,r0 @ store previous instruction

	b loop

switches_changed:
		mov r9,r0
		mov r8,lr @r8 = lr backup
		cmp r0,#0
			bleq disable_pwm_channel
			blne enable_pwm_channel // enable new channel before shifting
		mov r2,r4
		mov r0,r7 @ move previous instruction back to r0 if have changed
		bl shift_address
		mov r4,r2
		cmp r0,#0
		bne disable_pwm_channel
		mov lr,r8
		mov r0,r9
	bx lr

switches_unchanged:
		mov r9,r0
		mov r8,lr @r8 = lr backup
		cmp r7,#0
		cmpeq r0,#0
		bxeq lr
		b enable_pwm_channel
		mov lr,r8
		mov r0,r9
	bx lr

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
