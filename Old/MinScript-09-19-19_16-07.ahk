

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

global gSleepValue = 15
global gSleepValueLong = 100

!h::		;-->		open cheat sheet
    run C:\Users\%A_UserName% \AppData\Local\Programs\Microsoft VS Code\Code.exe  ms_cheat_sheet.txt
Return
!+h::		;-->		open script
    run C:\Users\%A_UserName% \AppData\Local\Programs\Microsoft VS Code\Code.exe  MinScript.ahk
Return
#+h::		;-->		hotkeyfoler
    {
        run, C:\Users\%A_UserName% \source\repos\ahk
    }
Return
!r::		;-->		refresh script
    {
        WinGetTitle, Class, A
        if (InStr(Class,"ahk")>0 and Instr(Class,"minscript")) 
        {
            SendInput,{ctrl down}s{ctrl up}		;save it only if youre working on it
            Sleep, gSleepValue
        }
        run, %A_ScriptFullPath% 								;refresh script, you'll be prompted with yes/no 
    }
Return
!c::		;-->		c drive
    {
        run, C:\
    }
Return
#c::		;-->		command prompt
    {
        run, cmd.exe
    }
Return
!o::		;-->		repos
    {
        run, C:\Users\%A_UserName% \source\repos
    }
Return
^+d::		;-->		downloads
    {
        run, C:\Users\%A_UserName% \Downloads
    }
Return		
!+c::		;-->		open new chrome, works even if chrome is unresponsive
    {
        run, C:\Program Files (x86)\Google\Chrome\Application\chrome.exe
    }
Return
!v::		;-->		vscode
    {
        run, C:\Users\%A_UserName% \AppData\Local\Programs\Microsoft VS Code\Code.exe
    }
Return
#s::		;-->		startup
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
        Sleep, gSleepValuelong
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
        Sleep, gSleepValue
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
        Sleep, gSleepValue
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
!k::		;-->		column of non-strings pasted as comma delimited list, put your cursor where you want it
    {
        str := "" . clipboard . ""
        newstr := "" . StrReplace(str,"`r",",") . ""
        SendInput,% newstr
    }
Return
!+k::		;-->		column of strings pasted as comma delimited list, put your cursor where you want it
    {
        str := "" . clipboard . ""
        newstr := "" . StrReplace(str,"`r`n","',`n`'") . ""
        SendInput,`'
        SendInput,% newstr
        SendInput,`'
    }
Return
!j::		;-->		row of non-strings pasted as comma delimited list, put your cursor where you want it
    {
        str := "" . clipboard . ""
        newstr := "" . StrReplace(str,"`r`n",",") . ""
        SendInput,% newstr
    }
Return
!+j::		;-->		row of strings pasted as comma delimited list, put your cursor where you want it
    {
        str := "" . clipboard . ""
        newstr := "" . StrReplace(str,"`r`n","',`'") . ""
        SendInput,`'
        SendInput,% newstr
        SendInput,`'
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
            Sleep, gSleepValue
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
            Sleep, gSleepValue
        }
    }
