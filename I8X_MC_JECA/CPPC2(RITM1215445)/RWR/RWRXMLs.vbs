Option Explicit

Dim fso, DVS, RuleReport, Diff, intCount, objFSO, diffFile, objTemp   
Dim DVSPath, RuleReportPath, OutputPath, OutputFilePath, colFiles, objFile
Dim outputFile, inputFile, readingText, tempText, tempText1, tempText2

'************************* Getting Inputs from the cmd file '*************************
   
    OutputPath = RTrim((Wscript.Arguments(0)))    
    
'************************* Setting file object variables '************************* 
    Set objFSO = CreateObject("Scripting.FileSystemObject")       
    Set diffFile = objFSO.OpenTextFile(OutputPath,1)        
    
    Do Until diffFile.AtEndOfStream 
        OutputFilePath = diffFile.ReadLine
        Exit Do
    Loop 
    
'************************* Defining the tag details which needs to be search for and write start MEDMLDATA tag to the output file'************************* 
    Set diffFile = objFSO.GetFolder(OutputFilePath)
    Set outputFile = objFSO.CreateTextFile(OutputFilePath & "\RWRXMLs.xml")
    tempText = "<?xml version=" & chr(34) & "1.0" & chr(34) & "?><MEDMLDATA xmlns=" & chr(34) & "PhaseForward-MedML-Inform4" & chr(34) & ">"
    tempText1 = "<?xml version=" & chr(34) & "1.0" & chr(34) & "?>"
    tempText2 = "<MEDMLDATA xmlns=" & chr(34) & "PhaseForward-MedML-Inform4" & chr(34) & ">"
    outputFile.Writeline "<?xml version=" & chr(34) & "1.0" & chr(34) & "?><MEDMLDATA xmlns=" & chr(34) & "PhaseForward-MedML-Inform4" & chr(34) & ">"

'************************* Loop through each and every xml file other than RWRXMLs.xml and take the content of the file except the MEDMLDATA tags and write into the RWRXMLs.xml file '****************
    Set colFiles = diffFile.Files
    For Each objFile in colFiles
        If Right(objFile.Name,4) = ".xml" and objFile.Name <> "RWRXMLs.xml" Then
            DVSPath = OutputFilePath & "\" & objFile.Name
            Set inputFile = objFSO.OpenTextFile(DVSPath,1)
            Do Until inputFile.AtEndOfStream 
                readingText = inputFile.ReadLine
                readingText = Trim(readingText)
                If readingText <> tempText and readingText <> tempText1 and readingText <> tempText2 and readingText <> "</MEDMLDATA>" Then
                    outputFile.Writeline readingText
                End If                
            Loop  
            inputFile.Close
        End If
    Next
'************************* Write close MEDMLDATA tag in the output file '*************************    
    outputFile.Writeline "</MEDMLDATA>"
'********************Close file, connection and recordset objects 

Sub CleanObjects()
        'Close opened xml file
    outputFile.Save
    outputFile.Close
End Sub