// These functions will generate stanza patterns for a 16-poem set
// of shuffled poems.

// There are some contraints to account for with the full set of these
// stanza patterns. 16 stanza patterns of 4 numbers between 1 and 16
// are to be generated, and each set must have no repeated values. Also,
// so that all source files are accessed 4 times by makePoems later on,
// all of the first elements of each list must be non-repeating integers
// between 1 and 16; otherwise, the program would try to draw too many
// lines from some source files and not enough from others.

// So, first I will make four shuffled arrays of 1-16 with no repeating values.
void makeStanzaPatternSlotArrays() {
  // Generate a stanza pattern (an intlist of 4 ints between 1 and 16)
  randomizedPatternSlotsIntList = new IntList();
  // Populate IntList with 0-16
  for (int i=1; i < 17; i++) {
    randomizedPatternSlotsIntList.append(i);
  }
  // Randomize the order of elements in the IntList
  randomizedPatternSlotsIntList.shuffle();
  // Convert first shufled IntList to Array
  randomizedPatternSlotsArray1 = randomizedPatternSlotsIntList.array();
  // Randomize the order of elements in the IntList again
  randomizedPatternSlotsIntList.shuffle();
  // Convert second shuffled IntList to Array
  randomizedPatternSlotsArray2 = randomizedPatternSlotsIntList.array();
  // Randomize the order of elements in the IntList
  randomizedPatternSlotsIntList.shuffle();
  // Convert third shuffled IntList to Array
  randomizedPatternSlotsArray3 = randomizedPatternSlotsIntList.array();
  // Randomize the order of elements in the IntList again
  randomizedPatternSlotsIntList.shuffle();
  // Convert fourth shuffled IntList to Array
  randomizedPatternSlotsArray4 = randomizedPatternSlotsIntList.array();
}

// This function will assemble the 16 four-element stanza pattern arrays from
// the arrays generated in makeStanzaPatternSlotArrays().
void makeStanzaPatterns() {
  stanzaPatterns = new ArrayList();
  for (int i=0; i < numberOfPoems; i++) {
    // Create a new integer array of 4 elements
    int[] aStanzaPattern = new int[patternSlots];
    // Populate new array with correct index from Stanza Patterns Slot Arrays
    for (int j=0; j<patternSlots; j++) {
      // Make sure the loop pulls index value j from the correct randomizedPatternSlotsArray
      int [] stanzaPatternSlotArrayNumber = new int[numberOfPoems];
      if (j == 0) arrayCopy(randomizedPatternSlotsArray1, stanzaPatternSlotArrayNumber);
      else if (j == 1) arrayCopy(randomizedPatternSlotsArray2, stanzaPatternSlotArrayNumber);
      else if (j == 2) arrayCopy(randomizedPatternSlotsArray3, stanzaPatternSlotArrayNumber);
      else if (j == 3) arrayCopy(randomizedPatternSlotsArray4, stanzaPatternSlotArrayNumber);
      aStanzaPattern[j] = stanzaPatternSlotArrayNumber[i];
    }
    // Add the stanza pattern to the ArrayList of all stanza patterns
    stanzaPatterns.add(aStanzaPattern);
  }
}

// This function checks all arrays against each other for duplicate index values.
// This will ensure that the stanza patterns will have four unique values, and
// that each of the sixteen lists is only drawn 4 times, resulting in 16 lines
// being used.
void checkForDuplicateArrayIndices() {
  for (int i=0; i<16; i++) {
    if (randomizedPatternSlotsArray1[i] == randomizedPatternSlotsArray2[i]) {
      DuplicateIndices = DuplicateIndices +1;
    } else if (randomizedPatternSlotsArray1[i] == randomizedPatternSlotsArray3[i]) {
      DuplicateIndices = DuplicateIndices +1;
    } else if (randomizedPatternSlotsArray1[i] == randomizedPatternSlotsArray4[i]) {
      DuplicateIndices = DuplicateIndices +1;
    } else if (randomizedPatternSlotsArray2[i] == randomizedPatternSlotsArray3[i]) {
      DuplicateIndices = DuplicateIndices +1;
    } else if (randomizedPatternSlotsArray2[i] == randomizedPatternSlotsArray4[i]) {
      DuplicateIndices = DuplicateIndices +1;
    } else if (randomizedPatternSlotsArray3[i] == randomizedPatternSlotsArray4[i]) {
      DuplicateIndices = DuplicateIndices +1;
    }
  }
}
