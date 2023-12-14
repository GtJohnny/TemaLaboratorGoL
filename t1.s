.data
sf:.asciz "%d"
v:.space 50
v1:.space 50
mask: .byte 7
n:.space 1 ##[1,18]
m:.space 1 ##[1,18]
p:.space 2 ##[0,324]
k:.space 1 ##[1,18]
size:.space 1## [0,50]
pfpar:.asciz "%d\n"
pfmat:.asciz "%08b\n"
newl:.asciz "\n"            
.text
.global main

CopyMatrix:
push %esi
xorl %ecx, %ecx
xorl %eax, %eax

movb size, %cl
lea v, %esi
add $49,%esi

copy_loop:

movb (%esi), %al
movb %al, 50(%esi)
dec %esi
loop copy_loop
pop %esi
ret



#################

PrintAll:
push %ebp
mov %esp, %ebp
push %eax
push %eax
push $pfpar


xor %eax,%eax
movb m,%al
movb %al, -8(%ebp)
call printf
push $0
call fflush
popl %eax

movb n,%al
movb %al, -8(%ebp)
call printf
push $0
call fflush
popl %eax

movw p,%ax
movw %ax, -8(%ebp)
call printf
push $0
call fflush
popl %eax

xor %ecx,%ecx
movb size,%cl

###################################################
lea v,%esi
add $49,%esi
popl %eax
pushl $pfmat
xorl %eax,%eax
PA:
cmp $0,%ecx
je PA_end
mov %ecx,-4(%ebp)


movb (%esi),%al
movb %al,-8(%ebp)
call printf
push $0
call fflush
pop %eax

dec %esi
mov -4(%ebp),%ecx
dec %ecx
jmp PA
PA_end:



add $12,%esp
pop %ebp
ret





####################
Citire:
push %ebp
mov %esp, %ebp
push %eax
push %eax
sub $4,%ebp
push %ebp
add $4,%ebp





##-X(%ebp)
#-4 =zona de unde citim
#-8 =save place for ecx
#-12=pointer to -4
#-16="%d"
##
push $sf
call scanf  ##cin>>m (linii)
movb -4(%ebp),%al
addb $2,%al 
movb %al,m
movb %al, %bl
call scanf  ##cin>>n (coloane)
xorl %eax, %eax
movb %bl,%al
xorl %ecx, %ecx

movb -4(%ebp),%cl
addb $2,%cl 
movb %cl,n
mul %ecx      ##size=m*n
mov %eax,%ecx
and $7,%ecx
shr $3,%eax
cmpb $0,%cl
jz here
inc %eax
here:
movb %al, size


call scanf  ##cin>>p (puncte vii)
xor %ecx, %ecx
movw -4(%ebp),%cx
movw %cx,p
lea v, %esi
#time to read points
while_st:
cmp $0,%ecx
je while_end

mov %ecx, -8(%ebp)
call scanf
movl -4(%ebp), %ebx
inc %ebx
xor %eax, %eax
movb n, %al
mul %ebx
mov %eax,%ebx

call scanf 
addl -4(%ebp), %ebx
inc %ebx
mov %ebx,%ecx
shr $3,%ebx
and $7,%ecx
mov %esi,%edi
add $49,%edi
sub %ebx,%edi
movb $0x80,%al
shrb %cl,%al

addb %al,(%edi)
movl -8(%ebp), %ecx
dec %ecx
jmp while_st
while_end:

call scanf
movb -4(%ebp),%al
movb %al,k
add $16,%esp
pop %ebp
ret

#########

Numara:
pop %edx
pop %eax
xor %ecx,%ecx
calc_st:
cmp $0,%ax
je calc_end
inc %ecx

movw %ax,%bx
decw %bx
andw %bx,%ax

jmp calc_st
calc_end:
push %ecx
push %edx
ret

VerPozitie:
verif2:
push %ebp
mov %esp,%ebp
lea v,%esi
mov 8(%ebp),%eax
mov 12(%ebp),%ebx

cmp $1,%ebx
je sus_jos
##Mijloc
mov %eax, %ebx
mov %esi, %edi
add $49, %edi
shr $3,%eax
sub %eax,%edi
and $7, %ebx

cmp $7, %ebx
je byte_dr0


cmp $0, %ebx
je byte_st0

jmp byte_mij0

byte_dr0:
movw $0x0280,%ax
movw -1(%edi),%cx
andw %cx, %ax
jmp calc

