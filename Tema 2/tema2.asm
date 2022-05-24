%include "include/io.inc"

extern atoi
extern printf
extern exit

; Functions to read/free/print the image.
; The image is passed in argv[1].
extern read_image
extern free_image
; void print_image(int* image, int width, int height);
extern print_image

; Get image's width and height.
; Store them in img_[width, height] variables.
extern get_image_width
extern get_image_height

section .data
	use_str db "Use with ./tema2 <task_num> [opt_arg1] [opt_arg2]", 10, 0
        
section .bss
    task:       resd 1
    img:        resd 1
    img_width:  resd 1
    img_height: resd 1

section .texts
bruteforce_singlebyte_xor: ;functie pentru rezolvarea primmului task
    push ebp
    mov ebp, esp

    xor eax, eax ;cheia
        
    xor_key:
        xor ebx, ebx ; coloana
        xor cx, cx ; linia
        mov esi, [ebp + 8] ;imaginea
        
    find_revient:
        mov edx, [esi+ebx*4]
        xor edx, eax ;xorul
        cmp edx, 'r' ;caut cuvantul cheie "revient"
        jne next_character
        mov edx, [esi + (ebx + 1) * 4]
        xor edx, eax
        cmp edx, 'e'
        jne next_character
        mov edx, [esi + (ebx + 2) * 4]
        xor edx, eax
        cmp edx, 'v'
        jne next_character
        mov edx, [esi + (ebx + 3) * 4]
        xor edx, eax
        cmp edx, 'i'
        jne next_character
        mov edx, [esi + (ebx + 4) * 4]
        xor edx, eax
        cmp edx, 'e'
        jne next_character    
        mov edx, [esi + (ebx + 5) * 4]
        xor edx, eax
        cmp edx, 'n'
        jne next_character
        mov edx, [esi + (ebx + 6) * 4]
        xor edx, eax
        cmp edx, 't'
        jne next_character
    
        jmp print_string
        
    next_character: ;se trece la urmatorul element al matricei
        mov edx, [esi + (ebx + 1) * 4]
        cmp ebx, [img_width]
        jge next_line 
        inc ebx
        jmp find_revient
    
    next_line: ;se trece la urmatoarea linie a matricei
        xor ebx, ebx
        cmp cx, [img_height]
        jge next_key
        inc cx ;maresc numarul de linii
        xor edi,edi
        mov edi,eax ;mut cheia momentan
        xor eax,eax
        mov eax,4
        xor edx,edx
        mov ebx, [img_width]
        mul ebx
        add esi,eax 
        mov eax,edi ;recapat cheia
        xor edi, edi
        mov edi, esi ;salvez inceputul urmatoarei linii din matrice
        xor ebx, ebx
        jmp find_revient
    
    next_key: ;trec la urmatoarea cheie
        inc eax
        jmp xor_key
    
    print_string:
        cmp dword[task], 1 ;doresc sa ma folsesc de functia aceasta si pt task 2
        jne task2
        xor ebx, ebx
        mov ebx, 0
        jmp print
        
    print: ;printez mesajul descoperit
        mov edx, [edi + ebx * 4]
        xor edx, eax
        cmp edx, 0
        je print_key_line
        PRINT_CHAR edx
        cmp ebx, [img_width]
        jge print_key_line
        inc ebx
        jmp print
        
    print_key_line: ;printez linia si cheia
        NEWLINE    
        PRINT_UDEC 4, eax
        NEWLINE
        PRINT_UDEC 4, cx

        leave
        ret   
        
