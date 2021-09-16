@echo **********author Leelarakesh reddy*************
@echo.
@echo Select the Type of function
@echo 0 add the extension 
@echo 1 Change the extension 
@echo 2 Prefix to the filename
@echo 3 Suffix to Filename
@echo 4 remove extension
@echo 5 change to lowercase
@echo 6 change to uppercase
@echo 7 Remove . and concatenate extension to file
@echo 9 Remove . and add new extension to file
@echo.
@set /p choice1=[Enter the Choice]
@echo.
@IF  %choice1% NEQ  9 (@SET /p OldExt=[Enter the OldExt or ext of files to be renamed "." for all files ])  ELSE (@SET "OldExt=.")
@echo.
@IF  %choice1% LSS  4 (@SET /p NewExt=[Enter the NewExt or the prefix or suffix value] ) ELSE (@SET "NewExt=A")
@IF  %choice1% EQU  9 (@SET /p NewExt=[Enter the NewExt or the prefix or suffix value] ) ELSE (@SET "NewExt=A")      
@echo %OldExt%==%NewExt%==%choice1%
cscript file_Rename_latest.vbs %OldExt% %NewExt% %choice1%
Pause

