import std/os, packy 
ForceOverwrite = true 
packDep(r"E:\Programing\01_sandbox\wordGame\out\spellingGame.exe") 
packDep(r"E:\Programing\01_sandbox\wordGame\Dep\Win64\OpenAL32.dll","","windows","amd64") 
discard execShellCmd("spellingGame.exe")