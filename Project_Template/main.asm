INCLUDE Irvine32.inc
INCLUDE macros.inc
BUFFER_SIZE = 5000

.DATA
array1 dword 81 dup(5)
;;;; trokaaa;;;;
var dword ?
buffer BYTE BUFFER_SIZE DUP(?) 
fileHandle  HANDLE ? 
newline byte 0Dh,0Ah
WriteToFile_1 DWORD ?    ; number of bytes written
;Variables for writing in array
str1 BYTE "Cannot create file",0dh,0ah,0 
arrayy Dword 81 DUP(0)

myArr byte 81 dup(?)

;tab3y

multiplier dw 4
wrong_answer dword 0
count_Of_initial_board dword 0
countOfSolved dword 0
;---------------files paths------------------------

unsolvedFileName Byte "Boards/diff_?_?.txt",0
solvedFileName Byte "Boards/diff_?_?_solved.txt",0
;--------------------------------------------------
;---------------lastgame paths------------------------
continue_file Byte "Lastgame/user_continue.txt",0
unsolved_continue Byte "Lastgame/unsolved_continue.txt",0
solved_continue Byte "Lastgame/solved_continue.txt",0
Details Byte "Lastgame/details.txt",0
;--------------------------------------------------

;------------Returned from file--------------------
solved_board dword 81 dup(3)       
initial_board dword 81 dup(2)       
;---------------------------------------------------

;--------------user board--------------------------
user_board dword 81 dup(0)            ;
;Variables for reading from file     ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;







.code




;----------function to open file and return array-----------------

Open_ReadArray PROC, arrayOffset:ptr dword, fileNameOffset:Dword

;;;;; mov file address to ebx and string size to ecx
mov esi, arrayOffset
mov ebx,fileNameOffset
mov ecx,40
;;;;;;;;;;;;;;;; open file ;;;;;;;;;;;
mov edx,ebx
call OpenInputFile
mov fileHandle,eax


;;;;; compare value if file can not open or wrong path;;;;;;;;;;;;;;;;;
cmp eax,INVALID_HANDLE_VALUE
JNE FileReadOk


jmp endd
FileReadOk:
    mov edx,offset buffer 
	mov ecx,5000
	call readfromfile
	JNC CheckSize	;if carry flag =0 then size of the buffer is ok
		
		JMP CloseFilee


CheckSize:
		cmp eax,5000
		jb OK
		
		call CloseFilee





;;;; if file buffer is ok;;;;;;;;;
OK:		

	;Insert null terminator
	mov buffer[eax], 0

	mov ebx, OFFSET buffer
	mov ecx, 97
	;store the offset of the array in EDX to reuse it
	mov edx,esi

	StoreArray :
		  MOV AL, [ebx]
		  INC ebx
		  CMP AL, 13
		  JE Skip
		  CMP AL, 10
		  JE Skip
		 
		  MOV [ESI], AL
		 
		  add esi , type arrayoffset
		 Skip : 
	loop StoreArray


	MOV ESI, EDX
	;store the offset of the array in EDX to reuse it
	
	MOV ECX, 81
   ConvertChar:
		  mov edi,48
		  SUB [ESI],edi
		  
		  

		  add esi , type arrayoffset
	loop ConvertChar
		  

	;Return the offset of the filled array in ESI
	 MOV ESI, EDX

CloseFilee :
	MOV EAX, fileHandle
	CALL CloseFile

endd:
ret
Open_ReadArray  ENDP


;----------------------------------------------------------------------
  WriteTo_File PROC ,arraytowrite:Dword, filename:Dword
;-------------------------------------------------------
; Writes the board to an output file.
; Receives: EAX = file handle, EDX = arrayoffset,
; ECX = number of bytes to write 
; Returns: EAX = number of bytes written to the file.
; If the value returned in EAX is less than the
; argument passed in ECX, an error likely occurred.
;-------------------------------------------------------
   PUSH EAX
	MOV EDX, arraytowrite ;mov offset of array in edx
	MOV ebx, filename     ;mov offset of filename in edx
	POP EAX
	PUSH EDX
	MOV ECX,81		 ; Move number of board elements to ECX
;-------------------to convert all numbers into chars to store in file
	 Convert:         
		 MOV EAX,48
		 ADD [EDX],AL
		 add  edx,type arraytowrite
	 LOOP Convert
;--------Create text file----------------------------------
	 MOV edx,ebx	    ;Move file name offset to EDX for CreatOutputFile
	 CALL CreateOutputFile
	 MOV fileHandle,eax

;-------------Writing in the file-----------------------------
   POP EDX		;offset of the board"array" that will be typed
   MOV ECX,81	;size of array

   l1:
	
	   MOV EAX,fileHandle
	   PUSH EDX		
	   PUSH ECX		 
	   MOV ECX,1
	   CALL WriteToFile
	   POP ECX

	   ;check if a new line should be printed or not
			MOV DX,0
			DEC ECX
			MOV AX,CX     ;DX = CX-1 % 9
 			MOV BX,9
			DIV BX

			CMP DX,0 ; if not div by 9 then Row length<9
			JNE Continuee

			PUSH ECX
			 MOV EAX,fileHandle
			 MOV ECX,lengthof newline
			 MOV EDX,offset newline
			 CALL WriteToFile
			POP ECX
	
		Continuee:
	   INC ECX  
	   POP EDX  
	   add EDX  , type arraytowrite
   loop l1

   quit:
	ret
WriteTo_File ENDP
	
;--------------------------------------------------------


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Edit;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;take x coordinates from the user then take value to put it in the cell and compare the value if the value correct return in eax 1
Edit_cmp PROC, position:Dword , value:dword
dec position
mov eax, position
mul multiplier
mov esi,  offset solved_board
mov edi,  offset user_board

