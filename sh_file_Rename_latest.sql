'author leelarakesh
Option Explicit

Dim StdIn:  Set StdIn = WScript.StdIn
Dim StdOut: Set StdOut = WScript.StdOut
Dim fso:    Set fso = CreateObject("Scripting.FileSystemObject")
DIM WshShell: Set WshShell = WScript.CreateObject("WScript.Shell")
Dim FilesRenamed:   FilesRenamed = 0
Dim FilesSkipped:   FilesSkipped = 0
Dim FoldersRenamed: FoldersRenamed = 0
Dim FoldersSkipped: FoldersSkipped = 0
Dim ex_list :set ex_list = CreateObject("Scripting.Dictionary")
Dim adhocobjFile: set adhocobjFile=CreateObject("Scripting.FileSystemObject")
dim g_oSB : Set g_oSB = CreateObject("System.Text.StringBuilder")

' Fills the list.

ex_list.Add  "vbs","vbs"
ex_list.Add  "bat","bat"
'exclude list

ex_list.Add  "csv","csv"
ex_list.Add  "doc","doc"
ex_list.Add  "docx","docx"
ex_list.Add  "eml","eml"
ex_list.Add  "gif","gif"
ex_list.Add  "htm","htm"
ex_list.Add  "jpg","jpg"
ex_list.Add  "msg","msg"
ex_list.Add  "pdf","pdf"
ex_list.Add  "png","png"
ex_list.Add  "tif","tif"
ex_list.Add  "txt","txt"
ex_list.Add  "xls","xls"
ex_list.Add  "xlsb","xlsb"
ex_list.Add  "xlsm","xlsm"
ex_list.Add  "xlsx","xlsx"
ex_list.Add  "xml","xml"
ex_list.Add  "xps","xps"
ex_list.Add  "zip","zip"

'Dim values As New List(Of String) From {"firstValue", "secondValue"}
'If values.Contains(variable)

