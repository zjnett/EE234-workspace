.text
.global main

.equ LED_CTL, 0x41210000
.set SW_DATA, 0x41220000
.set BTN_DATA, 0x41200000

main:
	ldr r1,=SW_DATA
	ldr r2,=LED_CTL
	ldr r3,=BTN_DATA
	ldr r6,=0x00000000	@load 0 into internal 'latch'
loop:
	ldr r4,[r1]		@load switch value, (*r1) ->r4
	ldr r5,[r3] 	@load button value, (*r3) ->r5
	ands r4,#0x000000FF 	@mask out top values of switches (want 8 switches)
	cmp r5,#0x00000001 	@see if first button (btn0) is pressed
	moveq r6,r4 @move r4 (switches) into internal memory (r6) if button was pressed
	cmp r5,#2 	@see if second button (btn1) is pressed
	moveq r6,#0x00000000 @clear r6 if 'clear' button is pressed (btn1)
	str r6,[r2] 	@store internal value to led register
	b loop 	@go back to "loop"
.end
