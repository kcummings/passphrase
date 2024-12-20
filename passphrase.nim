import std/sequtils
import std/tables
import std/strutils
import std/cmdline
import std/random
import system

randomize()

template abort(msg: string) =
  echo msg
  quit(QuitFailure)

func isValidDiceRoll(diceroll: string): bool =
  len(diceroll) == 5 and count(diceroll, {'1'..'6'}) == 5

proc replaceLowerLetterWith(line, options: string): string =
  # Replace a random lowercase letter in line with a random character from options.
  # True randomness by using dice is not needed here.
  let r = rand(len(options)-1)
  let c = options[r]   # grab a random character from options
  var i = rand(len(line)-1)  # start "placement" at a random position
  result = line
  while not line[i].isLowerAscii():
    inc i
    if i >= len(line):
      i = 0   # wrapping around will guarantee we'll find a letter
  result[i] = c

proc addEntropy(ps, insertChars: string, maxInsertions: int): string =
  result = ps
  let cnt = count(result, insertChars)
  for _ in cnt..maxInsertions-1:
    result = replaceLowerLetterWith(result, insertChars)

proc extractNumber(arg: string): int =
  # arg is of form:  x:n where x is u|d|c and n is a number we are returning
  try:
    let num = parseInt(arg[2..^1])
    return num
  except:
    abort "Expecting pattern u:[number], d:[number] or c:[number]   Got " &  arg
    
# Assume user is using dice to generate 5 digit random numbers for each word choosen.
var numDigitsinPhrase = 2
var numUpperLettersinPhrase = 2
var numSpecialCharsinPhrase = 1
var wordlist_file = "diceware_wordlist.txt"
var dicerolls: seq[string]
for arg in commandLineParams():
  if arg[0..1].toLowerAscii == "f:":
    wordlist_file = arg[2..^1]
  elif arg[0..1].toLowerAscii == "d:":
    numDigitsinPhrase = extractNumber(arg)
  elif arg[0..1].toLowerAscii == "u:":
    numUpperLettersinPhrase = extractNumber(arg)
  elif arg[0..1].toLowerAscii == "s:":
    numSpecialCharsinPhrase = extractNumber(arg)
  elif isValidDiceRoll(arg):
    dicerolls.add(arg)
  else:
    abort arg & " is an invalid diceroll or an unknown argument"

var wordlist = initTable[string, string]()
for line in lines(wordlist_file):
  let words = line.split('\t')
  wordlist[words[0]] = words[1]

var passphrase = ""
for diceroll in dicerolls:
  passphrase = passphrase & wordlist[diceroll] & " "
passphrase = passphrase.strip()
echo passphrase # first version directly from word list

if count(passphrase, LowercaseLetters) < numSpecialCharsinPhrase + numDigitsinPhrase + numUpperLettersinPhrase + 1:
  abort "Not enough lowercase letters to add more entropy! Add more words."

### ADD MORE ENTROPY by adding random chars from the passed string ###
passphrase = passphrase.addEntropy("23456789", numDigitsinPhrase).
                        addEntropy("@#$_&-+()", numSpecialCharsinPhrase). # Paypal only accepts these special characters: !@#$%^&*()
                        addEntropy(toSeq('A'..'Z').join(), numUpperLettersinPhrase)
echo passphrase     # modified with more enthropy
echo len(passphrase), " characters"
