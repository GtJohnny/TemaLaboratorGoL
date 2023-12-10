.data
sf:.asciz "%d"
v:.space 50
mask: .long 7
n:.space 4
m:.space 4
k:.space 4
p:.space 4

.text
.global main

Citire:
push %ebp
mov %esp, %ebp
##
push $m   # -4(ebp) va fi folosit muuult
push $sf
call scanf
movl $n, -4(%ebp) 
call scanf
movl $p, -4(%ebp) 
call scanf

add $8,%esp




st:
cmp $0, %ecx
je st_fin
push %ecx           
sub $4,%esp
push %esp,-4(%esp)
sub $4,%esp
push $sf

call scanf
mov -8(%ebp),%eax
inc %eax
mov n, %ebx
add $2, %ebx
mul %ebx 
mov %eax, %ebx
call scanf
add -8(%ebp), %ebx
inc %ebx  #(n+2)*(1+x)+y+1
mov $7, %eax
and %ebx, %eax  //restul impartirii la 8
movb %al,%cl
shr $3, %ebx
add $v, %ebx
#shift cu CL apoi adaugare
mov ()

mov (%ebx),










add $16,%esp
pop %ecx
dec %ecx
jmp st
st_fin:

call scanf





pop %ebp
ret





main:
call Citire




exit:
mov $1, %eax
xor %ebx, %ebx
int $0x80
