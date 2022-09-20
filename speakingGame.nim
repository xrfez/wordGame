import std/[random, times, terminal, os], slappy, packy, words/words

type
  Question = tuple
    word: string
    sound: Sound

proc initQuestions(): seq[Question] =
  for idx in 0..wordList.len - 1:
    result.add (wordList[idx], newSound(joinPath(currentSourcePath.parentDir(),
        "sounds", wordList[idx] & ".wav")))

proc exit(input: string): bool =
  if input != "q": return false
  return true

proc restart(input: string): bool =
  if input != "r": return false
  return true

proc hint(input: string): bool =
  if input != "h": return false
  return true

proc detailedTime(seconds: float): string =
  result &= $(seconds / 60.0).toInt
  result &= " minutes "
  result &= $(seconds.toInt mod 60)
  result &= " seconds.  "

template resetVariables() =
  remainingQuestions = initQuestions()
  errorCount = 0
  start = cpuTime()

template processInput() =
  inputString = readLine(stdin)
  if inputString.exit: break
  if inputString.restart: resetVariables()

# why cant this be nested in a proc
slappyInit()

proc main() =
  var
    remainingQuestions = initQuestions()
    start = cpuTime()
    errorCount: int
    inputString: string
  let
    prompt = "Enter 'h' to hear the word"
    win = "You have Completed all Spelling Words.  GREAT JOB!"


  randomize()
  while true:
    eraseScreen()
    setCursorPos(0, 0)

    let idx = rand(0..remainingQuestions.len - 1)
    echo prompt
    styledEcho styleBright, styleUnderscore, fgYellow,
        remainingQuestions[idx].word
    processInput()
    if inputString.restart: continue
    if inputString.hint: discard remainingQuestions[idx].sound.play()

    # Ask again
    while inputString.len > 0:
      if inputString.hint:
        discard remainingQuestions[idx].sound.play()
      errorCount += 1
      processInput()
      if inputString.exit: break
      if inputString.restart: break
    if inputString.exit: break
    if inputString.restart: continue

    # Carry On
    discard remainingQuestions[idx].sound.play()
    sleep(remainingQuestions[idx].sound.duration.int * 1000)
    if remainingQuestions.len > 0:
      remainingQuestions.delete(idx)

    # Win Condition
    if remainingQuestions.len == 0:
      styledEcho styleBright, fgGreen, win
      styledEcho styleBright, fgGreen,
          "Task Completed in " & detailedTime(cpuTime() - start) &
          "Errors:  " & $errorCount
      inputString = readLine(stdin)
      if inputString.exit: break
      resetVariables()

when isMainModule:
  packDep(r"E:\Programing\01_sandbox\wordGame\Dep\Win64\OpenAL32.dll")
  packDep(r"E:\Programing\01_sandbox\wordGame\LICENSE", "License")
  iterateSeq(word, wordList):
    packDep(r"E:\Programing\01_sandbox\wordGame\sounds\" & word & ".wav", "sounds")
  slappyInit()
  main()
