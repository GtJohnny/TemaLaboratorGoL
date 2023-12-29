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
scanMesajNormal:.asciz "%s"
scanMesajHex:.asciz "%*3c%s"
printMesajNormal:.asciz "%s\n"
pHex1:.asciz "0x"
pHex2:.asciz "%X"
mesVechi:.space 24
####################################TASK 0x01



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
verif1:

### mai e de citit doar mesajul(0) sau codul hex(1)
push %eax
push $mesVechi
cmp $1,%eax
je CitireCr1
##caz0:
    push $scanMesajNormal
    jmp doneCitireCr1
CitireCr1:
    push $scanMesajHex
doneCitireCr1:
call scanf
verif2:
add $8,%esp
pop %eax
cmp $1,%eax
jne SmallConvert
    ###well din sir de caractere facem numar daca e hexa
    lea mesVechi,%esi
    xor %ecx,%ecx
    xor %eax,%eax
    xor %ebx,%ebx
    CNV:
    verif3:
        cmpb $0,(%esi,%ecx,1)
        je SmallConvert
        movb (%esi,%ecx,1),%bl
        cmpb $65,%bl
        jl red48
        ##red 55
            subb $55,%bl
            jmp s1_55
        red48:
            subb $48,%bl
        s1_55:

        shlb $4,%bl
        movb %bl,(%esi,%eax,1)
        inc %ecx

        movb (%esi,%ecx,1),%bl
        cmpb $65,%bl
        jl red2_48
        ##red 55
            subb $55,%bl
            jmp s2_55
        red2_48:
            subb $48,%bl
        s2_55:
        addb %bl,(%esi,%eax,1)

        inc %eax
        inc %ecx
        jmp CNV
SmallConvert:
movb $0,(%esi,%eax,1)


pop %ebp
ret

###############
#-0(%ebp)->
#-4(%ebp)->vechi %ebx
#-8(%ebp)->marimea matricei pe biti (3+2)*(4+2)=30
#-12(%ebp)->counter %ecx
#-16(%ebp)->counter bytes mesaj %edx
#-20(%ebp)->counter 0-8
###############
Decriptare:
push %ebp
mov %esp,%ebp
push %ebx
    xor %eax,%eax
    movb n,%al
    movb m,%bl
    mulb %bl
    push %eax
    xor %ecx,%ecx
    xor %edx,%edx
    push %ecx
    push %ecx
    push %ecx
    lea mesVechi,%edi
    lea v,%esi
    decr_st0:
        xor %ebx,%ebx
        cmpb $0,(%edi,%edx,1)
        je decr_end0
        mov %edx,-16(%ebp)
        decr_st1:
            cmp -8(%ebp),%ecx
            jl no_concat
            xor %ecx,%ecx
            no_concat:
            mov %ecx,-12(%ebp)
            mov %ecx,%eax
            ##
            shr $3,%eax
            not %eax
            inc %eax
            movb 49(%esi,%eax,1),%al
            and $7,%ecx
            movl $0x80,%edx
            shrb %cl,%dl
            andb %al,%dl
            





            not %ecx
            add -20(%ebp),%ecx
            inc %ecx
            cmp $0,%ecx
            jg right_shift
                
                not %ecx
                inc %ecx
                shlb %cl,%dl
                jmp if_0
            ##$$
                right_shift:
                shr %cl,%edx
            verif:
            if_0:
            add %dl,%bl

            mov -12(%ebp),%ecx
            inc %ecx

            incl -20(%ebp)
            andl $7,-20(%ebp)
            jz decr_end1

            jmp decr_st1
        decr_end1:
        mov -16(%ebp),%edx

        xorb %bl, (%edi,%edx,1)



        inc %edx
        jmp decr_st0
    decr_end0:
    add $16,%esp


    #### print mesaj decriptat
    movb crypt,%al
    cmpb $1,%al
    je pfnorm
        push $pHex1
        call printf
        push $0
        call fflush
        add $8,%esp
        
        lea mesVechi,%esi
        push $0
        lp_hex_st:
            mov -8(%ebp),%ecx
            xor %eax,%eax
            movb (%esi,%ecx,1),%al
            cmp $0,%eax
            je lp_hex
            push %eax
            push $pHex2
            ver2:
            call printf
            push $0
            call fflush
            ver1:
            add $12,%esp
            incl -8(%ebp)
            jmp lp_hex_st
        lp_hex:
        add $4,%esp

        push $0xa
        push %esp
        call printf
        push $0
        call fflush
        add $12,%esp



        jmp cntpf
    pfnorm:
        push $mesVechi
        push $printMesajNormal
        call printf
        pushl $0
        call fflush
        add $12,%esp
    cntpf:







pop %ebx
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

call Decriptare



pop %ebp
ret




main:

call Citire
call NextGen

exit:
mov $1, %eax
xor %ebx, %ebx
int $0x80

