
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

global sleepTime := 15 ; These computers seem to run quickly so sleep can be minimal
#b::
    {
        yCoord:= -1
        SendInput, {Up %yCoord%}
    }
return
!h::		;-->		open cheat sheet
    run, fn_cheat_sheet.txt
Return
!c::		;-->		c drive
    {
        run, C:\
    }
Return
!d::		;-->		downloads
    {
        run, C:\Users\%A_UserName% \Downloads
    }
Return		
!+c::		;-->		open new chrome, works even if chrome is unresponsive
    {
        run, C:\Program Files (x86)\Google\Chrome\Application\chrome.exe
    }
Return
#s::		;-->		startup folder
    {
        run, C:\Users\%A_UserName% \AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup
    }
Return
^+c::		;-->		add to clipboard (removed max index)
    {
        global clip_list
        global clip_index
        if clip_list.MaxIndex()=""
        {
            clip_index:= 0
            clip_list :=[]
        }
        SendInput,^c
        Sleep, %sleepTime%
        clip_index :=clip_index + 1
        clip_list[clip_index] := "" . clipboard . ""
    }
    
Return
^+v::		;-->		paste current clipboard
    {
        global clip_list
        global clip_index
        clipboard := clip_list[clip_index]
        SendInput,^v
    }
Return
^+space::	;-->		move to next clipboard, then paste
    {
        global clip_list
        global clip_index
        clip_index :=Mod(clip_index, clip_list.MaxIndex())+1
        clipboard := clip_list[clip_index]
        
        splatArray := StrSplit(RTrim("" . clipboard . ""),"`r`n")
        SendInput,^v
        Sleep, %sleepTime%
        lastStr := splatArray[splatArray.MaxIndex()]
        xCoord := StrLen(lastStr)
        yCoord := splatArray.MaxIndex()-1
        
        if (yCoord < 100 and xCoord <100 and clip_list.MaxIndex()>0) 
        {
            SendInput,{ShiftDown}{Left %xCoord%}{Up %yCoord%}{ShiftUp}
        }
    }
Return
^!space::	;-->		move to to previous clipboard, then paste
    {
        global clip_list
        global clip_index
        clip_index :=Mod(clip_index-1, clip_list.MaxIndex())
        if clip_index <1 ;weird definition of modulus
        {
            clip_index := clip_list.MaxIndex()
        }
        clipboard := clip_list[clip_index]
        
        splatArray := StrSplit(RTrim("" . clipboard . ""),"`r`n")
        SendInput,^v
        Sleep, %sleepTime%
        lastStr := splatArray[splatArray.MaxIndex()]
        xCoord := StrLen(lastStr)
        yCoord := splatArray.MaxIndex()-1
        
        if (yCoord < 100 and xCoord <100 and clip_list.MaxIndex()>0) 
        {
            SendInput,{ShiftDown}{Left %xCoord%}{Up %yCoord%}{ShiftUp}
        }
    }
Return
^+x::		;-->		Wipe out all clipboards and start index over
    {
        global clip_list
        global clip_index
        clip_list := []
        clip_index :=0
    }
Return
!u::		;-->		paste everything in the global clip list as a comma delimited string
    {
        global clip_list
        global clip_index
        start_index := clip_index
        max_index := clip_list.MaxIndex()
        Loop, %max_index%
        {
            SendInput,% clip_list[a_index]
            Sleep, 45
            SendInput, `, {space}
        }
    }
Return
!+u::		;-->		paste everything in the global clip list as a comma delimited string of strings
    {
        global clip_list
        global clip_index
        start_index := clip_index
        max_index := clip_list.MaxIndex()
        Loop, %max_index%
        {	
            SendInput, `'
            SendInput,% clip_list[a_index]
            SendInput, `'`,{space}
            Sleep, 45
        }
    }
Return
!k::		;-->		Sql column values pasted as comma delimited list, put your cursor where you want it
    {
        str := "" . clipboard . ""
        newstr := "" . StrReplace(str,"`r",",") . ""
        SendInput,% newstr
    }
