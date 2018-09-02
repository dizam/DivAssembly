	.global _start
	.equ wordsize, 4
	.data

dividend:
	.long 0
divisor:
	.long 0
bit:
	.long 0

	.text


_start:
	#eax will be quotient
	#ebx will be i
	#edx will be remainder
	movl $0, %eax
	movl $0, %edx
	movl $0, %ebx
bit_loop:	#for (i = 0	; i < 32; i++)
	#i < 32
	#i - 32 < 0
	#negation i - 32 >= 0
	cmpl $32, %ebx
	jge end_bit_loop

	shll $1, %edx #initial remainder shift
	movl $0, bit #reset bit
	subl %ebx, bit #bit = bit - i
	addl $31, bit # bit = bit + 31 == 31 - i
	mov bit, %cl
	movl %ebx, bit
	mov $1, %ebx
	shll %cl, %ebx #1 <<= 31 - i
	and dividend, %ebx #if (dividend & (1 << (31 - i)))
	movl bit, %ebx
	jz shift_remainder 
	incl %edx #leftover += 1
	shift_remainder:
	shll $1, %eax # initial <<= 1
	cmpl divisor, %edx #if (leftover - divisor) >= 0
	jl binary_subtraction	#leftover -= divisor, initial += 1
	subl divisor, %edx #leftover -= divisor
	incl %eax #initial +=1
	binary_subtraction:
	incl %ebx #i++
	jmp bit_loop #go to next iteration
end_bit_loop:

done:
	movl %eax, %eax

	
	
