.text
.global main

.equ LED_DATA, 0x41210000
.equ BTN_DATA, 0x41200000
.equ SW_DATA, 0x41220000
.equ SVN_SEG_CTRL, 0x43C10000
.equ SVN_SEG_DATA, 0x43C10004
.equ DELAY_CONST, 0x7AE147

/*
	Ones place: 	[fp,#-4]
	Tenths: 		[fp,#-8]
	Hundredths: 	[fp,#-12]
	Thousandths: 	[fp,#-16]
*/

main:
    ldr r4,=SW_DATA
    ldr r5,=BTN_DATA
    ldr r6,=SVN_SEG_CTRL
    ldr r7,=SVN_SEG_DATA

    bl enable_svn_seg
	bl disable_dp
	bl init_stack

    loop:
		//ldr r8,=DELAY_CONST

        bl init_counter_and_offset // r1 --> 0, r3 --> -4
        //bl delay
		bl increment_digit

		// Ones Digit
        ldr r0, [fp,#-4]
        mov r2,#1
        bl write_digit

		// Tenths Digit
        ldr r0, [fp,#-8]
        mov r2,#2
        bl write_digit

		// Hundredths Digit
        ldr r0, [fp,#-12]
        mov r2,#3
        bl write_digit


		// Thousandths Digit
        ldr r0, [fp,#-16]
        mov r2,#4
        bl write_digit
    b loop

delay:
	subs r8,r8,#1
	bne delay
bx lr

init_counter_and_offset:
	and r1,#0 // clear r1
	and r3,#0 // clear r3
	mov r3,#-4 // initial value of r3 should be for first digit, [fp,#-4]
bx lr

init_stack:
push {r0, fp, lr}
	mov fp,sp
	sub sp,sp,#0x10 // 4 words * 4 = 16, 0x10
	and r0,#0 // clear r0
	str r0,[fp,#-4]
	str r0,[fp,#-8]
	str r0,[fp,#-12]
	str r0,[fp,#-16]
bx lr

increment_digit_address: // treats r1 as a counter, r0 as switches, r3 as address
push {r2}
	cmp r0,#3 // compare switches to max value of shift, digit 3 (default: shift LSP)
	bxgt lr
	add r0,#1 // add 1 to r0 (1-4)
	mov r1,r0 // switches + 1 --> counter
	mov r2,#-4 // move -4 immediate into r2 register for mul
	mul r3,r0,r2 // r0 --> r3, correct address shift for stack
pop {r2}
bx lr

increment_digit: // r0 is the current digit value, r1 is a counter, r3 as address offset
push {lr}
	ldr r0,[fp,r3]
	cmp r0,#9
		addne r0,r0,#1
		moveq r0,#0
		streq r0,[fp,r3]
		bleq increment_next
	str r0,[fp,r3]
pop {lr}
bx lr

increment_next: // r1 as a counter, r3 as the address offset
push {lr}
	add r1,r1,#1
	cmp r1,#4
	bxge lr // return if 4 or greater
	sub r3,#4 // move address to next digit (subtract by 4)
	blne increment_digit
pop {lr}
bx lr

enable_svn_seg:
    mov r0,#1
    str r0,[r6]
bx lr

write_digit: // r0 - switches, r2 - digits
push {r1, r3, r4} // push non-parameter registers
    cmp r2,#1 // compare if digits input is valid
    bxlt lr
    cmp r2,#4
    bxgt lr // branch back to main if not

    sub r2,#1 // subtract 1 from r2 (for shifting)

    mov r3,#8
	mul r2,r2,r3 // r2 = shift value

	mov r4,#0b1111 // move 1111 into r4
	lsl r4,r2 // shift 1's to correct location
	lsl r0,r2 // shift new value to proper location

	mvn r4,r4 // invert r4 for mask
	ldr r1, [r7] // load current value of 7segctrl into r1
	ands r1,r1,r4 // AND value of 7segctrl with invert mask
	orrs r0,r0,r1 // OR shifted switch value w/ current 7segctrl value

	// Note the purpose of this is the mask out a 4-bit block so that the
	// new value will truly replace any old digit value.

    str r0, [r7] // stores r0 at r7
pop {r1, r3, r4}
bx lr

read_switches:
    ldr r10,[r4] // load value from switches to r10
bx lr

read_buttons:
    ldr r11,[r5] // load value from buttons to r11
bx lr

transfer_and_shift: // takes large bit # (r1) and shifts left by 4: 4 'shifted off'
// values are then captured into another register (r0).
push {r3}
	mov r3,#0b1111
	mov r0,r1 // move large bit # into r0
	and r0,r3 // mask out all but lowest 4 bits of r0
	lsr r1,#4 // shift out value returned in r0
pop {r3}
bx lr

disable_dp:
push {r1, r3, r7}
	movw r3,#0x8080
	movt r3,#0x8080
	ldr r1, [r7]
	orrs r1,r3
	str r1, [r7]
pop {r1, r3, r7}
bx lr

.end
