.data
sf:.asciz "%d"
v:.space 50
v1:.space 50
mask: .byte 7
n:.space 1 ##[1,18]
m:.space 1 ##[1,18]
p:.space 2 ##[0,324]
k:.space 1 ##[1,18]
crypt:.space 1 ##{0,1}
size:.space 1## [0,50]
offset:.space 1 #[0,7]
pfpar:.asciz "%d\n"
pfmat:.asciz "%08b\n"
pffinal: .asciz "%d "
newl:.asciz "\n"     
scanHex:.asciz "%6X%16llX"
scanMesaj:.asciz "%s"
mesHex:.space 16 
mesNormal:.space 10

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

##########################
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



call scanf
xor %eax,%eax
movb -4(%ebp),%al
movb %al,crypt
add $16,%esp

cmp $1,%eax
je cry1  ###decriptare
    push $mesNormal
    push $scanMesaj
    call scanf
    add $8,%esp
    jmp cried
cry1:      ###criptare
    lea mesHex,%esi
    push %esi
    add $8,%esi
    push %esi
    push $scanHex
    call scanf
    add $12,%esp
cried:




pop %ebp
ret

###############

Decriptare:
####
#  -4(%ebp)  -> edx counter marime matrice
#  -8(%ebp)  -> ecx counter hexa
#  -12(%ebp) -> offset
#
####
    push %ebp ##counter
    mov %esp,%ebp
    verif:

    xor %edx,%edx
    movb size, %dl
    push %edx   

    lea mesHex,%edi
    add $9,%edi
    push $0

    lea v, %esi
    add $49,%esi

    movb offset,%dl
    push %edx

    

    mov $10,%ecx
    dec_start:
        cmp $0,%ecx
        je dec_stop
        mov %ecx, -8(%ebp)
        xor %eax,%eax
        movb (%edi),%al  
        cmp $0,%eax
        je skipped:
            mov %edx,-4(%ebp)
            cmp $1,%edx
            jne appended
                xor %eax,%eax
                xor %ebx,%ebx
                movb n,%al
                movb m,%bl
                mul %ebx
                add -12(%ebp),%eax
                and $7,%eax
                add %eax,-12(%ebp)
                movb size,%dl
            appended:
            xor %eax,%eax
            movb (%esi),%al
            mov -12(%ebp),%ecx
             ########trebe calcul cum shiftez + capetele de concatenare



            mov -4(%ebp),%edx
            dec %edx
        skipped: 
        mov -8(%ebp), %ecx
        dec %ecx
        dec %edi
        jmp dec_start
    dec_stop:




    add $12,%esp
    pop %ebp
    ret


Criptare:
    push %ebp
    mov %esp,%ebp






    pop %ebp
    ret




###############

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


push $0 ##suma

push $0 ##tip de rand 0-mijloc 1-sus/jos
push %eax  ## indice pozitie
call VerPozitie

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


movl -4(%ebp),%eax
movl %eax, %ecx
shr $3,%eax
and $7,%ecx
lea v,%esi
add $49,%esi
sub %eax,%esi
movl $0x80, %ebx
shr %cl,%ebx
mov %ebx, %edx
andb (%esi),%bl # >0 Alive ==0 Dead
popl %eax ##scoatem numarul de vecini
cmp $0,%ebx

je dead
##alive  vv
cmp $2,%eax
jl remain_dead
cmp $3,%eax
jg remain_dead
add %edx, 50(%esi)

jmp remain_dead
dead:
cmp $3,%eax
jne remain_dead
add %edx, 50(%esi)

remain_dead:
#### tiparim cati vecini avem
#ush %eax
#push $sf
#call printf
#push $0
#call fflush
#add $12, %esp

mov -4(%ebp),%eax
inc %eax
mov -8(%ebp),%ecx
dec %ecx
jmp mapj_st
mapj_end:


#push $newl
#call printf
#push $0
#call fflush
#add $8, %esp






mov -4(%ebp),%eax
add $3,%eax

jmp mapi_st
mapi_end:

###########Generatia e gata, copiem tot din v1 in v

xor %ecx,%ecx
xor %eax,%eax
movb size, %cl
lea v1,%esi
add $49,%esi
lea v,%edi
add $49,%edi
cpy_st:
push %ecx
movb (%esi),%cl
movb $0, (%esi)

cmp $0,%cl
je nullb
inc %eax
nullb:

movb %cl, (%edi)
dec %edi
dec %esi
popl %ecx
loop cpy_st




cmp $0,%eax
jg not_nullmat
movl $1, -16(%ebp) 
not_nullmat: #########am ajuns la ultima matrice care e plina de 0




mov -16(%ebp),%edx
dec %edx
jmp gen_st
gen_end:
add $20,%esp


#### hai cu criptarea



xor %eax,%eax
movb crypt,%al
cmp $1,%eax

je go_decrypt
    call Criptare
    jmp done
go_decrypt:
    call Decriptare
done:




pop %ebp
ret




main:

call Citire
call NextGen

exit:
mov $1, %eax
xor %ebx, %ebx
int $0x80