add esi,eax                          
add edi,eax
mov ebx ,value
cmp  [esi],ebx
JE YES
NO:
    inc wrong_answer
	mov eax,0
    jmp done
YES:
    mov  [edi], ebx
	mov eax,1
	inc countOfSolved	
    cmp countOfSolved , 81
	jne done
    mov eax , 2
done:
ret
Edit_cmp  ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;Count of solved cells;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

unsolvedNum PROC 
mov count_Of_initial_board ,0
mov edx ,offset initial_board
mov ecx , 81
mov ebx,0
L:
 cmp [edx] , ebx
 je next
add_:
 inc count_Of_initial_board
next:
add edx,4
loop L

ret
unsolvedNum ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;Choose Difficulty level;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;take from user the desirable difficulty level must be 1 or 2 or 3 
Difficulty PROC,level:dword

repeat_if_fail:


	;Checks if the difficulty is 1 or 2 or 3
	
	mov eax,level
	CMP AL,1
	JE success
	CMP AL,2
	JE success
	CMP AL,3
	JE success

	
	CALL crlf
	JMP repeat_if_fail	

	success:
	MOV level,eax	


	;get random value
	call randomize
	mov eax ,4
	call RandomRange
;	inc eax
	;store the random number in dx
	MOV dx,ax
	CMP dx,0
	JE ifZERo
	JMP cont

    ifZERo:
	INC DX

cont:



;add difficulty and board random number in the empty bits 19 ,21 in the string file 
	MOV AL,dl
	ADD AL,'0'
	MOV unsolvedFileName[14],AL

	MOV eax,level
	ADD AL,'0'
	MOV unsolvedFileName[12],AL

	MOV AL,dl
	ADD AL,'0'
	MOV solvedFileName[14],AL

	MOV eax,level
	ADD AL,'0'
	MOV solvedFileName[12],AL


ret
Difficulty  ENDP
;;;;;;;;;;;;;;;;;;;;Continue;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Load last played game,doesn't take param. return only
Return_last_game PROC

Return_last_game  ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;clear ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;clear board and return initial board again
clear_board PROC , IBoard : ptr dword
   mov edx , offset initial_board
   mov ecx , 81
   mov esi , IBoard

   Move:
	 mov ebx , [edx]
	 mov [esi] , ebx
	 add esi , type IBoard
	 add edx , type initial_board
   loop Move

ret
clear_board  ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;Function to print Solved sudoku;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; when user choose print and finish this function will clear board and return solved board
print_solved_board PROC , SBoard : ptr dword
    mov edx , offset Solved_board
   mov ecx , 81
   mov esi , SBoard

   Move:
	 mov ebx , [edx]
	 mov [esi] , ebx
	 add esi , type SBoard
	 add edx , type Solved_board
   loop Move
ret
print_solved_board  ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;Save and Exit;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; save board to the file,,and return it when player choose continue
; take valued of the board in array and take filename as parameters

 Save_to_file PROC, Array:Dword, fName:Dword


 Save_to_file  ENDP

 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;Rank;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 Save_Rank PROC,Time:Dword,pName:Dword,Wronganswers:Dword

 Save_Rank  ENDP
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 ;;;;; new game;;;;;
 newgame proc, level:dword,Cuser_board :dword
 invoke Difficulty,level
 invoke Open_ReadArray,offset initial_board,offset unsolvedFileName
 invoke Open_ReadArray,offset solved_board,offset solvedFileName
 mov ecx,81
 mov esi, offset initial_board
 mov edi, offset user_board
 mov edx, Cuser_board
 L1:
 mov eax,[esi]
 mov edi,eax
 mov edx,eax
 add edx,type Cuser_board
 add esi,type initial_board
 add edi,type user_board
 loop L1

 ret
 newgame endp

 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;con;;;;;;;;;;;;;;;;;;;;;
  ;;;;; new game;;;;;
Continue PROC ,Iarrayoffset : ptr dword


invoke Open_ReadArray , offset initial_board  , offset unsolved_continue
invoke Open_ReadArray , offset solved_board , offset solved_continue
invoke Open_ReadArray ,offset user_board,offset continue_file

;invoke solvedNum , offset user_board

mov ecx , 81
mov esi , offset user_board
mov edi , Iarrayoffset
rep movsd


ret 
Continue ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;get_board;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
get_Board PROC , level: dword , Iarrayoffset : ptr dword

mov wrong_answer ,0
invoke Difficulty , level
invoke Open_ReadArray , offset initial_board  , offset unsolvedFileName
invoke Open_ReadArray , offset solved_board , offset solvedFileName

;invoke solvedNum , offset initial_board

mov ecx , 81
mov esi , offset initial_board
mov edi , Iarrayoffset
rep movsd


mov ecx , 81
mov esi , offset initial_board
mov edi ,offset  user_board
rep movsd

mov eax , countOfSolved
ret 
get_Board ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;the end of game ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

return_wrong PROC
mov eax,wrong_answer
ret
return_wrong ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

return_correct PROC

call unsolvedNum
mov edx , count_Of_initial_board
sub countOfSolved , edx
mov eax , countOfSolved 
ret
return_correct  ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;helper;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
helper PROC 
 invoke WriteTo_File , offset initial_board,offset unsolved_continue
 invoke WriteTo_File , offset solved_board,offset solved_continue
 invoke WriteTo_File , offset user_board,offset continue_file



 ret
 helper ENDP

 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;main;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DllMain PROC hInstance:DWORD, fdwReason:DWORD, lpReserved:DWORD 

mov eax, 1		; Return true to caller. 
ret 				
DllMain ENDP

 END DllMain

 
 