task2: ;functie pentru rezolvarea celui de-al doilea task
    push ecx ;linie revient (o salvez pe stiva ca sa ma asigur ca nu o pierd)
    xor ecx, ecx
    mov edi, eax ;mut in edi cheia originala
       
    mov eax, [img_width]
    mov ebx, [img_height]
    mul ebx ;aflu numarul total de elemente
    mov ecx, eax
       
    xor eax, eax
    xor ebx, ebx ;coloanele
    xor edx, edx
    mov esi, [img] 
       
    xor_original_key: ;aplic cheia originala pe toata matricea
         mov eax, [esi + ebx * 4]
         xor eax, edi
         xor [esi + ebx * 4], edi ;modific elementul din imagine
         xor eax, eax
         inc ebx
         cmp ebx, ecx
         jle xor_original_key
         jmp message
           
    message:
         pop ecx
         inc cx
         xor ebx, ebx
         mov esi, [img]
         jmp find_line
         
    find_line:
         cmp cx, 0
         je the_phrase
         
         xor eax, eax
         mov eax,4
         xor edx,edx
         mov ebx, [img_width]
         mul ebx
         add esi,eax 
         xor eax, eax
         xor ebx, ebx
         dec cx
         jmp find_line
            
    the_phrase: ;introduc mesajul in linia necesara
         mov dword[esi], 'C'
         mov dword[esi + (ebx + 1) * 4], 39 ;codul ascii pt apostrof
         mov dword[esi + (ebx + 2) * 4], 'e'
         mov dword[esi + (ebx + 3) * 4], 's'
         mov dword[esi + (ebx + 4) * 4], 't'
         mov dword[esi + (ebx + 5) * 4], ' '
         mov dword[esi + (ebx + 6) * 4], 'u'
         mov dword[esi + (ebx + 7) * 4], 'n'
         mov dword[esi + (ebx + 8) * 4], ' '
         mov dword[esi + (ebx + 9) * 4], 'p'
         mov dword[esi + (ebx + 10) * 4], 'r'
         mov dword[esi + (ebx + 11) * 4], 'o'
         mov dword[esi + (ebx + 12) * 4], 'v'
         mov dword[esi + (ebx + 13) * 4], 'e'
         mov dword[esi + (ebx + 14) * 4], 'r'
         mov dword[esi + (ebx + 15) * 4], 'b'
         mov dword[esi + (ebx + 16) * 4], 'e'
         mov dword[esi + (ebx + 17) * 4], ' '
         mov dword[esi + (ebx + 18) * 4], 'f'
         mov dword[esi + (ebx + 19) * 4], 'r'
         mov dword[esi + (ebx + 20) * 4], 'a'
         mov dword[esi + (ebx + 21) * 4], 'n'
         mov dword[esi + (ebx + 22) * 4], 'c'
         mov dword[esi + (ebx + 23) * 4], 'a'
         mov dword[esi + (ebx + 24) * 4], 'i'
         mov dword[esi + (ebx + 25) * 4], 's'
         mov dword[esi + (ebx + 26) * 4], '.'
         mov dword[esi + (ebx + 27) * 4], 0x0 ;terminatorul de sir
         jmp new_key

    new_key: ;calculez noua cheie dupa formula data in enunt
         mov eax, edi
         mov edx, 2
         mul edx
         add eax, 3
         mov ecx, 5
         div ecx
         sub eax, ecx
         mov esi, [img] ;doresc sa incep de la inceputul imaginii
         mov edi, eax
         xor ebx, ebx
         xor eax, eax
         xor edx, edx
         
         mov eax, [img_width]
         mov ecx, [img_height]
         mul ecx
         mov ecx, eax

         xor ebx, ebx
         inc edi
        
     xor_for_column:
         mov edx, [esi + ebx * 4]
         xor edx, edi
         mov [esi + ebx * 4], edx
         inc ebx
         cmp ebx, ecx
         jle xor_for_column
         jmp get_image
            
     get_image:
         mov esi, [img]
         push dword[img_height]
         push dword[img_width]
         push esi
         call print_image
          
         leave
         ret
             
    
