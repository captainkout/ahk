#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

!h::		;-->		open cheat sheet
	run notepad++.exe  cs_cheat_sheet.txt
Return
#r::		;-->		refresh script
	WinGetTitle, Class, A
	if (InStr(Class,"notepad")>0 and Instr(Class,"chrisscript")) 
	{
		SendInput,{ctrl down}s{ctrl up}		;save it only if youre working on it
		Sleep, 45
	}
	run, %A_ScriptFullPath% 								;refresh script, you'll be prompted with yes/no 
Return
!c::		;-->		c drive
	run, C:\
Return
#c::		;-->		command prompt {remove snark}
	run, cmd.exe 
Return
#+c::		;-->		open new chrome, works even if chrome is unresponsive
	run, C:\Program Files\Google\Chrome\Application\chrome.exe
Return
#n::		;-->		note plus plus{less snark}
	run, notepad++.exe 
Return
#g::		;-->		gentax ttd should be in the same place for everyone
	run, C:\GenTax\TTD\GenTax\gtgen.exe 
Return
#+g::		;-->		trini gentax nav screen -->if chrome is unresponsive, make sure to run script as admin
	run, "https://ttgnpfcr001.ird.gov.tt/navigate/Q8QXhFS7/#1" 
Return
#f::		;-->		trini site fcr
	run, C:\GenTax\TT FCR\gtGen.exe "AutoStart_FCR,http://TTGNPFCR001:8601/FCR/Repository/gentax.svc" 
Return
#+f::		;-->		denver FCR
	run, "C:\GenTax\Fast Environments\Fast\gtGen.exe" AutoStart_FCR WEB FCR,https://Environments.GenTax.com/FCR/Repository/GenTax.svc
Return
^+c::		;-->		add to clipboard list(max 5) because cycling through anything longer would require forwards and backwards that i didn't want to bother with
	global clip_list
	global clip_index
	if clip_list.MaxIndex()=""
	{
		clip_list :=[]
	}
	if % clip_list.MaxIndex() <20
	{
		SendInput,^c
		sleep, 100
		clip_index += 1
		clip_list.Push("" . clipboard . "")
	}
	else 
	{
		clip_index :=Mod(clip_index,5)+1
		SendInput,^c
		sleep, 100
		clip_list[clip_index] := "" . clipboard . ""
	}
Return
^+v::		;-->		paste current clipboard
	global clip_list
	global clip_index
	clipboard := clip_list[clip_index]
	SendInput,^v
Return
^+space::	;-->		move to next clipboard, then paste
	global clip_list
	global clip_index
	clip_index :=Mod(clip_index, clip_list.MaxIndex())+1
	clipboard := clip_list[clip_index]
	de_length := StrLen(clipboard)
	SendInput,^v
	Sleep, 45
	SendInput,{Shift Down}{Left %de_length%}{Shift Up}
Return
^+x::		;-->		Wipe out all clipboards and start index over
	global clip_list
	global clip_index
	clip_list := []
	clip_index :=0
Return
#k::		;-->		column of non-strings pasted as comma delimited list, put your cursor where you want it
	str := "" . clipboard . ""
	newstr := "" . StrReplace(str,"`r",",") . ""
	SendInput,% newstr
Return
#+k::		;-->		column of strings pasted as comma delimited list, put your cursor where you want it
	str := "" . clipboard . ""
	newstr := "" . StrReplace(str,"`r`n","',`n`'") . ""
	SendInput,`'
	SendInput,% newstr
	SendInput,`'
Return
#j::		;-->		enlarge the sql window on reports manager
	SendInput,javascript:
	clipboard=(function(){document.getElementById("container_b-k1").style.height = "1200px"; document.getElementById("vc_b-j1").style.height = "1200px"; document.getElementsByClassName("CodeMirror cm-s-fast CodeMirror-wrap")[0].style.height = "1200px";})()
	Sleep, 45
	SendInput,^v
