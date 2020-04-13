.text
.global main

.equ LED_CTL, 0x41210000
.set SW_DATA, 0x41220000


main:
	ldr r1,=SW_DATA
	ldr r2,=LED_CTL
loop:
	ldr r0,[r1]	@load switch value, (*r1) ->r0
	ands r0,#0x0000000F
	cmp r0,#3 	@compare switch value with 3
	ble led_light_zero	@branch to 'led_light_zero' if sw val is less than or equal to 3
	cmp r0,#7
	ble led_light_one	@branch to 'led_light_one' if sw val is less than or equal to 7
	cmp r0,#11
	ble led_light_two	@branch to 'led_light_two' if sw val is less than or equal to 11
	cmp r0,#15
	ble led_light_three	@branch to 'led_light_three' if sw val is less than or equal to 15

led_dim:
	mov r0,#0
	str r0,[r2]
	b loop		@go back to start of loop
led_light_zero:
	mov r0,#1
	str r0,[r2]
	b loop
led_light_one:
	mov r0,#2
	str r0,[r2]
	b loop
led_light_two:
	mov r0,#4
	str r0,[r2]
	b loop
led_light_three:
	mov r0,#8
	str r0,[r2]
	b loop

.end
