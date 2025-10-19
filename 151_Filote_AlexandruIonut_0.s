.data
    nr_ins: .space 4
    nr_instructiune: .space 4
    formatcitire: .asciz "%ld"
    formatafisare: .asciz "%ld: (%ld, %ld)\n"
    formatafisare2: .asciz "%ld: (0, 0)\n"
    formatafisareget: .asciz "(%ld, %ld)\n"
    memorie: .space 16777216
    formatcitire2: .asciz "%ld\n"
    len_vec: .long 0
    nr_fisiere: .space 4
    nr_fisiere_add: .space 4
    descriptor_fisier: .space 4
    dimensiune_fisier: .space 4
.text
call_get:
    pushl $descriptor_fisier
    pushl $formatcitire
    call scanf
    popl %ebx
    popl %ebx
    movl descriptor_fisier, %ebx
    call get
    popl %ecx
    incl %ecx
    jmp instructiuni
add:
    pushl $nr_fisiere_add
    pushl $formatcitire
    call scanf
    popl %ebx
    popl %ebx
    movl $0, %ecx
    citire_add:
        cmp %ecx, nr_fisiere_add
        je exit_add
        pushl %ecx
        pushl $descriptor_fisier
        pushl $formatcitire
        call scanf
        popl %ebx
        popl %ebx
        pushl $dimensiune_fisier
        pushl $formatcitire
        call scanf
        popl %ebx
        popl %ebx
        movl $0, %edx
        movl dimensiune_fisier,%eax
        movl $8, %ebx
        div %ebx
        movl $0,%ebx
        movl %eax, dimensiune_fisier
        cmp %edx, %ebx
        je inserare_vector
        incl dimensiune_fisier
        inserare_vector:
            movl $1024, %edx
            cmpl dimensiune_fisier, %edx
            jl nu_e_posibil
            lea memorie,%edi
            movl $0, %ecx
            movl $0, %eax
            movl $0, %edx
            verificare:
                add %ecx,%eax
                movl $1024, %ebx
                cmp %eax, %ebx
                jle nu_e_posibil
                cmp (%edi,%eax,4),%edx
                jne reinitializare_indici
                sub %ecx,%eax
                incl %ecx
                cmpl %ecx, dimensiune_fisier
                jne verificare
            jmp inserare
            reinitializare_indici:
                incl %eax
                movl $0,%ecx
                jmp verificare
            inserare:  
                movl $0,%ecx
                movl descriptor_fisier,%ebx
                loop_inserare:
                    add %ecx, %eax
                    movl %ebx, (%edi,%eax,4)
                    sub %ecx, %eax
                    incl %ecx
                    cmp %ecx, dimensiune_fisier
                    jne loop_inserare
            add %eax, %ecx
            decl %ecx
            movl %ecx, %ebx
            pushl %ecx
            pushl %eax
            pushl descriptor_fisier
            pushl $formatafisare
            call printf
            popl %ecx
            popl %ecx
            popl %ecx
            popl %ecx
            cmp len_vec, %ebx 
            jle increment
            movl %ebx, len_vec
            incl len_vec
        increment:
            popl %ecx
            incl %ecx
    jmp citire_add
    nu_e_posibil:
        pushl descriptor_fisier
        pushl $formatafisare2
        call printf
        popl %ebx
        popl %ebx
        jmp increment
    exit_add:
        popl %ecx
        incl %ecx
        jmp instructiuni