Return
#a::		;-->		archive a timestamped version of your script and cheat sheet
	FormatTime, CurrentDateTime,, MM-dd-yy-HH-mm
	Script_com := []
	Copy_com :=[]
	script_file :="" . A_ScriptDir . "\Old\ChrisScript-" . CurrentDateTime . ".ahk"
	cheat_file :="" . A_ScriptDir . "\Old\cs_cheat_sheet-" . CurrentDateTime . ".txt"
	
	IfNotExist, Old
		FileCreateDir, Old
	
	;move the old cheat sheet and timestamp it
	FileMove, cs_cheat_sheet.txt, %cheat_file%
	
	;parse through the ChrisScript for commands
	Loop, Read, ChrisScript.ahk	
	{
		Copy_com.Push(A_LoopReadLine)
		if(InStr(A_LoopReadLine,"::")>0 and InStr(A_LoopReadLine,";-->")>0 and InStr(A_LoopReadLine,"loopreadlin")<1)
		{
			Script_com.Push(A_LoopReadLine)
		}
	}
	for key,value in Copy_com
		FileAppend, `n%value%,%script_file%
	
	;write the new cheat sheet header
	FileAppend,	
	(
	ChrisScript cheat sheet`n** updated %CurrentDateTime%`n`n#			-->		windows key`n^			-->		control key`n+			-->		shift key`n!			-->		alt key`nThe "::" doesn't mean anything. End of command.`n-------------------------------Current Version--------------------------------`n
	), cs_cheat_sheet.txt
	
	;write the latest cheat sheet commands
	for key1,value1 in Script_com
		FileAppend, `n%value1%, cs_cheat_sheet.txt
	MsgBox, Archive action complete
Return
#b::		;-->		testing stuff, hehehe
	MsgBox,Start Test
	stuff :="stuff..."
	if (stuff="stuff...")
	{
		;built in windows mail
		Run, "https://www.google.tt/search?q=google+images+cat+picture&espv=2&biw=2133&bih=1132&tbm=isch&tbo=u&source=univ&sa=X&ei=bZGRVfPoLYGGyAS5-oJw&ved=0CBsQsAQ&dpr=0.9"
		Run, mailto:ckoutras@gentax.com?subject=We know you love cats&body=Here's another cat picture [sender must paste cat picture]
	}
Return

;-----------Sql Specific section--------------::;-->	Some Sql specific hotstrings require that you turn on Sql Specific stuff with winQ
#q::		;-->		Turn on/off sql specific stuff, still should only work in windows with "sql" or "script" in name, AHK only supports global arrays !?!?!
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
Return
#+l::		;-->		write "like '%%'" and put cursor in middle
	SendInput,like '`%`%'{left}{left}
Return
#+d::		;-->		write "'12/31/9999'" and highlight month for quick edit
	SendInput,{space}'12/31/9999'{left 9}{shift down}{left 2}{shift up}
Return
#s::		;-->		write "select * from "
	SendInput,Select * `rFrom {space}
Return
#+s::		;-->		write "select top 100 * from "
	SendInput,Select top 100 * `nFrom {space}
Return
#p::		;-->		Declare all parameters from highlighted query
	SendInput,^c
	Sleep, 45
	str :="" . clipboard . ""
	
	start = 1
	params := []
	While InStr(SubStr(str,start),"@")>0
	{
		start:= start + InStr(SubStr(str,start),"@")
		len_list := [Instr(SubStr(str,start)," "), Instr(SubStr(str,start),"`r"),Instr(SubStr(str,start),"`n"),Instr(Substr(str,start),")")]
		sublen:=0

		if len_list[1]>0
			sublen:= len_list[1] -1
		if (len_list[2]>0 and len_list[2] < sublen)
			sublen := len_list[2] -1
		if (len_list[3]>0 and len_list[3] < sublen)
			sublen := len_list[3] -1
		if (len_list[4]>0 and len_list[4] <= sublen)
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
	Sleep, 45
	for key,value in params
	{	
		if Instr(value,"pstr")=1
			newvalue = declare @%value% as VARCHAR(250) = ''
		if Instr(value,"pdtm")=1
			newvalue = declare @%value% as Date = '12/31/9999'
		if(	Instr(value,"pint")=1 or Instr(value,"plng")= 1)
			newvalue = declare @%value% as integer = 0
			
		clipboard := newvalue
		Sleep, 45
		SendInput, ^v {Return}
		Sleep, 45
	}	
	SendInput, {Return}
Return
^u::		;-->		uncomment out lines in sql
	SendInput,^c
	Sleep, 45
	if (InStr(clipboard,"--"))
	{
		newstr :=StrReplace(clipboard,"`r`n--","`r")
		newstr :=StrReplace(newstr,"`r`n","`n")
		if (SubStr(newstr,1,2)="--")
		{
			newstr:= SubStr(newstr,3)
		}
		SendInput,% newstr	
	}