Return
!+k::		;-->		Sql column values pasted as comma delimited list, put your cursor where you want it
    {
        str := "" . clipboard . ""
        newstr := "" . StrReplace(str,"`r`n","',`n`'") . ""
        SendInput,`'
        SendInput,% newstr
        SendInput,`'
    }
Return
!j::		;-->		Sql row values pasted as comma delimited list, put your cursor where you want it
    {
        str := "" . clipboard . ""
        newstr := "" . StrReplace(str,"`r`n",",") . ""
        SendInput,% newstr
    }
Return
!+j::		;-->		Sql row values pasted as comma delimited list, put your cursor where you want it
    {
        str := "" . clipboard . ""
        newstr := "" . StrReplace(str,"`r`n","',`'") . ""
        SendInput,`'
        SendInput,% newstr
        SendInput,`'
    }
Return
!Numpad1::  ;-->        highlight word
    {
        SendInput, {shift down}{home}{shift up}
        Sleep, %sleepTime%
        SendInput, ^c
        Sleep, %sleepTime%
        SendInput, {right}
        
        wholeLeft := "" . clipboard . ""
        wlLen := StrLen(wholeLeft) + 1
        leftPos := 0 ;this will be strlen if nothing found by end of string
        loop, %wlLen% {
            subPos := -1*(A_Index -1)
            leftFind := SubStr(wholeLeft, subPos)
            leftTest := SubStr(wholeLeft,0)
            leftPos := A_Index - 1
            if (RegExMatch(leftFind,"[^a-zA-Z0-9_]")) {
                Break
            }
        }
        
        SendInput, {shift down}{end}{shift up}
        Sleep, %sleepTime%
        SendInput, ^c
        Sleep, %sleepTime%
        SendInput, {left}
        
        wholeRight := "" . clipboard . ""
        rightPos := RegExMatch(wholeRight,"[^a-zA-Z0-9_]") - 1 ; this will be neg1 if nothing found by end of string
        if (rightPos < 0) {
            rightPos := StrLen(wholeRight)
        }
        
        totLen := leftPos + rightPos
        SendInput, {left %leftPos%}
        Sleep, %sleepTime%
        SendInput, {shift down}
            Sleep, %sleepTime%
        SendInput, {right %totLen%}
        Sleep, %sleepTime%
        SendInput, {shift up}  
            
        clipboard := clip_list[clip_index]
    }
Return   
!Numpad2::  ;-->        highlight stuff in quotes
    {
        global clip_list
        global clip_index
        
        SendInput, {shift down}{home}{shift up}
        Sleep, %sleepTime%
        SendInput, ^c
        Sleep, %sleepTime%
        SendInput, {right}
        
        wholeLeft := "" . clipboard . ""
        wlLen := StrLen(wholeLeft) + 1
        leftPos := 0 ;this will be strlen if nothing found by end of string
        loop, %wlLen% {
            subPos := -1*(A_Index -1)
            leftFind := SubStr(wholeLeft, subPos)
            leftTest := SubStr(wholeLeft,0)
            leftPos := A_Index - 1
            if (RegExMatch(leftFind,"[""'']")) {
                Break
            }
        }
        
        SendInput, {shift down}{end}{shift up}
        Sleep, %sleepTime%
        SendInput, ^c
        Sleep, %sleepTime%
        SendInput, {left}
        
        wholeRight := "" . clipboard . ""
        rightPos := RegExMatch(wholeRight,"[""'']") - 1 ; this will be neg1 if nothing found by end of string
        if (rightPos < 0) {
            rightPos := StrLen(wholeRight)
        }
        totLen := leftPos + rightPos
        if (StrLen(wholeLeft) + StrLen(wholeRight)> totLen) {
            SendInput, {left %leftPos%}
            Sleep, %sleepTime%
            SendInput, {shift down}{right %totLen%}{shift up}  
        }
        
        clipboard := clip_list[clip_index]
    }
