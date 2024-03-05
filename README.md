# passphrase

Generate a passphrase using the [diceware](https://theworld.com/~reinhold/diceware.html) word list. 
Three lines will print.
- The first line is the passphase using the diceware word list.
- The second line is the same passphrase but more secure therefore less memorable. It's designed to allow it to easily be enter 
on a mobile devic's "keyboard". It adds one special character, two uppercase letters and two digits. The uppercasing algorithm takes a 
random lower case letter from the original passphrase, upppercases it and overwrites a random lowercase letter. This could
result in just uppercasing a letter but more likely it causes misspellings. This enchanced passphrase is always the same length as the original.
- The third line print the length of the passphrase.

### Usage: ./passphrase dice [dice...]
where [dice] is a five digit number from rolling five die.
Add more words to your passphrase by rolling more five digit numbers (using the dice).

Some optional arguments that can be placed anywhere on the command line:
- d:[number] to insure there are at least [number] digits in the passphrase. Example d:3 will result in three digits in the passphrase
- u:[number] to insure there are at least [number] uppercase letters in the passphrase
- c:[number] to insure there are at least [number] special characters in the passphrase
- f:[filename] rather than using the default diceware word list, use [filename] instead. You still need to roll a five digit number with dice so your word list must contain 7,776 words.

#### Example:
```
   ./passphrase 33264 16546 66436
   hot chump 38th
   hot cTump 38C(
   14 characters
```