get:
    movl %ebx, descriptor_fisier
    movl $0,%ecx
    movl $0,%eax
    lea memorie, %edi
    indice_stanga:  
        cmp %ecx, len_vec
        je iesire_get1
        movl descriptor_fisier, %edx
        cmpl %edx, (%edi,%ecx,4)
        je indice_dreapta
        incl %ecx
        jmp indice_stanga
    indice_dreapta:
        add %ecx,%eax
        cmp %eax, len_vec
        je iesire_get
        movl descriptor_fisier, %edx
        cmpl %edx, (%edi,%eax,4)
        jne iesire_get
        sub %ecx, %eax
        incl %eax
        jmp indice_dreapta

    iesire_get:
        movl nr_instructiune,%ebx
        movl $2, %edx
        cmp %ebx, %edx
        je iesire_GET
        decl %eax
        pushl %eax
        pushl %ecx
        pushl descriptor_fisier
        pushl $formatafisare
        call printf
        popl %ecx
        popl %ecx
        popl %ecx
        popl %eax
        jmp exit_get
    iesire_get1:
        
        movl $0,%eax
        movl $0,%ecx
        movl nr_instructiune, %ebx
        movl $2, %edx
        cmp %ebx, %edx
        je iesire_GET1
        pushl %eax
        pushl %ecx
        pushl descriptor_fisier
        pushl $formatafisare
        call printf
        popl %ecx
        popl %ecx
        popl %ecx
        popl %eax
        jmp exit_get
    iesire_GET:
        movl $0,%ebx
        decl %eax
        pushl %eax
        pushl %ecx
        pushl $formatafisareget
        call printf
        popl %ecx
        popl %ecx
        popl %eax
        jmp exit_get
    iesire_GET1:
        movl $0,%ebx
        pushl %eax
        pushl %ecx
        pushl $formatafisareget
        call printf
        popl %ecx
        popl %ecx
        popl %eax
        jmp exit_get
    exit_get:
        subl %ecx, %eax
        ret
delete:
    pushl $descriptor_fisier
    pushl $formatcitire
    call scanf
    popl %ebx
    popl %ebx
    
    movl $-1,%ecx
    lea memorie, %edi
    loop_stergere:
        incl %ecx
        cmp %ecx, len_vec
        je afisare_del
        movl descriptor_fisier, %eax
        cmp %eax, (%edi,%ecx,4)
        jne loop_stergere
        movl $0, (%edi,%ecx,4)
        jmp loop_stergere
    afisare_del:
        lea memorie, %edi
        movl $-1,%ecx
        loop_afisare_del:
            incl %ecx
            cmp %ecx,len_vec
            je exit_del
            movl $0, %ebx
            cmp (%edi,%ecx,4), %ebx
            je loop_afisare_del
            movl (%edi,%ecx,4),%ebx
            pushl %ecx
            call get
            popl %ecx
            add %eax, %ecx
            jmp loop_afisare_del
    exit_del:        
        popl %ecx
        incl %ecx
        jmp instructiuni   
defragmentation:
    movl $0, %ecx
    lea memorie, %edi
    loop_defrag:
        cmp %ecx, len_vec
        jle exit_defrag1
        movl $0, %eax
        cmp (%edi,%ecx,4),%eax
        je rmv
        add $1,%ecx
        jmp loop_defrag
    rmv:
        movl %ecx, %eax
        movl %ecx, %ebx
        pushl %ecx
        add $1,%ebx
        loop_rmv:
            movl len_vec, %ecx
            cmp %ebx, %ecx
            jle exit_rem
            movl (%edi,%ebx,4), %ecx
            movl %ecx, (%edi,%eax,4)
            add $1,%eax
            add $1, %ebx
            jmp loop_rmv
        exit_rem:
            movl $0, (%edi,%eax,4)
            movl %eax, len_vec
            popl %ecx
            subl $1,%ecx
            jmp loop_defrag
    exit_defrag1:
        lea memorie, %edi
        movl $-1,%ecx
        loop_afisare_defrag:
            incl %ecx
            cmp %ecx,len_vec
            je exit_defrag
            movl (%edi,%ecx,4),%ebx
            pushl %ecx
            call get
            popl %ecx
            add %eax, %ecx
            jmp loop_afisare_del
    exit_defrag:        
        popl %ecx
        incl %ecx
        jmp instructiuni   
.global main
main:
    pushl $nr_ins
    pushl $formatcitire
    call scanf
    popl %ebx
    popl %ebx
    movl $0, %ecx
instructiuni:
    cmp %ecx, nr_ins
    je exit
    pushl %ecx

    pushl $nr_instructiune
    pushl $formatcitire
    call scanf
    popl %ebx
    popl %ebx
    
    
    movl $1, %eax
    cmp nr_instructiune, %eax
    je add

    movl $2, %eax
    cmp nr_instructiune, %eax
    je call_get

    movl $3, %eax
    cmp nr_instructiune, %eax
    je delete

    movl $4, %eax
    cmp nr_instructiune, %eax
    je defragmentation
exit:
    pushl $0
    call fflush
    popl %eax
    movl $1, %eax
    xorl %ebx,%ebx
    int $0x80