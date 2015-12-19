${SegmentFile}

${OverrideExecute}
	${DebugMsg} "About to execute the following string and wait till it's done: $ExecString"
	${EmptyWorkingSet}
	ClearErrors
	ExecShell "" $ExecString
	${DebugMsg} "$ExecString has finished."
	
	;Wait till it's done
	ClearErrors
	${GetFileName} $ProgramExecutable $1
	${DebugMsg} "Waiting till any other instances of $1 and any [Launch]:WaitForEXE[N] values are finished."
	${EmptyWorkingSet}
	${Do}
		${ProcessWaitClose} $1 -1 $R9
		${IfThen} $R9 > 0 ${|} ${Continue} ${|}
		StrCpy $0 1
		${Do}
			ClearErrors
			${ReadLauncherConfig} $2 Launch WaitForEXE$0
			${IfThen} ${Errors} ${|} ${ExitDo} ${|}
			${ProcessWaitClose} $2 -1 $R9
			${IfThen} $R9 > 0 ${|} ${ExitDo} ${|}
			IntOp $0 $0 + 1
		${Loop}
	${LoopWhile} $R9 > 0
	${DebugMsg} "All instances are finished."
!macroend