%include "includes/io.inc"

extern getAST
extern freeAST

section .bss
    ; La aceasta adresa, scheletul stocheaza radacina arborelui
    root: resd 1
    array: resd 500 ;am salvat aici niste vectori de care ma folosesc in cod
    reversed_array: resd 500 ;vector pentru reversed array
    res: resd 500 ;un vector "rezerva" care o sa il folosesc mai jos (acesta va contine int-uri)

section .text

global main
  
traverse: ;functia de traversare a arborelui
    push ebp
    mov ebp, esp
    mov ebx, dword[ebp + 8]
    
    cmp ebx, 0
    je return
    mov edx, [ebx]

left: ;de aici se va apela recursiv pentru copilul stang
    mov dword[array + ecx * 4], edx  ;nu uit sa introduc in array nodurile
    inc ecx  
    push dword[ebx + 4]
    call traverse

right: ;aici se va apela recursiv pentru copilul drept
    mov ebx, dword[ebp + 8]
    push dword[ebx + 8]
    call traverse
    jmp return
    
return: ;functie care iese
    leave
    ret
    
atoi: ;functie care o sa imi transforme numarele din char in int
    push ebp
    mov ebp, esp
    
    mov esi, [ebp + 8]
    xor edx, edx
    mov edx, esi
    mov edx, [edx]
    cmp edx, '+' ;prefer sa las in char
    je jump
    cmp edx, '-'
    je jump
    cmp edx, '/'
    je jump
    cmp edx, '*'
    je jump
    
make_the_int: ;AICI VOR INTRA NUMAI NUMERLE
    ;verific numarul ca sa il transform in int
    cmp byte[esi], '-' 
    je negative
    
    mov ch, 0 ;set a flag 0
    jmp convert
    
    negative:
        mov ch, 1 ;set un "flag" ca sa imi dau seama ce numar e negativ
        inc esi
    convert:
        mov al, [esi]
        sub al, 48
        movzx eax, al ;eax unsigned
        mov ebx, 10
    next:
        inc esi 
        
    cmp byte[esi], 0
    je FIN
        
    mul ebx
    mov dl, [esi]
    sub dl, 48
    movzx edx, dl ;
    add eax, edx ;retin rezultatul in eax
    jmp next
    
    FIN:
        cmp ch, 1
        je changeToNeg
        jmp result
    changeToNeg:
        neg eax ;transform numarul in negativ
    result:
        mov ebx, eax
        ;ma folosesc de edi ca sa ma asigur ca pun pe pozitii bune
        mov dword[res + edi * 4], ebx ;introduc numere ca int-uri in vectorul res
        inc edi
        jmp return

jump:
    mov dword[res + edi * 4], edx ;introduc  c char-uri in vectorul res
    inc edi
    jmp return

main:
    mov ebp, esp; for correct debugging
    ; NU MODIFICATI
    push ebp
    mov ebp, esp
    
    ; Se citeste arborele si se scrie la adresa indicata mai sus
    call getAST
    mov [root], eax
    
    ; Implementati rezolvarea aici:
    push eax ;trmit root
    call traverse  ;apelez functia care imi va traversa arborele si imi va pune nodurile intr-un array   

    xor edx, edx
    mov ecx, 0
    
array_length: ;aflu lungimea vectorului 
    mov edx, dword[array + ecx * 4]
    cmp edx, 0
    je done
    push edx
    inc ecx
    jmp array_length

done:
    dec ecx
    mov eax, ecx ;copie la lungimea vectorului ca sa ma sigur
    mov edx, 0
    xor eax, eax
    mov ecx, 0
    
STACK: ;pun in stiva array
    mov edx, dword[array + ecx * 4]
    cmp edx, 0
    je stop
    see:
        inc ecx
        dec eax
        push edx
        cmp ecx, -1
        jne STACK

stop:
    mov ebx, 0

reverse: ;scot din stiva si pun in reversed array 
    pop eax
    mov dword[reversed_array + ebx * 4], eax
    inc ebx
    dec ecx
    cmp ecx, 0
    jne reverse 

    mov ebx, 0
    mov ecx, 0  ;ma asigur ca pornesc de la primul element 

finale: ;functia care o sa imi transforme in int si o sa imi faca calcule
    mov edx, dword[reversed_array + ecx * 4]
    cmp edx, 0
    je OUT 
    push edx
    call atoi ;apelez functia atoi cu elementul curent din reversed array
    inc ecx
    cmp ecx, 256 ;la numar negativ mi se adauga in ecx 256 si nu imi convine
    jge continue
print:
    jmp finale
continue:
    sub ecx, 256
    jmp print

OUT:
    xor ecx, ecx
    mov ecx, 0

calculus: ;functia aceasta imi va face calculele
    mov eax, dword[res + ecx*4] ;scot din res valorile obtinute si le compar
    cmp eax, 0 ;in functie de ce imi iese o sa sara la operatia necesara de efectuat
    je finish
    cmp eax, '+'
    je sum
    cmp eax, '-'
    je dif
    cmp eax, '/'
    je imp
    cmp eax, '*'
    je inm
    inc ecx
    push eax ;adaug intr-un stack ca sa imi fie mai usor cu operatiile
cont: ;va continua sa parcurga res
    jmp calculus

sum: ;pentru adunare
    pop ebx  ;scot cate doua elemente (asa procedez la fiecare)
    pop edx 
    add ebx, edx
    push ebx ;introduc rezultatul inapoi in stack (la fel procedez si la celelalte
    inc ecx
    jmp cont
dif: ;pentru scadere
    pop ebx
    pop edx
    sub ebx, edx
    push ebx
    inc ecx
    jmp cont
inm: ;pentru inmultire
    pop edx
    pop edx
    imul ebx, edx
    push ebx
    inc ecx
    jmp cont
imp: ;pentru impartire
    xor edx, edx
    xor eax, eax
    pop eax
    pop ebx
    div ebx

    inc ecx
    push eax
    jmp cont
    
finish: 
    POP EAX
    PRINT_DEC 4, EAX ;se afiseaza rezultatul
    
    ; NU MODIFICATI
    ; Se elibereaza memoria alocata pentru arbore
    push dword [root]
    call freeAST
    
    xor eax, eax
    leave
    ret
