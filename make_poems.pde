// This function will use the stanza patterns created by makeStanzaPatterns() to
// generate the two sets of 16 poems from first the linguistic lists (which will make
// set 3), then the original poems (to make set 4).

void makePoemSet(int setNumber) {
  if (setNumber == 3) {
    // Create new ArrayList for all sixteen poem source lists
    poemSourceListsLinguistic = new ArrayList();

    // Populate each Arraylist element with the poem source lists
    for (int i=0; i < numberOfPoems; i++) {
      String[] aPoemSourceList = loadStrings("/poems/linguistic/linguistic" + (i+1) + ".txt");
      poemSourceListsLinguistic.add(aPoemSourceList);
    }

    // Run this 16 times (top level, creates each poem)
    for (int i=0; i < numberOfPoems; i++) {
      // Create new array to hold 4 stanzas of 4 patterned lines (same stanza pattern
      // for all stanzas in 16-line poem).
      
      // Get the stanza pattern for each poem
      int[] aStanzaPattern = new int[patternSlots];
      aStanzaPattern = (int[])stanzaPatterns.get(i);

      // Next two loops will sort through all 16 poemSourceLists entries to pull
      // lines, based on the stanza patterns generated earlier, from the corresponding
      // source files (either the original poems or linguistic lists). Note that the
      // stanza patterns indicate which source file a new line should be drawn from.
      // After a line is used, it is then altered to ensure there are no duplicates.
      
      // This loop (second level) runs four times to assemble the four stanzas of each poem
      for (int j=0; j < numberOfStanzas; j++) {
        // This loop runs four times to assemble the four lines of each stanza
        for (int k=0; k < LinesPerStanza; k++) {
          // Locate the correct stanza pattern value
          int aLinePatternValue = (aStanzaPattern[k] - 1);
          // Create a string array to hold all of the stanza
          String[] aPoemSource = new String[numberOfLines];
          aPoemSource = poemSourceListsLinguistic.get(aLinePatternValue);
          
          // Now grab a random line from the source file indicated by the stanza pattern
          int lineValueToUse = (int) random(16);
          String lineBeingUsed = aPoemSource[lineValueToUse];
          
          // Check to see if the line has been used already
          hasLineBeenUsed(lineBeingUsed);

          // This will now loop and grab other random lines until a line which has not
          // been used is located
          while (hasLineBeenUsed(lineBeingUsed) == true) {
            lineValueToUse = (int) random(16);
            lineBeingUsed = aPoemSource[lineValueToUse];
            hasLineBeenUsed(lineBeingUsed);
          }

          // Add each unique line to the allPatternedPoemLines StringList
          allPatternedPoemLinesLinguistic.append(lineBeingUsed);

          // Now replace the String in aPoemSource at index lineValueToUse with "USED"
          // so that it will not be selected again.
          aPoemSource[lineValueToUse] = "USED";

          // Now replace the original poemsSourceLists array (which has just been used as aPoemSource)
          // in the ArrayList with the ammended aPoemSource, then send the lineValueToUse to an array
          // so I can cast the hexagrams later.
          poemSourceListsLinguistic.set(aLinePatternValue, aPoemSource);
          lineValuesForHexGenLinguistic.append(lineValueToUse);
        }
      }
    }
  } else if (setNumber == 4) {
    
    // Note: See comments in if statement above for comments on this section. The only differences
    // between this else if statement and it are (1) the setNumber is 4 now, and (2) the function
    // now uses the original poems as sources and outputs data that will be used to generate hexagrams
    // for the shuffled original poems later.
    
    poemSourceListsOriginal = new ArrayList();
    for (int i=0; i < numberOfPoems; i++) {
      String[] aPoemSourceList = loadStrings("/poems/original/original" + (i+1) + ".txt");
      poemSourceListsOriginal.add(aPoemSourceList);
    }
    for (int i=0; i < numberOfPoems; i++) {
      int[] aStanzaPattern = new int[patternSlots];
      aStanzaPattern = (int[])stanzaPatterns.get(i);
      for (int j=0; j < numberOfStanzas; j++) {
        for (int k=0; k < LinesPerStanza; k++) {
          int aLinePatternValue = (aStanzaPattern[k] - 1);
          String[] aPoemSource = new String[numberOfLines];
          aPoemSource = poemSourceListsOriginal.get(aLinePatternValue);
          int lineValueToUse = (int) random(16);
          String lineBeingUsed = aPoemSource[lineValueToUse];
          hasLineBeenUsed(lineBeingUsed);
          // This will now loop until a line which has not been used is located
          while (hasLineBeenUsed (lineBeingUsed) == true) {
            lineValueToUse = (int) random(16);
            lineBeingUsed = aPoemSource[lineValueToUse];
            hasLineBeenUsed(lineBeingUsed);
          }
          allPatternedPoemLinesOriginal.append(lineBeingUsed);
          aPoemSource[lineValueToUse] = "USED";
          poemSourceListsOriginal.set(aLinePatternValue, aPoemSource);
          lineValuesForHexGenOriginal.append(lineValueToUse);
        }
      }
    }
  }
}

// Check to see if a line has been used by makePoem() (in for loop k)
boolean hasLineBeenUsed(String aLine) {
  if (aLine == "USED") {
    return true;
  } else {
    return false;
  }
}
