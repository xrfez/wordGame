import std/[random, times, terminal, os], slappy, packy, words/words

type
  Question = tuple
    word: string
    sound: Sound

proc initQuestions(): seq[Question] =
  for idx in 0..wordList.len - 1:
    result.add (wordList[idx], newSound(joinPath(getAppDir(),
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

proc sound(input: string): bool =
  if input != "p": return false
  return true

proc detailedTime(seconds: float): string =
  result &= $(seconds / 60.0).toInt
  result &= " minutes "
  result &= $(seconds.toInt mod 60)
  result &= " seconds.  "

proc squareBracket(input: string): string =
  result = "[" & input & "]"

template resetVariables() =
  remainingQuestions = initQuestions()
  errorCount = 0
  start = cpuTime()

template processInput() =
  inputString = readLine(stdin)
  if inputString.exit: break
  if inputString.sound: errorCount -= 1
  if inputString.restart: resetVariables()


proc main() =
  var
    remainingQuestions = initQuestions()
    start = cpuTime()
    errorCount: int
    inputString: string
  let
    wrongAnswer = "That was not correct. Type 'h' for a hint. /nType 'p' to hear the word again."
    win = "You have Completed all Spelling Words.  GREAT JOB!"

  randomize()
  while true:
    eraseScreen()
    setCursorPos(0, 0)

    let idx = rand(0..remainingQuestions.len - 1)
    styledEcho styleBright, styleUnderscore, fgYellow,
        "Spell the Word. (Type 'p' to hear the word again)"
    discard remainingQuestions[idx].sound.play()
    processInput()
    if inputString.restart: continue
    if inputString.sound: discard remainingQuestions[idx].sound.play()

    # Ask again
    while inputString != remainingQuestions[idx].word:
      if inputString.hint:
        styledEcho styleBright, fgCyan, squareBracket(
            remainingQuestions[idx].word)
      else: styledEcho styleBright, fgRed, wrongAnswer
      errorCount += 1
      processInput()
      if inputString.exit: break
      if inputString.restart: break
      if inputString.sound: discard remainingQuestions[idx].sound.play()
    if inputString.exit: break
    if inputString.restart: continue

    # Carry On
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
  packDep(r"E:\Programing\01_sandbox\wordGame\LICENSE", "License")
  packDep(r"E:\Programing\01_sandbox\wordGame\Dep\Win64\OpenAL32.dll")
  iterateSeq(word, wordList):
    packDep(r"E:\Programing\01_sandbox\wordGame\sounds\" & word & ".wav", "sounds")
  slappyInit()
  main()