morse_encrypt:  ;functie pentru rezolvarea celui de-al treilea task
    push ebp
    mov ebp, esp  
       
    mov esi, [ebp + 8] ;imaginea
    mov ebx, [ebp + 12] ;mesajul
    mov eax, [ebp + 16] ;indexul
       
    xor ecx, ecx ;coloana
    mov edi, eax ;mut indexul in edi       
    
    implementation: ;compar fiecare litera din mesaj
        cmp byte[ebx], 'A'
        je A 
        cmp byte[ebx], 'B'
        je B
        cmp byte[ebx], 'C'
        je C
        cmp byte[ebx], 'D'
        je D
        cmp byte[ebx], 'E'
        je E
        cmp byte[ebx], 'F'
        je F
        cmp byte[ebx], 'G'
        je G
        cmp byte[ebx], 'H'
        je H
        cmp byte[ebx], 'I'
        je I
        cmp byte[ebx], 'J'
        je J
        cmp byte[ebx], 'K'
        je K
        cmp byte[ebx], 'L'
        je L
        cmp byte[ebx], 'M'
        je M
        cmp byte[ebx], 'N'
        je N
        cmp byte[ebx], 'O'
        je O
        cmp byte[ebx], 'P'
        je P
        cmp byte[ebx], 'Q'
        je Q
        cmp byte[ebx], 'R'
        je R
        cmp byte[ebx], 'S'
        je S
        cmp byte[ebx], 'T'
        je T
        cmp byte[ebx], 'U'
        je U
        cmp byte[ebx], 'V'
        je V
        cmp byte[ebx], 'W'
        je W
        cmp byte[ebx], 'X'
        je X
        cmp byte[ebx], 'Y'
        je Y
        cmp byte[ebx], 'Z'
        je Z
        cmp byte[ebx], '1'
        je One
        cmp byte[ebx], '2'
        je Two
        cmp byte[ebx], '3'
        je Three
        cmp byte[ebx], '4'
        je Four
        cmp byte[ebx], '5'
        je Five
        cmp byte[ebx], '6'
        je Six
        cmp byte[ebx], '7'
        je Seven
        cmp byte[ebx], '8'
        je Eight
        cmp byte[ebx], '9'
        je Nine
        cmp byte[ebx], '0'
        je Zero
        cmp byte[ebx], ','
        je Virgula
        
    A:  ;de aici in jos, in functie de ce litera e am sa transform in cod morse
        mov dword[esi + edi * 4], '.'
        inc edi
        mov dword[esi + edi * 4], '-'
        inc edi
        jmp final
        
        
    B:
        mov dword[esi + edi * 4], '-'
        inc edi
        mov dword[esi + edi * 4], '.'
        inc edi
        mov dword[esi + edi * 4], '.'
        inc edi
        mov dword[esi + edi * 4], '.'
        inc edi
        jmp final
    
    C:
       mov dword[esi + edi * 4], '-'
       inc edi
       mov dword[esi + edi * 4], '.'
       inc edi
       mov dword[esi + edi * 4], '-'
       inc edi
       mov dword[esi + edi * 4], '.'
       inc edi
       jmp final 
     
    D:
       mov dword[esi + edi * 4], '-'
       inc edi
       mov dword[esi + edi * 4], '.'
       inc edi
       mov dword[esi + edi * 4], '.'
       inc edi
       jmp final
    
    E:
       mov dword[esi + edi * 4], '.'
       inc edi
       jmp final
        
    F:
        mov dword[esi + edi * 4], '.'
        inc edi
        mov dword[esi + edi * 4], '.'
        inc edi
        mov dword[esi + edi * 4], '-'
        inc edi
        mov dword[esi + edi * 4], '.'
        inc edi
        jmp final
        
    G:
        mov dword[esi + edi * 4], '-'
        inc edi
        mov dword[esi + edi * 4], '-'
        inc edi
        mov dword[esi + edi * 4], '.'
        inc edi
        jmp final
     
    H:
        mov dword[esi + edi * 4], '.'
        inc edi
        mov dword[esi + edi * 4], '.'
        inc edi
        mov dword[esi + edi * 4], '.'
        inc edi
        mov dword[esi + edi * 4], '.'
        inc edi
        jmp final
    I:
        mov dword[esi + edi * 4], '.'
        inc edi
        mov dword[esi + edi * 4], '.'
        inc edi
        jmp final
     
    J:
        mov dword[esi + edi * 4], '.'
        inc edi
        mov dword[esi + edi * 4], '-'
        inc edi
        mov dword[esi + edi * 4], '-'
        inc edi
        mov dword[esi + edi * 4], '-'
        inc edi
        jmp final
        
    K:
        mov dword[esi + edi * 4], '-'
        inc edi
        mov dword[esi + edi * 4], '.'
        inc edi
        mov dword[esi + edi * 4], '-'
        inc edi
        jmp final
        
    L:
        mov dword[esi + edi * 4], '.'
        inc edi
        mov dword[esi + edi * 4], '-'
         inc edi
        mov dword[esi + edi * 4], '.'
        inc edi
        mov dword[esi + edi * 4], '.'
        inc edi
        jmp final
        
    M:
        mov dword[esi + edi * 4], '-'
        inc edi
        mov dword[esi + edi * 4], '-'
        inc edi
        jmp final
        
    N:
        mov dword[esi + edi * 4], '-'
        inc edi
        mov dword[esi + edi * 4], '.'
        inc edi
        jmp final
        
    O:
        mov dword[esi + edi * 4], '-'
        inc edi
        mov dword[esi + edi * 4], '-'
        inc edi
        mov dword[esi + edi * 4], '-'
        inc edi
        jmp final
    
    P:
        mov dword[esi + edi * 4], '.'
        inc edi
        mov dword[esi + edi * 4], '-'
        inc edi
        mov dword[esi + edi * 4], '-'
        inc edi
        mov dword[esi + edi * 4], '.'
        inc edi
        jmp final
        
    Q:
        mov dword[esi + edi * 4], '-'
        inc edi
        mov dword[esi + edi * 4], '-'
        inc edi
        mov dword[esi + edi * 4], '.'
        inc edi
        mov dword[esi + edi * 4], '-'
        inc edi
        jmp final
        
     R:
        mov dword[esi + edi * 4], '.'
        inc edi
        mov dword[esi + edi * 4], '-'
        inc edi
        mov dword[esi + edi * 4], '.'
        inc edi
        jmp final
        
     S:
        mov dword[esi + edi * 4], '.'
        inc edi
        mov dword[esi + edi * 4], '.'
        inc edi
        mov dword[esi + edi * 4], '.'
        inc edi
        jmp final
        
     T:
        mov dword[esi + edi * 4], '-'
        inc edi
        jmp final
        
     U: 
        mov dword[esi + edi * 4], '.'
        inc edi
        mov dword[esi + edi * 4], '.'
        inc edi
        mov dword[esi + edi * 4], '-'
        inc edi
        jmp final
        
     V:
        mov dword[esi + edi * 4], '.'
        inc edi
        mov dword[esi + edi * 4], '.'
        inc edi
        mov dword[esi + edi * 4], '.'
        inc edi
        mov dword[esi + edi * 4], '-'
        inc edi
        jmp final
        
     W:
        mov dword[esi + edi * 4], '.'
        inc edi
        mov dword[esi + edi * 4], '-'
        inc edi
        mov dword[esi + edi * 4], '-'
        inc edi
        jmp final
        
     X:
        mov dword[esi + edi * 4], '-'
        inc edi
        mov dword[esi + edi * 4], '.'
        inc edi
        mov dword[esi + edi * 4], '.'
        inc edi
        mov dword[esi + edi * 4], '-'
        inc edi
        jmp final
     
     Y:
        mov dword[esi + edi * 4], '-'
        inc edi
        mov dword[esi + edi * 4], '.'
        inc edi
        mov dword[esi + edi * 4], '-'
        inc edi
        mov dword[esi + edi * 4], '-'
        inc edi
        jmp final
        
     Z:
        mov dword[esi + edi * 4], '-'
        inc edi
        mov dword[esi + edi * 4], '-'
        inc edi
        mov dword[esi + edi * 4], '.'
        inc edi
        mov dword[esi + edi * 4], '.'
        inc edi
        jmp final
        
    One:
        mov dword[esi + edi * 4], '.'
        inc edi
        mov dword[esi + edi * 4], '-'
        inc edi
        mov dword[esi + edi * 4], '-'
        inc edi
        mov dword[esi + edi * 4], '-'
        inc edi
        mov dword[esi + edi * 4], '-'
        inc edi
        jmp final
        
    Two:
        mov dword[esi + edi * 4], '.'
        inc edi
        mov dword[esi + edi * 4], '.'
        inc edi
        mov dword[esi + edi * 4], '-'
        inc edi
        mov dword[esi + edi * 4], '-'
        inc edi
        mov dword[esi + edi * 4], '-'
        inc edi
        jmp final
        
    Three:
        mov dword[esi + edi * 4], '.'
        inc edi
        mov dword[esi + edi * 4], '.'
        inc edi
        mov dword[esi + edi * 4], '.'
        inc edi
        mov dword[esi + edi * 4], '-'
        inc edi
        mov dword[esi + edi * 4], '-'
        inc edi
        jmp final
        
    Four:
        mov dword[esi + edi * 4], '.'
        inc edi
        mov dword[esi + edi * 4], '.'
        inc edi
        mov dword[esi + edi * 4], '.'
        inc edi
        mov dword[esi + edi * 4], '.'
        inc edi
        mov dword[esi + edi * 4], '-'
        inc edi
        jmp final
        
    Five:
        mov dword[esi + edi * 4], '.'
        inc edi
        mov dword[esi + edi * 4], '.'
        inc edi
        mov dword[esi + edi * 4], '.'
        inc edi
        mov dword[esi + edi * 4], '.'
        inc edi
        mov dword[esi + edi * 4], '.'
        inc edi
        jmp final
        
    Six:
        mov dword[esi + edi * 4], '-'
        inc edi
        mov dword[esi + edi * 4], '.'
        inc edi
        mov dword[esi + edi * 4], '.'
        inc edi
        mov dword[esi + edi * 4], '.'
        inc edi
        mov dword[esi + edi * 4], '.'
        inc edi
        jmp final
    
    Seven:
        mov dword[esi + edi * 4], '-'
        inc edi
        mov dword[esi + edi * 4], '-'
        inc edi
        mov dword[esi + edi * 4], '.'
        inc edi
        mov dword[esi + edi * 4], '.'
        inc edi
        mov dword[esi + edi * 4], '.'
        inc edi
        jmp final
        
    Eight:
        mov dword[esi + edi * 4], '-'
        inc edi
        mov dword[esi + edi * 4], '-'
        inc edi
        mov dword[esi + edi * 4], '-'
        inc edi
        mov dword[esi + edi * 4], '.'
        inc edi
        mov dword[esi + edi * 4], '.'
        inc edi
        jmp final   
    
    Nine:
        mov dword[esi + edi * 4], '-'
        inc edi
        mov dword[esi + edi * 4], '-'
        inc edi
        mov dword[esi + edi * 4], '-'
        inc edi
        mov dword[esi + edi * 4], '-'
        inc edi
        mov dword[esi + edi * 4], '.'
        inc edi
        jmp final
        
     Zero:
        mov dword[esi + edi * 4], '-'
        inc edi
        mov dword[esi + edi * 4], '-'
        inc edi
        mov dword[esi + edi * 4], '-'
        inc edi
        mov dword[esi + edi * 4], '-'
        inc edi
        mov dword[esi + edi * 4], '-'
        inc edi
        jmp final   
     
     Virgula:
        mov dword[esi + edi * 4], '-'
        inc edi
        mov dword[esi + edi * 4], '-'
        inc edi
        mov dword[esi + edi * 4], '.'
        inc edi
        mov dword[esi + edi * 4], '.'
        inc edi
        mov dword[esi + edi * 4], '-'
        inc edi
        mov dword[esi + edi * 4], '-'
        inc edi
        jmp final
        
    final:
        cmp byte[ebx + 1], 0 ;verific ca nu cumva sa nu fie ultima litera din mesaj
        jne space
        cmp byte[ebx + 1], 0 
        je image    
          
    space:
        mov dword[esi + edi * 4], ' '
        inc edi
        inc ebx
        jmp implementation        
   
    image: 
        mov dword[esi + edi * 4], 0x0 ;introduc terminatorul de sir

        push dword[img_height]
        push dword[img_width]
        push dword[img]
        call print_image 
        
        leave
        ret

