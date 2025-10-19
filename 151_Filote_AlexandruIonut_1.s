.data
    memorie: .space 16777216
    nr_ins: .long 0
    nr_instructiune: .long 0
    nr_fisiere_add: .long 0
    descriptor_fisierdel: .long 0
    descriptor_fisier: .long 0
    dimensiune_fisier: .long 0
    lkl: .long -1
    formatafisareimposibil: .asciz "%d: ((0, 0), (0, 0))\n"
    formatcitire: .asciz "%d"
    formatafisareadd: .asciz "%d: ((%d, %d), (%d, %d))\n"
    formatafisareget: .asciz "((%d, %d), (%d, %d))\n"
    formatafisaregetimp: .asciz "((0, 0), (0, 0))\n"
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
        je inserare_matrice
        incl dimensiune_fisier
        inserare_matrice:
            cmpl $1024, dimensiune_fisier
            jg nu_e_posibil
            cmpl $2, dimensiune_fisier
            jl nu_e_posibil
            lea memorie, %edi
            movl $0, %eax
            loop_linie:
                movl $0, %ebx
                movl $0, %ecx
                movl $0, %edx
                movl $1024, %esi
                loop_coloana:
                    addl %eax, %ecx
                    addl %ebx, %ecx
                    cmpl (%edi,%ecx,4), %edx
                    jne reinitializare_indici
                    subl %eax, %ecx
                    subl %ebx, %ecx
                    incl %ecx
                    cmpl dimensiune_fisier, %ecx
                    je inserare
                    cmpl %ecx, %esi
                    jg loop_coloana
                addl $1024,%eax
                cmp $1048576, %eax
                jl loop_linie
            jmp nu_e_posibil
        reinitializare_indici:
            movl $1024, %esi
            subl %eax, %ecx
            subl %ebx, %ecx
            addl %ecx, %ebx
            incl %ebx
            subl %ebx, %esi
            movl $0,%ecx
            jmp loop_coloana
        nu_e_posibil:
            pushl descriptor_fisier
            pushl $formatafisareimposibil
            call printf
            popl %ecx
            popl %ecx
            popl %ecx
            incl %ecx
            jmp citire_add
        inserare:
            lea memorie, %edi
            movl %eax, %edx
            addl %ebx, %edx
            movl $0,%ecx
            loop_inserare:
                addl %ecx, %edx
                movl descriptor_fisier, %esi
                movl %esi, (%edi,%edx,4)
                subl %ecx, %edx
                incl %ecx
                cmpl dimensiune_fisier, %ecx
                jne loop_inserare
            movl $0, %edx
            movl $1024, %esi
            div %esi
            addl %ebx, %ecx
            decl %ecx
            pushl %ecx
            pushl %eax
            pushl %ebx
            pushl %eax
            pushl descriptor_fisier
            pushl $formatafisareadd
            call printf
            popl %edx
            popl %edx
            popl %edx
            popl %ebx
            popl %eax
            popl %ecx
            popl %ecx
            incl %ecx
            jmp citire_add
    exit_add:
        popl %ecx
        incl %ecx
        jmp instructiuni
get:
    movl %ebx, descriptor_fisier
    movl $0,%ecx
    movl $-1024,%eax
    lea memorie, %edi
    loop_linie_get:
        addl $1024,%eax
        cmp $1048576, %eax
        jge iesire_get1
        movl $0,%ecx
        movl $0,%ebx
        indice_stanga:  
            cmpl $1024, %ecx
            jge loop_linie_get
            addl %eax, %ecx
            movl descriptor_fisier, %edx
            cmpl %edx, (%edi,%ecx,4)
            je indice_dreapta
            subl %eax, %ecx
            incl %ecx
            jmp indice_stanga
        indice_dreapta:
            addl %ecx,%ebx
            addl $1024, %eax
            cmp %eax, %ebx
            jge iesire_get
            movl descriptor_fisier, %edx
            cmpl %edx, (%edi,%ebx,4)
            jne iesire_get
            subl $1024, %eax
            subl %ecx, %ebx
            incl %ebx
            jmp indice_dreapta
    iesire_get:
        subl $1024, %eax
        subl %eax, %ecx
        subl %eax, %ebx
        decl %ebx 
        movl $0, %edx
        movl $1024, %esi
        div %esi
        movl $2, %edx
        cmp nr_instructiune, %edx
        je iesire_GET
        pushl %ebx
        pushl %eax
        pushl %ecx
        pushl %eax
        pushl descriptor_fisier
        pushl $formatafisareadd
        call printf
        popl %ecx
        popl %ecx
        popl %ecx
        popl %edx
        popl %ecx
        popl %ebx
        subl %edx, %ebx
        ret
    iesire_get1:
        movl nr_instructiune, %ebx
        movl $2, %edx
        cmp %ebx, %edx
        je iesire_GET1
        pushl descriptor_fisier
        pushl $formatafisareimposibil
        call printf
        popl %ecx
        popl %ecx
        movl $0, %ebx
        ret
    iesire_GET:
        pushl %ebx
        pushl %eax
        pushl %ecx
        pushl %eax
        pushl $formatafisareget
        call printf
        popl %ecx
        popl %ecx
        popl %ecx
        popl %ecx
        popl %ecx
        ret
    iesire_GET1:
        pushl $formatafisaregetimp
        call printf
        popl %ecx
        ret