Main
Sub Main()
	
	Dim CurrentFolder: Set CurrentFolder = fso.GetFolder(".")
	dim outFile
	dim datetime
	
	Dim dt : dt = now()
	

	datetime = DatePart("yyyy",Date) & DatePart("m",Date) & DatePart("d",Date)
	outFile=CurrentFolder.Path&"\"&"File_List_"&sprintf("{0:yyyyMMddhhmmss}", Array(dt))
	StdOut.WriteLine "Calling file rename for "&wscript.Arguments(0)&","&wscript.Arguments(1)&","&wscript.Arguments(2)

	StdOut.WriteLine "Warning: All files and subdirectories within the directory """ & _
	CurrentFolder.Path & """ and all it's subdirectories will be renamed ."
	StdOut.WriteLine "log file name==> "&outFile

	Set adhocobjFile = adhocobjFile.CreateTextFile(outFile&".CSV",True)
	
	writetofile "ORG_FILE_NAME","NEW_FILE_NAME","FILE_PROCESS_STATUS","FOLDER_PATH"
	ProcessFolder CurrentFolder, wscript.Arguments(0), wscript.Arguments(1), wscript.Arguments(2)
	adhocobjFile.close

	StdOut.WriteLine FilesRenamed & " Files renamed"
	StdOut.WriteLine FilesSkipped & " Files skipped"
End Sub

Sub ProcessFolder(ByVal Folder,ByVal ext,ByVal NewExt,ByVal Choice)
	Dim SubFolders: Set SubFolders = Folder.SubFolders
	Dim SubFolder
   RenProcessFolder Folder, ext,NewExt,Choice
   For Each SubFolder In SubFolders
   	RenProcessFolder SubFolder , ext,NewExt,Choice
   ListFolderContents SubFolder,ext ,NewExt,Choice
   	Next
end sub


Function sprintf(sFmt, aData)
   g_oSB.AppendFormat_4 sFmt, (aData)
   sprintf = g_oSB.ToString()
   g_oSB.Length = 0
End Function

Sub ListFolderContents(ByVal path,ByVal ext1,ByVal newext1,ByVal Choice1)
Dim ListFolder: set ListFolder = fso.GetFolder(path)
DIM item
		For each item in ListFolder.SubFolders
			RenProcessFolder item , ext1,newext1,Choice1
			ListFolderContents item , ext1,newext1,Choice1			
		Next
	set ListFolder = Nothing
End Sub

Sub RenProcessFolder(ByVal Folder,ByVal tag,ByVal newtag,ByVal Choice3)
Dim filenamewithoutext:  
Dim fileext:
Dim Files: Set Files = Folder.Files 
Dim File
Dim Str

StdOut.WriteLine 	filenamewithoutext
StdOut.WriteLine 	Folder.path
'StdOut.WriteLine "Choice...Choice... "&Choice3

For Each File In Files
	filenamewithoutext = fso.getbasename(File.Name) 
	If inStr(1,File.Name,".") > 0 Then
		fileext				= fso.getextensionname(Folder.path&"\"&File.Name)
	 	if Choice3=1 Then
	 			'If inStr(1,"."&fileext, tag) > 0 Then  
				If fileext=tag or tag="." Then  
				 	filenamewithoutext = fso.getbasename(File.Name)
				 	StdOut.WriteLine "From file "&Folder.path&"\ "&File.Name&" To file 	"&filenamewithoutext&"."&newtag
	 			 	fso.MoveFile Folder.path&"\"&File.Name, Folder.path&"\"&filenamewithoutext&"."&newtag
 	 			 	FilesRenamed = FilesRenamed + 1
 	 			Else
	 	    	    	FilesSkipped = FilesSkipped + 1
     	   		End If
     	Elseif Choice3=2 Then
     	 	   'If inStr(1,"."&fileext, tag) > 0 Then  
			   If fileext=tag or tag="." Then  
					if newtag <> left(File.Name,Len(newtag)) then
									StdOut.WriteLine "From file "&Folder.path&"\"&File.Name&" To file 	" &newtag&"_"&File.Name
									fso.MoveFile Folder.path&"\"&File.Name, Folder.path&"\"&newtag&"_"&File.Name
									FilesRenamed = FilesRenamed + 1
					end if
 	 		 		Else
	 	    	    	FilesSkipped = FilesSkipped + 1
     	   		End If
     	Elseif Choice3=3 Then
     	      	'If inStr(1,"."&fileext, tag) > 0 Then 
				If fileext=tag or tag="." Then  
					if newtag <> Right(filenamewithoutext,Len(newtag)) then
						StdOut.WriteLine "From file "&Folder.path&"\"&File.Name&" To file 	" &filenamewithoutext&"_"&newtag&"."&fileext
						fso.MoveFile Folder.path&"\"&File.Name, Folder.path&"\"&filenamewithoutext&"_"&newtag&"."&fileext
						FilesRenamed = FilesRenamed + 1
					end if
		 		Else
	 	    	    	FilesSkipped = FilesSkipped + 1
     	   		End If
		Elseif Choice3=4 Then
			'If inStr(1,"."&fileext, tag) > 0 Then  
			If fileext=tag or tag="." Then  
				filenamewithoutext = fso.getbasename(File.Name)
				StdOut.WriteLine "From file "&Folder.path&"\ "&File.Name&" To file 	"&filenamewithoutext
				fso.MoveFile Folder.path&"\"&File.Name, Folder.path&"\"&filenamewithoutext
				FilesRenamed = FilesRenamed + 1
			Else
					FilesSkipped = FilesSkipped + 1
			End If
		Elseif Choice3=5 Then
			'If inStr(1,"."&fileext, tag) > 0 Then  
			If fileext=tag or tag="." Then  
				filenamewithoutext = fso.getbasename(File.Name)
				StdOut.WriteLine "From file "&Folder.path&"\ "&File.Name&" To file 	"&lcase(File.Name)
				fso.MoveFile Folder.path&"\"&File.Name, Folder.path&"\"&lcase(File.Name)
				FilesRenamed = FilesRenamed + 1
			Else
					FilesSkipped = FilesSkipped + 1
			End If
		Elseif Choice3=6 Then
			'If inStr(1,"."&fileext, tag) > 0 Then  
			If fileext=tag or tag="." Then  
				filenamewithoutext = fso.getbasename(File.Name)
				StdOut.WriteLine "From file "&Folder.path&"\ "&File.Name&" To file 	"&ucase(File.Name)
				fso.MoveFile Folder.path&"\"&File.Name, Folder.path&"\"&ucase(File.Name)
				FilesRenamed = FilesRenamed + 1
			Else
					FilesSkipped = FilesSkipped + 1
			End If				
     	 
		Elseif Choice3=7 Then
			If not ex_list.Exists(fileext) and inStr(1,File.Name, "File_List_") = 0 Then
			'If inStr(1,"."&fileext, tag) > 0 Then  			
				If fileext=tag or tag="." Then  
						filenamewithoutext = fso.getbasename(File.Name)
						StdOut.WriteLine "From file "&Folder.path&"\"&File.Name&" To file 	"&filenamewithoutext&fileext
						'StdOut.WriteLine  """"&Folder.path&"\"&File.Name&""""
						fso.MoveFile Folder.path&"\"&File.Name, Folder.path&"\"&filenamewithoutext&fileext
						Str = """"&filenamewithoutext&"."&fileext&""""&","&""""&filenamewithoutext&fileext&""""
						writetofile filenamewithoutext&"."&fileext,filenamewithoutext&fileext,"Y"
						FilesRenamed = FilesRenamed + 1			
				Else
					FilesSkipped = FilesSkipped + 1
					writetofile filenamewithoutext&"."&fileext,filenamewithoutext&fileext,"Y",Folder.path

				End If				
			Else
				FilesSkipped = FilesSkipped + 1
				writetofile filenamewithoutext&"."&fileext	,filenamewithoutext&fileext	,"N",Folder.path

			End If							
	
		Elseif Choice3=9 Then
			If (not ex_list.Exists(fileext) and inStr(1,File.Name, "File_List_") = 0) or (inStr(1,File.Name,".") = 0 )	Then
			'If inStr(1,"."&fileext, tag) > 0 Then  			
				If fileext=tag or tag="." or inStr(1,File.Name,".") = 0 Then  
						filenamewithoutext = fso.getbasename(File.Name)
						StdOut.WriteLine "From file "&Folder.path&"\"&File.Name&" To file 	"&filenamewithoutext&fileext&"."&newtag
						'StdOut.WriteLine  """"&Folder.path&"\"&File.Name&""""
						fso.MoveFile Folder.path&"\"&File.Name, Folder.path&"\"&filenamewithoutext&fileext&"."&newtag
							writetofile filenamewithoutext&"."&fileext	,filenamewithoutext&fileext&"."&newtag	,"Y",Folder.path
						FilesRenamed = FilesRenamed + 1			
				Else
					FilesSkipped = FilesSkipped + 1
					writetofile filenamewithoutext&"."&fileext,"-","Y",Folder.path

				End If				
			Else
				FilesSkipped = FilesSkipped + 1
				writetofile filenamewithoutext&"."&fileext	,"-"	,"N",Folder.path

			End If							
		End If	
		
	Elseif (Choice3=0 OR Choice3=9 ) and inStr(1,File.Name,".") = 0 Then
			If fileext=tag or tag="." Then  
				 	filenamewithoutext = fso.getbasename(File.Name)
				 	StdOut.WriteLine "From file "&Folder.path&"\"&File.Name&" To file 	"&filenamewithoutext&"."&newtag
	 			 	fso.MoveFile Folder.path&"\"&File.Name, Folder.path&"\"&filenamewithoutext&"."&newtag
 	 			 	FilesRenamed = FilesRenamed + 1
					
					writetofile filenamewithoutext	,filenamewithoutext&"."&newtag	,"Y",Folder.path

 	 			Else
					FilesSkipped = FilesSkipped + 1
			End If	
	 End If
Next
end sub
sub writetofile (ByVal text,ByVal text2, ByVal text3, ByVal text4)
dim str
' How to write file
Str = """"&text&""""&","&""""&text2&""""&","&""""&text3&""""&","&""""&text4&""""
adhocobjFile.Write Str & vbCr&vbLf
end sub
