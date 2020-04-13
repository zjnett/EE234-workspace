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
	cmp r4,#1	@is button pressed
	beq btn_toggle
	b loop 	@go back to "loop"
btn_toggle:
	eor r3,r3,#0x00000001 @invert LSB
	str r3,[r2]
	b loop
.end
