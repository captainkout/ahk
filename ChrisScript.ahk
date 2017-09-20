
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

!h::		;-->		open cheat sheet
	run C:\Program Files\Notepad++\notepad++.exe  cs_cheat_sheet.txt
Return
#h::		;-->		open script
	run C:\Program Files\Notepad++\notepad++.exe  ChrisScript.ahk
Return
!r::		;-->		refresh script
	{
		WinGetTitle, Class, A
		if (InStr(Class,"notepad")>0 and Instr(Class,"chrisscript")) 
		{
			SendInput,{ctrl down}s{ctrl up}		;save it only if youre working on it
			Sleep, 45
		}
		run, %A_ScriptFullPath% 								;refresh script, you'll be prompted with yes/no 
	}
Return
!c::		;-->		c drive
	{
		run, C:\
	}
Return
#z::		;-->		project share
	{
		run, C:\Users\ckoutras\AppData\Roaming\Microsoft\Windows\Network Shortcuts\gt_test
	}
Return
#c::		;-->		command prompt
	{
		run, cmd.exe
	}
Return

!d::		;-->		gentaxDocs
	{
		run, C:\Users\ckoutras\Desktop\gentaxDocs
	}
Return
#d::		;-->		LVD gentax folder
	{
		run, C:\GenTax\LVD\Gentax
	}
Return
^+d::		;-->		downloads
	{
		run, C:\Users\ckoutras\Downloads
	}
Return			
!+h::		;-->		hotkeyfoler
	{
		run, C:\git\ahk
	}
Return
!+c::		;-->		open new chrome, works even if chrome is unresponsive
	{
		run, C:\Program Files (x86)\Google\Chrome\Application\chrome.exe
	}
Return
!n::		;-->		note plus plus
	{
		run, C:\Program Files\Notepad++\notepad++.exe
	}
Return
!g::		;-->		gentax FDD should be in the same place for everyone
	{
		run, C:\Gentax\LVD\Gentax\Components\gtGen.exe
	}
Return
!+g::		;-->		we don't have this yet
	{
		MsgBox, Links don't exists yet
		;run, "https://fastcentralrepository.hacienda.gobierno.pr/links/" 
	}
return
!f::		;-->		LV site fcr
	{
		run, "C:\GenTax\LV FCR\GenTax\gtGen.exe" AutoStart_LV FCR,https://revgtappfcr01.revenue.org/FCR/Repository/GenTax.svc
	}
Return
!+f::		;-->		denver FCR
	{
		run, "C:\GenTax\Fast Environments\Fast\gtGen.exe" AutoStart_FCR WEB FCR,https://Environments.GenTax.com/FCR/Repository/GenTax.svc
	}
Return
!e::		;-->		Fast Environments
	{
		run, "https://environments.gentax.com/links/"
	}
