.text
.global main

.equ LED_CTL, 0x41210000
.set SW_DATA, 0x41220000
.set BTN_DATA, 0x41200000

main:
	ldr r1,=SW_DATA
	ldr r2,=LED_CTL
	ldr r3,=BTN_DATA
loop:
	ldr r0,[r1]		@load switch value, (*r1) ->r0
	ldr r4,[r3] 	@load button value, (*r3) ->r3
	ands r0,#0x0000000F 	@mask out top values of switches
	eor r5,r0,r4	@compare switch and button registers, exclusive or
	str r5,[r2] 	@store value to led register
	b loop 	@go back to "loop"
.end