lsb_encode: ;functie pt task 4
    push ebp
    mov ebp, esp
    
    mov esi, [img] ;imaginea
    mov ebx, [ebp + 12] ;mesajul
    mov eax, [ebp + 16] ;indexul
    mov edi, eax ; copie la index
    mov eax, [ebp + 12] ; copie la mesaj
    
    dec edi
    xor ecx, ecx
        
    find_the_finish:
    cmp byte[ebx], 0
    je put_the_end
    
    bit_by_bit:      
        cmp ecx, 8
        je next_char
        shl byte[ebx], 1 
        jnc zero
        jc one

        zero:
            push ecx
            xor ecx, ecx
            
            mov ecx, [esi + edi * 4]
            shr ecx, 1
            jnc par0
            jc impar0
            
            impar0:
                sub dword[esi + edi * 4], 1 ;scad 2 la puterea 0                
            
        par0: ;cand am par nu doresc sa fac modificari
            pop ecx
            inc ecx
            inc edi
            jmp bit_by_bit 
            
        one:
            push ecx
            xor ecx, ecx
            
            mov ecx, [esi + edi * 4]
            shr ecx, 1
            jnc par1
            jc impar1
            
            par1:
                add dword[esi + edi * 4], 1 ;adun 2 la puterea 0
                
        impar1: ;nu doresc sa fac modificari
            pop ecx
            inc ecx
            inc edi
            jmp bit_by_bit
            
    next_char: ;se va trece la urmatorul caracter din mesaj
        inc eax
        mov ebx, eax
        xor ecx, ecx
        jmp find_the_finish
    
    put_the_end: ;voi introduce terminatorul de sir
        xor ebx, ebx
        
        introduce:
            cmp ebx, 8
            je hidden
            xor ecx, ecx
            
            mov ecx, [esi + edi * 4]
            shr ecx, 1
            jnc par
            jc impar
            
            impar:
                sub dword[esi + edi * 4], 1 ;scad 2 la puterea 0
            
        par:
            inc ebx
            inc edi
            jmp introduce
            
   hidden:
        push dword[img_height]
        push dword[img_width]
        push dword[img]
        call print_image
        
        leave
        ret

