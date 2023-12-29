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
pffinal: .asciz "%d "
newl:.asciz "\n" 
fileIn:.asciz "in.txt"    
fileOut:.asciz "out.txt"   
readMode:.asciz "r"
writeMode:.asciz "w"

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



################# PrintAll e pentru debug purposes only

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
### deschidem in.txt
push $readMode
push $fileIn
call fopen
add $8,%esp
mov %eax,-20(%ebp)




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
#-20=file pointer in.txt
##
push $sf
sub $4,%esp
call fscanf  ##cin>>m (linii)

movb -4(%ebp),%al
addb $2,%al 
movb %al,m
movb %al, %bl
call fscanf  ##cin>>n (coloane)

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


call fscanf  ##cin>>p (puncte vii)

xor %ecx, %ecx
movw -4(%ebp),%cx
movw %cx,p
lea v, %esi
#time to read points
while_st:
    cmp $0,%ecx
    je while_end

    mov %ecx, -8(%ebp)
    call fscanf
    
    movl -4(%ebp), %ebx
    inc %ebx
    xor %eax, %eax
    movb n, %al
    mul %ebx
    mov %eax,%ebx

    call fscanf 
    
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

call fscanf
movb -4(%ebp),%al
movb %al,k
call fclose
add $20,%esp
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

#### tiparim cati vecini avem ->another relic lost to time
#push %eax
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
####acum printam ce mai e la final si gata
##dar intai deschidem fisierul out.txt
push $writeMode
push $fileOut
call fopen
ver3:
add $8,%esp
mov %eax,-32(%ebp)




mov -20(%ebp),%eax
##sub $8,%esp








printfin_i_st:
cmp -12(%ebp),%eax
jge printfin_i_end
mov %eax, -4(%ebp)

xor %ecx,%ecx
movb n,%cl
sub $2,%cl

printfin_j_st:
cmp $0,%ecx
je printfin_j_end
mov %eax,-4(%ebp)
mov %ecx,-8(%ebp)






mov %eax,%ecx
shr $3, %eax
and $7, %ecx
lea v, %esi
add $49,%esi
sub %eax,%esi
mov $0x80,%eax
shr %cl,%eax
and (%esi),%eax
not %ecx
add $8,%ecx
shr %cl,%eax
###Print final si obligatoriu
ver:

push %eax
push $pffinal
sub $4,%esp
call fprintf
push $0
call fflush
ver1:
add $16,%esp


mov -4(%ebp),%eax
inc %eax
mov -8(%ebp),%ecx
dec %ecx
jmp printfin_j_st
printfin_j_end:

movl $newl,-28(%ebp)
sub $12,%esp
call fprintf
push $0
call fflush
add $16,%esp



mov -4(%ebp),%eax
add $3,%eax
jmp printfin_i_st
printfin_i_end:





add $20,%esp
pop %ebp
ret




main:

call Citire
call NextGen



exit:
mov $1, %eax
xor %ebx, %ebx
int $0x80