byte_st0:
movw $0x0140,%ax
movw (%edi),%cx
andw %cx, %ax
jmp calc

byte_mij0:
dec %ebx
movb %bl,%cl
movw -1(%edi),%dx
movw $0xa000,%ax
shrw %cl,%ax
andw %dx,%ax
jmp calc

sus_jos:
mov %eax, %ebx
mov %esi, %edi
add $49, %edi
shr $3,%eax
sub %eax,%edi
and $7, %ebx

cmp $7, %ebx
je byte_dr1


cmp $0, %ebx
je byte_st1

jmp byte_mij1

byte_dr1:
movw $0x0380,%ax
movw -1(%edi),%cx
andw %cx, %ax
jmp calc

byte_st1:
movw $0x01c0,%ax
movw (%edi),%cx
andw %cx, %ax
jmp calc

byte_mij1:
dec %ebx
movb %bl,%cl
movw -1(%edi),%bx
movw $0xe000,%ax
shrw %cl,%ax
andw %bx,%ax
jmp calc


calc:


push %eax
call Numara
pop %eax
add %eax,16(%ebp)

popl %ebp
ret





#####################
NextGen:

##-X(%ebp)
#-4 =zona de index in rulare -> n+2
#-8 =save place for ecx 
#-12=zona de unde este indexul de vector la final -> n*m-n-2
#-16=k
#-20=zona de index de start (n+2)
##





push %ebp  ####0(ebp)
mov %esp,%ebp

xor %eax,%eax
xor %ebx,%ebx
movb n,%al
inc %al
push %eax ##pozitia de start si continuare   ####-4(ebp)
mov %eax, -20(%ebp)
dec %al
movb m,%bl
dec %ebx
mul %ebx
sub $2,%eax
push %eax    ####-8(ebp) 
push %eax  ####-12(ebp)

xor %edx,%edx
movb k, %dl
push %edx   ####-16(ebp)
sub $4,%esp

lea v, %esi

gen_st:
cmp $0,%edx
je gen_end
mov %edx, -16(%ebp)
mov -20(%ebp),%eax
mov %eax, -4(%ebp)

mapi_st:
mov -12(%ebp),%ebx
cmp %ebx,%eax
jge mapi_end

xor %ecx,%ecx
movb n,%cl
sub $2,%cl



mapj_st:
cmp $0,%ecx
je mapj_end
mov %ecx,-8(%ebp)
mov %eax,-4(%ebp)


verif:
push $0 ##suma

push $0 ##tip de rand 0-mijloc 1-sus/jos
push %eax  ## indice pozitie
call VerPozitie
verif3:

pop %eax
pop %ecx

xor %ecx,%ecx
movb n,%cl
sub %ecx,%eax
push $1
push %eax
call VerPozitie
pop %eax

mov -4(%ebp),%eax
xor %ecx,%ecx
movb n,%cl
add %ecx,%eax
push %eax
call VerPozitie
pop %eax
pop %eax ##acel 1 parametru


##sumafinala la varf de stack

stop1:

###
#calcul ce facem cu vecinii
###




lea v,%esi
mem:
add $49,%esi
mov -4(%ebp),%eax
mov -4(%ebp),%ecx
shr $3,%eax
sub %eax,%esi
and $7,%ecx
mov $0x80,%eax
shr %cl,%al
andb (%esi),%al
mov %esi,%edi
add $50,%edi

cmp $0,%al
pop %ebx
mov %ebx,%edx
je dead
##here alive
cmp $2,%ebx
jne nor_alive
cmp $3,%ebx
jne nor_alive
addb %al,(%edi)

dead:
cmp $3,%ebx
jne nor_alive
addb %al,(%edi)


nor_alive:


mov %edx,%eax


####
push %eax
push $sf
call printf
push $0
call fflush
add $12, %esp












mov -4(%ebp),%eax
inc %eax
mov -8(%ebp),%ecx
dec %ecx
jmp mapj_st
mapj_end:


push $newl
call printf
push $0
call fflush
add $8, %esp






mov -4(%ebp),%eax
add $3,%eax

jmp mapi_st
mapi_end:

mov -16(%ebp),%edx
dec %edx
 
jmp gen_st
gen_end:



add $20,%esp
pop %ebp
ret




main:

call Citire
call PrintAll
call NextGen





exit:
mov $1, %eax
xor %ebx, %ebx
int $0x80