lsb_decode: ;functie pt rezolvarea taskului 5
    push ebp
    mov ebp, esp
    
    mov esi, [ebp + 8] ;imaginea
    mov ebx, [ebp + 12] ;indexul
    mov edi, ebx ;copie la index
    
    xor eax, eax
    xor ebx, ebx
    xor ecx, ecx
    xor edx, edx
    dec edi
    mov ebx, 7
    
    take_the_bit:
        cmp ebx, 0
        jl next_octet
        mov eax, [esi + edi * 4]
        shr eax, 1
        jnc bit_zero
        jc bit_one
        
        bit_zero:
            cmp ecx, 7
            je stop
            dec ebx
            inc edi
            inc ecx
            jmp take_the_bit
            
        bit_one:
            xor ecx, ecx ;transformi in 0
            mov ecx, ebx ;salvez puterea lui 2
            push edx ;ca sa salvez suma
            xor edx, edx
            mov eax, 1
            
            power_of_two: ;transform in zecimal
                cmp ebx, 0
                je out_power
                mov edx, 2
                mul edx
                dec ebx
                jmp power_of_two
                
            out_power:
                pop edx
                add edx, eax
                mov ebx, ecx ;restaurez puterea lui 2
                xor ecx, ecx
                dec ebx
                inc edi
                jmp take_the_bit
    
    next_octet: ;iau urmatorii 8 biti pe care ii transform in zecimal
        PRINT_CHAR edx
        mov ebx, 7
        xor ecx, ecx
        xor edx, edx
        xor eax, eax
        jmp take_the_bit
        
    stop: ;cand va intalni terminatorul de sir va iesi din functie
        leave
        ret