Return
;-----------Code Specific section--------------::;-->	Some things i typed too often in code

:*:!get::	;--> 		write "{get: set;}"
    {
        SendInput, {{} get; set; {}}
    }	
Return

;-----------Sql Specific section--------------::;-->	Some Sql specific hotstrings require that you turn on Sql Specific stuff with Alt Q 
!+l::		;-->		write "like '%%'" and put cursor in middle
    {
        SendInput,like '`%`%'{left}{left}
    }
Return
!+d::		;-->		write "'12/31/9999'" and highlight month for quick edit
    {
        SendInput,{space}'12/31/9999'{left 9}{shift down}{left 2}{shift up}
    }
Return
!s::		;-->		write "select * from "
    {
        clipboard :="Select * `rFrom "
        Sleep, %sleepTime%
        SendInput,^v
    }
Return
!+s::		;-->		write "select top 100 * from "
    {
        clipboard :="Select top 100 * `nFrom "
        Sleep, %sleepTime%
        SendInput, ^v
    }
Return
!+z::		;-->		information_schema.columns query
    {
        clipboard:="Select TABLE_NAME,COLUMN_NAME,COLUMN_DEFAULT,IS_NULLABLE,DATA_TYPE,CHARACTER_MAXIMUM_LENGTH `r"
        +"From  INFORMATION_SCHEMA.COLUMNS `r"
            +"where TABLE_NAME like '`%`%' `r"
        +"--and Column_name like '`%`%'`r"
        +"order by Table_Name asc"
        Sleep, %sleepTime%
        SendInput,^v
        Sleep, %sleepTime%
        SendInput,{Up}{Up}{Right 1}
    }
Return

;-----------Archive section--------------::;-->	
!a::		;-->		archive a timestamped version of your script and cheat sheet
    {
        FormatTime, CurrentDateTime,, MM-dd-yy_HH-mm
            Script_com := []
        Copy_com :=[]
        script_file :="" . A_ScriptDir . "\Old\FundamentalScript-" . CurrentDateTime . ".ahk"
        cheat_file :="" . A_ScriptDir . "\Old\fn_cheat_sheet-" . CurrentDateTime . ".txt"
        
        IfNotExist, Old
            FileCreateDir, Old
        
        ;move the old cheat sheet and timestamp it
        FileMove, fn_cheat_sheet.txt, %cheat_file%
        
        ;parse through the FundamentalScript for commands	
        Loop, Read, FundamentalScript.ahk	
        {
            Copy_com.Push(A_LoopReadLine)
                if(InStr(A_LoopReadLine,"::")>0 and InStr(A_LoopReadLine,";-->")>0 and InStr(A_LoopReadLine,"loopreadlin")<1)
            {
                ;check if its a section headder
                if Instr(A_LoopReadLine,";----")>0
                {
                    Script_com.Push("`n`n")
                    Script_com.Push(A_LoopReadLine)
                        Script_com.Push("`n")
                }
                else
                {
                    Script_com.Push(A_LoopReadLine)
                    }
            }
        }
        for key,value in Copy_com
            FileAppend, `n%value%,%script_file%
        
        ;write the new cheat sheet header
        dt = CurrentDateTime
        header :="FundamentalScript cheat sheet`n"
        + "** updated " %dt% "`n`n"
        + "#			-->		windows key`n"
        + "^			-->		control key`n"
        + "+			-->		shift key`n"
            + "!			-->		alt key`n`n"
        + "The :: doesn't mean anything. End of command.`n`n"
        + "-------------------------------Current Version--------------------------------`n"
        FileAppend,	
        (
        %header%
        ), fn_cheat_sheet.txt
        
        ;write the latest cheat sheet commands
        for key1,value1 in Script_com
            FileAppend, `n%value1%, fn_cheat_sheet.txt
        MsgBox, Archive action complete
    }
Return