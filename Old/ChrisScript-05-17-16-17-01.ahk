
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

!h::		;-->		open cheat sheet
	run notepad.exe  cs_cheat_sheet.txt
Return
!r::		;-->		refresh script
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
#z::		;-->		z drive - project share
	run, Z:\
Return
#c::		;-->		command prompt {remove snark}
	run, cmd.exe 
Return


!d::		;-->		gentaxDocs
	run, C:\Users\chris.koutras\Desktop\gentaxDocs
Return
#d::		;-->		prd gentax folder
	run, C:\GenTax\PRD\Gentax
Return
!+h::		;-->		hotkeyfoler
	run, C:\git\ahk
Return

!+c::		;-->		open new chrome, works even if chrome is unresponsive
	run, C:\Program Files (x86)\Google\Chrome\Application\chrome.exe
Return
!n::		;-->		note plus plus{less snark}
	run, C:\Program Files (x86)\Notepad++\notepad++.exe
Return
!g::		;-->		gentax FDD should be in the same place for everyone
	run, C:\Gentax\PRD\Gentax\gtGen.exe
Return
!+g::		;-->		we don't have this yet
	run, "https://fastcentralrepository.hacienda.gobierno.pr/links/" 
return
!f::		;-->		PR site fcr
	run, C:\GenTax\FCR\GenTax\gtGen.exe AutoStart_FCR, net.tcp://hacgtxappfcr01:8001/FCR/Repository/Gentax.svc
Return
!+f::		;-->		denver FCR
	run, "C:\GenTax\Fast Environments\Fast\gtGen.exe" AutoStart_FCR WEB FCR,https://Environments.GenTax.com/FCR/Repository/GenTax.svc
Return
^+c::		;-->		add to clipboard
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
!k::		;-->		column of non-strings pasted as comma delimited list, put your cursor where you want it
	str := "" . clipboard . ""
	newstr := "" . StrReplace(str,"`r",",") . ""
	SendInput,% newstr
Return
!+k::		;-->		column of strings pasted as comma delimited list, put your cursor where you want it
	str := "" . clipboard . ""
	newstr := "" . StrReplace(str,"`r`n","',`n`'") . ""
	SendInput,`'
	SendInput,% newstr
	SendInput,`'
Return
!a::		;-->		archive a timestamped version of your script and cheat sheet
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
^+b::		;-->		move to next clipboard, then paste
	global clip_list
	global clip_index
	clip_index :=Mod(clip_index, clip_list.MaxIndex())-1
	MsgBox ,262144, %something%
	clipboard := clip_list[clip_index]
	MsgBox ,262144, %clipboard%
	de_length := StrLen(clipboard)
	SendInput,^v
	Sleep, 45
	SendInput,{Shift Down}{Left %de_length%}{Shift Up}
Return

;-----------Gentax Doc Format section--------------::;-->	Common doc field formats
:*:!ah::	;-->		autoheight
	SendInput,[autoheight=true]
Return
:*:!fb::	;-->		font-bold
	SendInput,[fontbold=true]
Return
:*:!cb::	;-->		caption-bold
	SendInput,[captionbold=true]
Return
:*:!ft::	;-->		ftml
	SendInput,[ftml=true]
Return
:*:!tt::	;--> 		showtip yourfieldname with "help" on the end
	SendInput,[ShowTip=
	SendInput,^v
	Sleep, 45
	SendInput,Help]
return
:*:!bt::	;-->		button
	SendInput,[button=true]
Return
:*:!vl::	;-->		value label
	SendInput,[ValueLabel=true]
Return
:*:!bb::	;-->		value label
	SendInput,[b][/b]{Left 4}
Return
	

;-----------Sql Specific section--------------::;-->	Some Sql specific hotstrings require that you turn on Sql Specific stuff with winQ
!q::		;-->		Turn on/off sql specific stuff, still should only work in windows with "sql" or "script" in name, AHK only supports global arrays !?!?!
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
:*:!da::	;-->		use prd_gtapp
	SendInput,use PRD_GTAPP{Shift down}{Home}{shift up}{f5}{delete}
Return
:*:!dw::	;-->		use prd_gtweb
	SendInput,use PRD_GTWEB{Shift down}{Home}{shift up}{f5}{delete}
Return
:*:!dr::	;-->		use prd_gtref
	SendInput,use PRD_GTREF{Shift down}{Home}{shift up}{f5}{delete}
Return
:*:!dq::	;-->		use prd_gtwrq
	SendInput,use PRD_GTWRQ{Shift down}{Home}{shift up}{f5}{delete}
Return
:*:!ds::	;-->		use prd_gtsys
	SendInput,use PRD_GTSYS{Shift down}{Home}{shift up}{f5}{delete}
Return
:*:!sa::	;-->		use prs_gtapp
	SendInput,use PRS_GTAPP{Shift down}{Home}{shift up}{f5}{delete}
Return
:*:!sw::	;-->		use prs_gtweb
	SendInput,use PRS_GTWEB{Shift down}{Home}{shift up}{f5}{delete}
Return
:*:!sr::	;-->		use prs_gtref
	SendInput,use PRS_GTREF{Shift down}{Home}{shift up}{f5}{delete}
Return
:*:!sq::	;-->		use prs_gtwrq
	SendInput,use PRS_GTWRQ{Shift down}{Home}{shift up}{f5}{delete}
Return
:*:!ss::	;-->		use prs_gtsys
	SendInput,use PRS_GTSYS{Shift down}{Home}{shift up}{f5}{delete}
Return

!+l::		;-->		write "like '%%'" and put cursor in middle
	SendInput,like '`%`%'{left}{left}
Return
!+d::		;-->		write "'12/31/9999'" and highlight month for quick edit
	SendInput,{space}'12/31/9999'{left 9}{shift down}{left 2}{shift up}
Return
!s::		;-->		write "select * from "
	clipboard :="Select * `rFrom "
	Sleep, 45
	SendInput,^v
Return
!+s::		;-->		write "select top 100 * from "
	clipboard :="Select top 100 * `nFrom "
	Sleep, 45
	SendInput, ^v
Return
!p::		;-->		Declare all parameters from highlighted query
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
!z::		;-->		zaudit query because the blame tool is too blamin' slow
	clipboard :="Select l.fstrTable,l.fstrLogin,fstrtype,flngAffected,fdtmWhen,fstrLogData `rFrom  ZAUDIT_DATA d join ZAUDIT_LOG l on d.fstrid= l.fstrId`rwhere fstrTable like '`%`%'`r--and fstrColumn like '`%`%'`rorder by fdtmWhen desc"
	Sleep, 45
	SendInput,^v
	Sleep, 45
	SendInput,{Up}{Up}{Right 1}
Return
!+z::		;-->		information_schema.columns query
	clipboard:="Select TABLE_NAME,COLUMN_NAME,COLUMN_DEFAULT,IS_NULLABLE,DATA_TYPE,CHARACTER_MAXIMUM_LENGTH `rFrom  INFORMATION_SCHEMA.COLUMNS `rwhere TABLE_NAME like '`%`%' `r--and Column_name like '`%`%'`rorder by Table_Name asc"
	Sleep, 45
	SendInput,^v
	Sleep, 45
	SendInput,{Up}{Up}{Right 1}
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