Return
!a::		;-->		archive a timestamped version of your script and cheat sheet
    {
        FormatTime, CurrentDateTime,, MM-dd-yy_HH-mm
            Script_com := []
        Copy_com :=[]
        script_file :="" . A_ScriptDir . "\Old\MinScript-" . CurrentDateTime . ".ahk"
        cheat_file :="" . A_ScriptDir . "\Old\ms_cheat_sheet-" . CurrentDateTime . ".txt"
        
        IfNotExist, Old
            FileCreateDir, Old
        
        ;move the old cheat sheet and timestamp it
        FileMove, ms_cheat_sheet.txt, %cheat_file%
        
        ;parse through the MinScript for commands	
        Loop, Read, MinScript.ahk	
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
        header :="MinScript cheat sheet`n"
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
        ), ms_cheat_sheet.txt
        
        ;write the latest cheat sheet commands
        for key1,value1 in Script_com
            FileAppend, `n%value1%, ms_cheat_sheet.txt
        MsgBox, Archive action complete
    }
Return
!i::		;-->		1) Send EntityProject to interactive 2) Paste this 3) Past json into window and run
    {
        clipstr= 
        (
using Smc.SafetyMap.App;
using System.Linq;
using Smc.SafetyMap;
using Smc.SafetyMap.EntityFrameworkCore;
using Newtonsoft.Json;
using Smc.SafetyMap.App.PCRAModule;
public void prettyPrint(object o)
{
    System.Diagnostics.Process.Start("http://json2table.com/");
    System.Windows.Forms.Clipboard.SetText(JsonConvert.SerializeObject(o, Formatting.Indented));
}
var db = new SafetyMapDbContext("Server = localhost; Database = SafetyMap; Trusted_Connection = True; ");
        )
        Clipboard:="" . clipstr . ""
        Sleep, gSleepValue
        SendInput, ^v

    }
Return
!Numpad1::  ;-->        highlight continuous letters
{
    highlightByPattern("[^a-zA-Z0-9]")
}
Return   
!Numpad2::  ;-->        highlight property
{
    highlightByPattern("[^a-zA-Z0-9_]")
}
Return
!Numpad3::  ;-->        highlight stuff in quotes
{
    highlightByPattern("[""'']")
}
Return
!Numpad4::  ;-->        highlight stuff in <>
{
    highlightByPattern("[\<>]")
}
Return
!/::        ;-->        replace forwardslash(/) with backslash(\)
{
    str := "" . clipboard . ""
    clipboard := RegExReplace(str, "[\\]" , "/")
    SendInput, ^v
}
Return
;-----------Code Specific section--------------::;-->	Some things i typed too often in code

:*:!get::	;--> 		write "{get: set;}"
    {
        SendInput, {{} get; set; {}}
    }	
Return

;-----------Sql Specific section--------------::;-->	Some Sql specific hotstrings require that you turn on Sql Specific stuff with Alt Q 
!q::		;-->		Turn on/off sql specific stuff, still should only work in windows with "sql" or "script" in name, AHK only supports global arrays !?!?!
    {
        global SqlStrings
        if (SqlStrings ="" or SqlStrings[0]="Off")
        {
            SqlStrings :=[]
            SqlStrings[0] :="On"
            MsgBox, SqlStrings is now ON, still should only work in windows with "sql" or "script" in name
        }
        else
        {
            SqlStrings[0] :="Off"
            MsgBox, SqlStrings is now OFF
        }
    }
Return
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
        Sleep, gSleepValue
        SendInput,^v
    }
Return
!+s::		;-->		write "select top 100 * from "
    {
        clipboard :="Select top 100 * `nFrom "
        Sleep, gSleepValue
        SendInput, ^v
    }