blur: ;functie pt rezolvarea taskului 6
    push ebp
    mov ebp, esp
    
    xor eax, eax ;aici voi tine minte rezultatele
    mov esi, [ebp + 8]
    mov ecx, [img_width]
    sub ecx, 2 ;va tine cont de numarul de coloane
    mov edi, [img_width]
    mov ebx, [img_width]
    sub dword[img_height], 2 ;am grija sa evit prima linia si ultima
    inc edi ;ca sa nu fie elementul de inceput

    new_value:
        cmp dword[img_height], 0
        jle put_new_values
        cmp ecx, 0
        jle calculate_next_line
        xor eax, eax
        xor edx, edx
        mov eax, [esi + edi * 4] ;elementul curent
        
        add eax, [esi + (edi - 1) * 4] ;elementul precedent
        
        add eax, [esi + (edi + 1) * 4] ;elementul urmator
        
        push edi ;ca sa nu pierd pozitia elementului curent
        sub edi, ebx
        add eax, [esi + edi * 4] ; elementul de deasupra
        pop edi
        
        push edi
        add edi, ebx
        add eax, [esi + edi * 4] ;elementul de dedesubt
        pop edi
        
        push ebx ;ca sa nu pierd numarul de coloane
        xor ebx, ebx
        mov ebx, 5
        div ebx
        xor ebx, ebx
        pop ebx

        inc edi
        dec ecx
        push eax
        jmp new_value
        
    calculate_next_line: ;trec la urmatoarea linia avand grija sa ignor primul element
        add edi, 2
        dec dword[img_height]
        mov ecx, [img_width]
        sub ecx, 2
        jmp new_value          

    put_new_values:
        sub edi, 3 ;am grija sa ma duc pe ultima pozitie in care s-a calculat ultima valoare
        mov ecx, [img_width]
        sub ecx, 2
        call get_image_height
        mov [img_height], eax ;restaurez inaltimea
        sub dword[img_height], 2

        new_values:
            cmp dword[img_height], 0
            jle blur_image
            cmp ecx, 0
            jle new_values_line
            pop eax
            mov dword[esi + edi * 4], eax
            dec ecx
            dec edi
            jmp new_values
            
        new_values_line:     
            sub edi, 2 ;am grija sa ignor ultimul element de pe linie
            dec dword[img_height]
            mov ecx, [img_width]
            sub ecx, 2
            jmp new_values
            
   blur_image:
       call get_image_height
       mov [img_height], eax ;restaurez inaltimea
       push dword[img_height]
       push dword[img_width]
       push dword[img]
       call print_image

       leave
       ret

