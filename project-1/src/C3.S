.text
.global main

.equ LED_CTL, 0x41210000
.set SW_DATA, 0x41220000
.set BTN_DATA, 0x41200000

main:
	ldr r1,=BTN_DATA
	ldr r2,=LED_CTL
	ldr r3,=0x00000000	@load 0 into internal 'latch'
loop:
	ldr r4,[r1]		@load button value, (*r1) ->r4
	ands r4,#1	@mask all buttons but first
	cmp r4, r3 	@compare button press to internal register (should be equal if on, needs to turn off)
	bne light_on
	beq light_off
	b loop 	@go back to "loop"
light_on:
	mov r3,#0x00000001 @move '1' into memory if light is off and button was pressed
	str r3,[r2] @store r3 (1 or 0) into led register
	b loop
light_off:
	mov r3,#0x00000000 @move '0' into memory if light is on and button was pressed
	str r3,[r2] @store r3 (1 or 0) into led register
	b loop
.end