Return
!p::		;-->		Declare all parameters from highlighted query
    {
        SendInput,^c
        Sleep, gSleepValue
        str :="" . clipboard . ""
        
        start = 1
        params := []
        While InStr(SubStr(str,start),"@p")>0
        {
            start:= start + InStr(SubStr(str,start),"@p")
            len_list := [Instr(SubStr(str,start)," "), Instr(SubStr(str,start),"`r"),Instr(SubStr(str,start),"`n"),Instr(Substr(str,start),")")]
            sublen:=0
            
            if len_list[1]>0
                sublen:= len_list[1] -1
            if (len_list[2] > 0 and len_list[2] < sublen)
                sublen := len_list[2] -1
            if (len_list[3] > 0 and len_list[3] < sublen)
                sublen := len_list[3] -1
            if (len_list[4] > 0 and len_list[4] <= sublen)
                sublen := len_list[4] -1
            
            bool:=0
            if sublen=0
            {
                for key,value in params
                {
                    beta :="" . SubStr(str,start) . ""
                    if value = %beta%
                        bool:=1
                }
                if bool=0
                    params.Push("" . SubStr(str,start) . "")
            }
            else
            {
                for key,value in params
                {
                    beta :="" . SubStr(str,start,sublen) . ""
                    if value = %beta%
                        bool:=1
                }
                if bool=0
                    params.Push("" . SubStr(str,start,sublen) . "")
            }
        }
        SendInput,{Left} {Return}
        Sleep, gSleepValue
        for key,value in params
        {	
            if Instr(value,"pstr")=1
                newvalue = declare @%value% as VARCHAR(250) = ''
            if Instr(value,"pdtm")=1
                newvalue = declare @%value% as Date = '12/31/9999'
            if(	Instr(value,"pint")=1 or Instr(value,"plng")= 1)
            {
                if Instr(value,"plngAccountKey")>0
                {
                    newvalue = declare @%value% as integer = (select top 1 flngAccountKey from tblAccountInfo)
                }
                else if Instr(value,"plngCustomerKey")>0
                {
                    newvalue = declare @%value% as integer = (select top 1 flngCustomerKey from tblCustomerInfo)
                }
                else
                {
                    newvalue = declare @%value% as integer = 0
                }
            }
            if Instr(value,"pbln")=1 
                newvalue = declare @%value% as bit = 0
            
            clipboard := newvalue
            Sleep, gSleepValue
            SendInput, ^v {Return}
            Sleep, gSleepValue
        }	
        SendInput, {Return}
    }
Return
!z::		;-->		zaudit query because the blame tool is too blamin' slow
    {
        clipboard :="Select l.fstrTable,l.fstrLogin,fstrtype,flngAffected,fdtmWhen,fstrLogData`r"
        +"From  ZAUDIT_DATA d join ZAUDIT_LOG l on d.fstrid= l.fstrId`r"
        +"where fstrTable like '`%`%'`r" 
        +"--and fstrColumn like '`%`%'`r"
        +"order by fdtmWhen desc"
        Sleep, gSleepValue
        SendInput,^v
        Sleep, gSleepValue
        SendInput,{Up}{Up}{Right 1}
    }
Return
!+z::		;-->		information_schema.columns query
    {
        clipboard:="Select TABLE_SCHEMA,TABLE_NAME,COLUMN_NAME,COLUMN_DEFAULT,IS_NULLABLE,DATA_TYPE,CHARACTER_MAXIMUM_LENGTH `r"
        +"From  INFORMATION_SCHEMA.COLUMNS `r"
            +"where TABLE_NAME like '`%`%' `r"
        +"--and Column_name like '`%`%'`r"
        +"order by Table_Name asc"
        Sleep, gSleepValue
        SendInput,^v
        Sleep, gSleepValue
        SendInput,{Up}{Up}{Right 1}
    }
Return
:*B0:'::	;-->		close single quote only in sql or gentax sqleditor
    {
        global SqlStrings
        if SqlStrings[0]="On"
        {
            WinGetTitle, Title, A
            if (InStr(Title,"Sql")>0
                or InStr(Title, "Script")>0)
            {
                SendInput,'{Left}	
            }
        }
    }