Return
^+u::		;-->		comment out lines in Sql
	SendInput,^c
	Sleep, 45
	newstr := "--" . "" . StrReplace(clipboard,"`r`n","`n--") . ""
	SendInput,% newstr
Return
#z::		;-->		zaudit query because the blame tool is too blamin' slow
	SendInput,Select l.fstrTable,l.fstrLogin,fstrtype,flngAffected,fdtmWhen,fstrLogData{Space} {Return}
	Sleep, 45
	SendInput,From  ZAUDIT_DATA d join ZAUDIT_LOG l on d.fstrid= l.fstrId {Return}
	Sleep, 45
	SendInput,--where fstrTable like '`%`%' {Return}
	Sleep, 45
	SendInput,order by fdtmWhen desc
	Sleep, 45
	SendInput,{Up}{Right 3}
Return
#+z::		;-->		information_schema.columns query
	SendInput,Select TABLE_NAME,COLUMN_NAME,COLUMN_DEFAULT,IS_NULLABLE,DATA_TYPE,CHARACTER_MAXIMUM_LENGTH{Space} {Return}
	Sleep, 45
	SendInput,From  INFORMATION_SCHEMA.COLUMNS {Return}
	Sleep, 45
	SendInput,where table_name like '`%`%' {Return}
	Sleep, 45
	SendInput,--and COLUMN_NAME like '`%`%'
	Sleep, 45
	SendInput,{Up}{Left 3}
Return
:*B0:'::	;-->		close single quote only in sql or gentax sqleditor
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
Return
:*:,::		;-->		return after commas
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
Return
:*B0:from::	;-->		return after from
	global SqlStrings
	if SqlStrings[0]="On"
	{
		WinGetTitle, Title, A
		if (InStr(Title,"Sql")>0
		or InStr(Title, "Script")>0)
		{
			Sleep, 45
			SendInput,{shift down}{left 4}{shift up} {Return}
			Sleep, 45
			SendInput,from{Space}
		}
	}
Return
:*B0:where::	;-->		return after where
	global SqlStrings
	if SqlStrings[0]="On"
	{
		WinGetTitle, Title, A
		if (InStr(Title,"Sql")>0
		or InStr(Title, "Script")>0)
		{
			Sleep, 45
			SendInput,{shift down}{left 5}{shift up} {Return}
			Sleep, 45
			SendInput,where{Space}
		}
	}
Return
:*B0:and::	;-->		return after and
	global SqlStrings
	if SqlStrings[0]="On"
	{	
		WinGetTitle, Title, A
		if (InStr(Title,"Sql")>0
		or InStr(Title, "Script")>0)
		{
			Sleep, 45
			SendInput,{shift down}{left 3}{shift up} {Return}
			Sleep, 45
			SendInput,and{Space}
		}
	}
Return
:*B0:group by::	;-->		return after group by
	global SqlStrings
	if SqlStrings[0]="On"
	{
		WinGetTitle, Title, A
		if (InStr(Title,"Sql")>0
		or InStr(Title, "Script")>0)
		{
			Sleep, 45
			SendInput,{shift down}{left 8}{shift up} {Return}
			Sleep, 45
			SendInput,group by{Space}
		}
	}
Return
:*B0:order by::	;-->		return after order by
	global SqlStrings
	if SqlStrings[0]="On"
	{
		WinGetTitle, Title, A
		if (InStr(Title,"Sql")>0
		or InStr(Title, "Script")>0)
		{
			Sleep, 45
			SendInput,{shift down}{left 8}{shift up} {Return}
			Sleep, 45
			SendInput,order by{Space}
		}
	}
Return