delete:
    pushl $descriptor_fisierdel
    pushl $formatcitire
    call scanf
    popl %ebx
    popl %ebx
    lea memorie, %edi
    movl $-1, %ecx
    loop_delete:
        incl %ecx
        cmpl $1048576, %ecx
        jge exit_delete
        movl (%edi,%ecx,4),%edx
        cmpl descriptor_fisierdel, %edx
        je stergere 
        cmpl $0, %edx
        je loop_delete
        movl %edx, %ebx
        pushl %ecx
        call get
        popl %ecx
        addl %ebx, %ecx
        jmp loop_delete
    stergere:
        movl $0, %edx
        movl %edx, (%edi,%ecx,4)
        jmp loop_delete
    exit_delete:
        movl $0, %ebx
        popl %ecx
        incl %ecx
        jmp instructiuni
defragmentation:
    lea memorie, %edi
    movl $0, lkl
    movl $-1, %ecx
    loop_defrag:
        incl %ecx
        cmpl $1048576, %ecx
        jge exit_defrag
        cmpl $0, (%edi, %ecx,4)
        je loop_defrag
        movl (%edi, %ecx, 4), %ebx
        movl %ebx, descriptor_fisier
        movl %ecx, %ebx
        loop_secventa:
            movl $0, (%edi,%ebx,4)
            incl %ebx
            movl (%edi,%ebx,4),%eax
            cmpl descriptor_fisier, %eax
            je loop_secventa
        subl %ecx, %ebx
        movl %ebx, dimensiune_fisier
        addl %ebx, %ecx
        decl %ecx
        pushl %ecx
        movl $0, %edx
        movl $1024, %esi
        movl lkl, %eax
        div %esi
        movl %edx, %ebx
        mul %esi
        inserare_matrice_defrag:
            lea memorie, %edi
            loop_linie_defrag:
                movl $0, %ecx
                movl $0, %edx
                movl $1024, %esi
                loop_coloana_defrag:
                    addl %ebx, %ecx
                    cmpl $1024, %ecx
                    jge increment_defrag
                    addl %eax, %ecx
                    cmpl (%edi,%ecx,4), %edx
                    jne reinitializare_indici_defrag
                    subl %eax, %ecx
                    subl %ebx, %ecx
                    incl %ecx
                    cmpl dimensiune_fisier, %ecx
                    je inserare_defrag
                    cmpl %ecx, %esi
                    jg loop_coloana_defrag
                increment_defrag:
                    addl $1024,%eax
                    movl $0, %ebx
                    cmp $1048576, %eax
                    jl loop_linie_defrag
        reinitializare_indici_defrag:
            movl $1024, %esi
            subl %eax, %ecx
            subl %ebx, %ecx
            addl %ecx, %ebx
            incl %ebx
            subl %ebx, %esi
            movl $0,%ecx
            jmp loop_coloana_defrag
        inserare_defrag:
            lea memorie, %edi
            movl %eax, %edx
            addl %ebx, %edx
            movl %edx, lkl
            movl dimensiune_fisier, %esi
            addl %esi, lkl
            movl $0,%ecx
            loop_inserare_defrag:
                addl %ecx, %edx
                movl descriptor_fisier, %esi
                movl %esi, (%edi,%edx,4)
                subl %ecx, %edx
                incl %ecx
                cmpl dimensiune_fisier, %ecx
                jne loop_inserare_defrag
            movl $0, %edx
            movl $1024, %esi
            div %esi
            addl %ebx, %ecx
            decl %ecx
            pushl %ecx
            pushl %eax
            pushl %ebx
            pushl %eax
            pushl descriptor_fisier
            pushl $formatafisareadd
            call printf
            popl %edx
            popl %edx
            popl %edx
            popl %ebx
            popl %eax
            popl %ecx
            popl %ecx
            jmp loop_defrag
    exit_defrag:
    movl $0, %ebx
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
    pop %ebx
    pop %ebx
    
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