Return
:*:,::		;-->		return after commas
    {
        global SqlStrings
        if SqlStrings[0]="On"
        {
            WinGetTitle, Title, A
            if (InStr(Title,"Sql")>0
                or InStr(Title, "Script")>0)
            {
                SendInput,,`r
            }
            Else
            {
                SendInput,,
            }
        }
        Else
        {
            SendInput,,
        }
    }
Return
:*B0:from::	;-->		return after from
    {
        global SqlStrings
        if SqlStrings[0]="On"
        {
            WinGetTitle, Title, A
            if (InStr(Title,"Sql")>0
                or InStr(Title, "Script")>0)
            {
                Sleep, gSleepValue
                SendInput,{shift down}{left 4}{shift up} {Return}
                Sleep, gSleepValue
                SendInput,from{Space}
            }
        }
    }
Return
:*B0:where::	;-->		return after where
    {
        global SqlStrings
        if SqlStrings[0]="On"
        {
            WinGetTitle, Title, A
            if (InStr(Title,"Sql")>0
                or InStr(Title, "Script")>0)
            {
                Sleep, gSleepValue
                SendInput,{shift down}{left 5}{shift up} {Return}
                Sleep, gSleepValue
                SendInput,where{Space}
            }
        }
    }
Return
:*B0:and::	;-->		return after and
    {
        global SqlStrings
        if SqlStrings[0]="On"
        {	
            WinGetTitle, Title, A
            if (InStr(Title,"Sql")>0
                or InStr(Title, "Script")>0)
            {
                Sleep, gSleepValue
                SendInput,{shift down}{left 3}{shift up} {Return}
                Sleep, gSleepValue
                SendInput,and{Space}
            }
        }
    }
Return
:*B0:group by::	;-->		return after group by
    {
        global SqlStrings
        if SqlStrings[0]="On"
        {
            WinGetTitle, Title, A
            if (InStr(Title,"Sql")>0
                or InStr(Title, "Script")>0)
            {
                Sleep, gSleepValue
                SendInput,{shift down}{left 8}{shift up} {Return}
                Sleep, gSleepValue
                SendInput,group by{Space}
            }
        }
    }
Return
:*B0:order by::	;-->		return after order by
    {
        global SqlStrings
        if SqlStrings[0] = "On"
        {
            WinGetTitle, Title, A
            if (InStr(Title,"Sql")>0
                or InStr(Title, "Script")>0)
            {
                Sleep, gSleepValue
                SendInput,{shift down}{left 8}{shift up} {Return}
                Sleep, gSleepValue
                SendInput,order by{Space}
            }
        }
    }
Return
;-----------Up Keys--------------::;-->	If the something is stuck, send all the up inputs
!Home::
    {
        SendInput, {Shift up}
            GetKeyState, state, shift
            ; SendInput, {shift up}
        ; Sleep, gSleepValue
        ; SendInput, {control up}
        ; Sleep, gSleepValue
        ; SendInput, {shift up}
        MsgBox, %state%
        
    }
Return
;-----------Testing Area--------------::;-->	This probably doesn't work yet
#b::	;-->		something
    {
        Sleep, gSleepValue
        MsgBox, slept 
    }
Return
#+b::		;-->		testing string concat
    {
        clipval := "" . clipboard . ""
        test := RegExReplace(clipval,"[\\]" , "/")
        MsgBox, %test%
    }
highlightByPattern(pattern)   ;--> pattern: string.regex
    {
      
        SendInput, {shift down}{home}{shift up}
        Sleep, gSleepValue
        SendInput, ^c
        Sleep, gSleepValue
        SendInput, {right}
        
        wholeLeft := "" . clipboard . ""
        wlLen := StrLen(wholeLeft) + 1
        leftPos := 0 ;this will be strlen if nothing found by end of string
        loop, %wlLen% {
            subPos := -1*(A_Index -1)
            leftFind := SubStr(wholeLeft, subPos)
            leftTest := SubStr(wholeLeft,0)
            leftPos := A_Index - 1
            if (RegExMatch(leftFind,pattern)) {
                Break
            }
        }
        
        SendInput, {shift down}{end}{shift up}
        Sleep, gSleepValue
        SendInput, ^c
        Sleep, gSleepValue
        SendInput, {left}
        
        wholeRight := "" . clipboard . ""
        rightPos := RegExMatch(wholeRight,pattern) - 1 ; this will be neg1 if nothing found by end of string
        if (rightPos < 0) {
            rightPos := StrLen(wholeRight)
        }
        totLen := leftPos + rightPos
        if (StrLen(wholeLeft) + StrLen(wholeRight)> totLen) {
            SendInput, {left %leftPos%}
            Sleep, gSleepValue
            SendInput, {shift down}{right %totLen%}{shift up}  
        }
        
        clipboard := clip_list[clip_index]
    }
