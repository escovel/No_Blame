// These functions export the generated poems, the list of titles, and various data for debugging.

// Export the two generated poem sets to the poems directory alongside the sets they were generated from.

void exportFinalPoemSets(int setNumber) {
  // Retrieve each final poem from the patternedPoems StringList as a string array,
  // then export the final poems to numbered text files.
  if (setNumber == 3) {
    for (int i=0; i<numberOfPoems; i++) {
      String[] aPatternedPoem = new String[numberOfLines];
      for (int j=0; j<numberOfLines; j++) {
        aPatternedPoem[j] = allPatternedPoemLinesLinguistic.get(j + (i*16));
      }
      // Create a new file name for each poem, numbered by the loop counter.
      String poemFileName = "linguistic-shuffled-poem" + (i+1) + ".txt";
      // Use saveStrings to save the String[] arrays to individual TXT files.
      saveStrings("poems/linguistic-shuffled/" + poemFileName, aPatternedPoem);
    }
  } else if (setNumber == 4) {
    for (int i=0; i<numberOfPoems; i++) {
      String[] aPatternedPoem = new String[numberOfLines];
      for (int j=0; j<numberOfLines; j++) {
        aPatternedPoem[j] = allPatternedPoemLinesOriginal.get(j + (i*16));
      }
      // Create a new file name for each poem, numbered by the loop counter.
      String poemFileName = "original-shuffled-poem" + (i+1) + ".txt";
      // Use saveStrings to save the String[] arrays to individual TXT files.
      saveStrings("poems/original-shuffled/" + poemFileName, aPatternedPoem);
    }
  }
}

// Export the stanza pattern lists as a StringList to be exported for debugging.

void exportStanzaPatternsArray(int setNumber) {
  String[] stanzaPatternsExport = new String[16];
  
  // Convert the stanza pattern ArrayList into strings to be exported to text files
  for (int i=0; i<numberOfPoems; i++) {
    int[] aStanzaPattern = (int[]) stanzaPatterns.get(i);
    String printPatterns = "The Pattern for Poem " + (i + 1) + " will draw lines from lists: [";
    for (int j=0; j<aStanzaPattern.length; j++) { 
      printPatterns += (aStanzaPattern[j] + ", ");
    }
    stanzaPatternsExport[i] = printPatterns + "]";
  } 
  if (setNumber == 3) saveStrings("poems/linguistic-shuffled/stanzaPatterns.txt", stanzaPatternsExport);
  else if (setNumber == 4) saveStrings("poems/original-shuffled/stanzaPatterns.txt", stanzaPatternsExport);
}

// Export the list of hexagram tags to a text file for debugging

void exportHexagramTags() {
// Export the StringList hexagramTags for debugging.
  generatedHexArray = hexagramTags.array();
  // Add numbers to the list for clarity.
  for (int i=0; i<64; i++) {
    generatedHexArray[i] = "Poem " + (i + 1) + " Hexagram Tag: " + generatedHexArray[i];
  }
  saveStrings("generatedHexagrams.txt", generatedHexArray);
}

// Export the titles for each poem, which are the names of the hexagrams cast and assigned to each poem.

void exportPoemTitlesFromHexagrams() {  
  // Export the list of titles for each poem by locating the index value for each element of generatedHexArray
  // in unique64HexagramTags then writing the contents of the matching index value in unique64HexagramTagNames
  for (int i=0; i<64; i++) {
    for (int j=0; j<64; j++) {
      if (hexagramTags.get(i).equals(unique64HexagramTags.get(j))) {
        int poemNum = i + 1; 
        poemTitlesFromHexagrams[i] = "Poem " + poemNum + " Title:  " + unique64HexagramTagNames.get(j);
      }
    }
  }
  saveStrings("poemTitlesFromHexagrams.txt", poemTitlesFromHexagrams);
}