global main
main:
    mov ebp, esp; for correct debugging
    ; Prologue
    ; Do not modify!
    push ebp
    mov ebp, esp

    mov eax, [ebp + 8]
    cmp eax, 1
    jne not_zero_param

    push use_str
    call printf
    add esp, 4

    push -1
    call exit

not_zero_param:
    ; We read the image. You can thank us later! :)   NEVER!
    ; You have it stored at img variable's address.
    mov eax, [ebp + 12]
    push DWORD[eax + 4]
    call read_image
    add esp, 4
    mov [img], eax

    ; We saved the image's dimensions in the variables below.
    call get_image_width
    mov [img_width], eax

    call get_image_height
    mov [img_height], eax

    ; Let's get the task number. It will be stored at task variable's address.
    mov eax, [ebp + 12]
    push DWORD[eax + 8]
    call atoi
    add esp, 4
    mov [task], eax

    ; There you go! Have fun! :D
    mov eax, [task]
    cmp eax, 1
    je solve_task1
    cmp eax, 2
    je solve_task2
    cmp eax, 3
    je solve_task3
    cmp eax, 4
    je solve_task4
    cmp eax, 5
    je solve_task5
    cmp eax, 6
    je solve_task6
    jmp done

solve_task1:
    ; TODO Task1
    mov esi, [img]
    push esi
    call bruteforce_singlebyte_xor
    add esp, 4 
    jmp done
    
solve_task2:
    ; TODO Task2
    mov esi, [img]
    push esi
    call bruteforce_singlebyte_xor
    add esp, 4
    
    jmp done
solve_task3:
    ; TODO Task3
    mov esi, [img]
    mov eax, [ebp + 12]
    mov ebx, [eax + 12] ;aici am mesajul de codificat
    mov edx, [eax + 16] ;aici am indexul
    push edx
    call atoi
    add esp, 4
    
    push eax
    push ebx
    push esi
    call morse_encrypt
    add esp, 12
    
    jmp done
solve_task4:
    ; TODO Task4
    mov esi, [img]
    mov eax, [ebp + 12]
    mov ebx, [eax + 12] ;mesajul
    mov edx, [eax + 16] ;indexul
    
    push edx
    call atoi
    add esp, 4
    
    push eax
    push ebx
    push esi
    call lsb_encode
    add esp, 12
    
    jmp done
solve_task5:
    ; TODO Task5
    mov esi, [img]
    mov eax, [ebp + 12]
    mov edx, [eax + 12] ;indexul
    
    push edx
    call atoi
    add esp, 4
    
    push eax
    push esi
    call lsb_decode
    add esp, 8
    
    jmp done
solve_task6:
    ; TODO Task6
    mov esi, [img]
    push esi
    call blur
    add esp, 4
    
    jmp done

    ; Free the memory allocated for the image.
done:
    push DWORD[img]
    call free_image
    add esp, 4

    ; Epilogue
    ; Do not modify!
    xor eax, eax
    leave
    ret
    