Return
!+e::		;-->		Fast Forums
	{
		run, "https://fastforum.gentax.com/"
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
		sleep, 100
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
		de_length := StrLen(clipboard)
		SendInput,^v
		if de_lenth < 100 ;dont highlight for large strings
		{
			Sleep, 45
			SendInput,{Shift Down}{Left %de_length%}{Shift Up}
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
		de_length := StrLen(clipboard)
		SendInput,^v
		Sleep, 45
		if de_lenth < 100 ;dont highlight for large strings
		{
			Sleep, 45
			SendInput,{Shift Down}{Left %de_length%}{Shift Up}
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
Return!j::		;-->		row of non-strings pasted as comma delimited list, put your cursor where you want it	{		str := "" . clipboard . ""		newstr := "" . StrReplace(str,"`r`n",",") . ""		SendInput,% newstr	}Return!+j::		;-->		ow of strings pasted as comma delimited list, put your cursor where you want it	{		str := "" . clipboard . ""		newstr := "" . StrReplace(str,"`r`n","',`'") . ""		SendInput,`'		SendInput,% newstr		SendInput,`'	}Return!u::		;-->		paste everything in the global clip list as a comma delimited string	{		global clip_list		global clip_index		start_index := clip_index
		max_index := clip_list.MaxIndex()		Loop, %max_index%
		{
			SendInput,% clip_list[a_index]
			Sleep, 45
			SendInput, `, {space}
		}	}
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
	}Return
!a::		;-->		archive a timestamped version of your script and cheat sheet
	{
		FormatTime, CurrentDateTime,, MM-dd-yy_HH-mm
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
		header :="ChrisScript cheat sheet`n"
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
		), cs_cheat_sheet.txt
		
		;write the latest cheat sheet commands
		for key1,value1 in Script_com
			FileAppend, `n%value1%, cs_cheat_sheet.txt
		MsgBox, Archive action complete
	}
Return
!i::		;-->		kill gentax
	{
		run, C:\Users\ckoutras\Desktop\killgen.bat
	}
Return

;-----------Gentax Doc Format section--------------::;-->	Common doc field formats
:*:!ah::	;-->		autoheight
	{
		SendInput,[autoheight=true]
	}
Return
:*:!fb::	;-->		font-bold
	{
		SendInput,[fontbold=true]
	}
Return
:*:!cb::	;-->		caption-bold
	{
		SendInput,[captionbold=true]
	}
Return
:*:!ft::	;-->		ftml
	{
		SendInput,[ftml=true]
	}
Return
:*:!tb::	;-->		TitleBar
	{
		SendInput,[Titlebar=true]
	}
Return
:*:!tt::	;--> 		showtip yourfieldname with "help" on the end
	{
		SendInput,[ShowTip=
		SendInput,^v
		Sleep, 45
		SendInput,Help]
	}
Return
:*:!bt::	;-->		button
	{
		SendInput,[button=true]
	}
Return
:*:!vl::	;-->		value label
	{
		SendInput,[ValueLabel=true]
	}
Return
:*:!bb::	;-->		ftml bold brackets
	{
		SendInput,[b][/b]{Left 4}
	}
Return
:*:!ii::	;-->		ftml italic brackets
	{
		SendInput,[i][/i]{Left 4}
	}
Return	
:*:!ck::	;-->		my email
	{
		SendInput, ckoutras@metrorevenue.org
	}
Return	

;-----------XML Specific section--------------::;-->	Some xsd and xml strings i used a lot
:*:!xsr::	;-->		restricted xsd elemetn
	{
		clipboard :="<xsd:element name="""">`r" 
		+"`t<xsd:annotation>`r" 
		+"`t`t<xsd:documentation>`r`t`t`tfill out the documentation`r" 
		+"`t`t</xsd:documentation>`r" 
		+"`t</xsd:annotation>`r"
		+"`t<xsd:simpleType>`r" 
		+"`t`t<xsd:restriction base =""String50Type"">`r" 
		+"`t`t`t<xsd:enumeration value=""Yes""/>`r" 
		+"`t`t`t<xsd:enumeration value=""No""/>`r"
		+"`t`t</xsd:restriction>`r"
		+"`t</xsd:simpleType>`r"
		+"</xsd:element>"
		SendInput,^v
		Sleep, 45
		SendInput,{Up 13}{Right 5}
	}
Return	
:*:!xss::	;-->		simple xsd elemetn
	{
		clipboard :="<xsd:element name="""" type=""AmountType"">`r" 
		+"`t`t`t`t<xsd:annotation>`r" 
		+"`t`t`t`t`t<xsd:documentation>`rfill out the documentation`r" 
		+"`t`t`t`t`t</xsd:documentation>`r" 
		+"`t`t`t`t</xsd:annotation>`r"
		+"`t`t`t</xsd:element>"
		SendInput,^v
		Sleep, 45
		SendInput,{Up 7}{Right 5}
	}
Return	
:*:!xel::	;-->		element from clipboard
	{
		SendInput,<
		SendInput,^+{space}
		Sleep, 45
		SendInput,{right}></
		Sleep, 45
		SendInput,^+v
		Sleep, 45
		SendInput,>
		Sleep, 45
		
		de_length := StrLen(clipboard)

		if de_lenth < 100 ;dont highlight for large strings
		{
			Sleep, 45
			SendInput,{Left %de_length%}{Left 3}
		}
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
:*:!ga::	;-->		%currentEnv%_GTAPP
	{
		WinGetTitle, title, A
			WinGetTitle, getEnv, A
		if(Instr(getEnv,"TestGTDBT01")>0)
			env:="LVD_"
		else
			env:="LVS_"
		SendInput,use %env%GTAPP{Shift down}{Home}{shift up}{f5}{delete}
	}
Return
:*:!gw::	;-->		%currentEnv%_GTWEB
	{
		WinGetTitle, title, A
			WinGetTitle, getEnv, A
		if(Instr(getEnv,"TestGTDBT01")>0)
			env:="LVD_"
		else
			env:="LVS_"
		SendInput,use %env%GTWEB{Shift down}{Home}{shift up}{f5}{delete}
	}
Return
:*:!gr::	;-->		%currentEnv%_GTREF
	{
		WinGetTitle, title, A
			WinGetTitle, getEnv, A
		if(Instr(getEnv,"TestGTDBT01")>0)
			env:="LVD_"
		else
			env:="LVS_"
		SendInput,use %env%GTREF{Shift down}{Home}{shift up}{f5}{delete}
	}
Return
:*:!gq::	;-->		%currentEnv%_GTWRQ
	{
		WinGetTitle, title, A
			WinGetTitle, getEnv, A
		if(Instr(getEnv,"TestGTDBT01")>0)
			env:="LVD_"
		else
			env:="LVS_"
		SendInput,use %env%GTWRQ{Shift down}{Home}{shift up}{f5}{delete}
	}
Return
:*:!gs::	;-->		%currentEnv%_GTSYS
	{
		WinGetTitle, title, A
			WinGetTitle, getEnv, A
		if(Instr(getEnv,"TestGTDBT01")>0)
			env:="LVD_"
		else
			env:="LVS_"
		SendInput,use %env%GTSYS{Shift down}{Home}{shift up}{f5}{delete}
	}
Return
:*:!fpub::	;-->		force a re-publish of top 1 customerkey
	{
		clipboard :="use LVD_GTWEB`r" 
		+"declare @plngCustomerKey as integer = (select top 1 flngcustomerkey from TBLWebAccount)`r" 
		+"delete TBLWebPublishData where flngCustomerKey = @plngCustomerKey`r" 
		+"delete TBLWebCustomerLastPublished where flngCustomerKey = @plngCustomerKey`r" 
		+"use LVD_GTAPP`rdelete TBLWebCustomerLastPublished where flngCustomerKey = @plngCustomerKey"
		SendInput,^v
		Sleep,45
		SendInput,{shift down}{home}{up 5}{shift up}
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
		Sleep, 45
		SendInput,^v
	}
Return
!+s::		;-->		write "select top 100 * from "
	{
		clipboard :="Select top 100 * `nFrom "
		Sleep, 45
		SendInput, ^v
	}
Return
!p::		;-->		Declare all parameters from highlighted query
	{
		SendInput,^c
		Sleep, 45
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
		Sleep, 45
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
			Sleep, 45
			SendInput, ^v {Return}
			Sleep, 45
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
		Sleep, 45
		SendInput,^v
		Sleep, 45
		SendInput,{Up}{Up}{Right 1}
	}
Return
!+z::		;-->		information_schema.columns query
	{
		clipboard:="Select TABLE_NAME,COLUMN_NAME,COLUMN_DEFAULT,IS_NULLABLE,DATA_TYPE,CHARACTER_MAXIMUM_LENGTH `r"
		+"From  INFORMATION_SCHEMA.COLUMNS `r"
		+"where TABLE_NAME like '`%`%' `r"
		+"--and Column_name like '`%`%'`r"
		+"order by Table_Name asc"
		Sleep, 45
		SendInput,^v
		Sleep, 45
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
				Sleep, 45
				SendInput,{shift down}{left 4}{shift up} {Return}
				Sleep, 45
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
				Sleep, 45
				SendInput,{shift down}{left 5}{shift up} {Return}
				Sleep, 45
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
				Sleep, 45
				SendInput,{shift down}{left 3}{shift up} {Return}
				Sleep, 45
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
				Sleep, 45
				SendInput,{shift down}{left 8}{shift up} {Return}
				Sleep, 45
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
				Sleep, 45
				SendInput,{shift down}{left 8}{shift up} {Return}
				Sleep, 45
				SendInput,order by{Space}
			}
		}
	}
Return


;-----------Testing Area--------------::;-->	This probably doesn't work yet
#b::	;-->		something
	{
		MsgBox,something
	}
Return
#+b::		;-->		testing string concat
	{
		str := "one" 
		+ " two"
		str = %str% three 
		MsgBox,%str% 
	}
Return