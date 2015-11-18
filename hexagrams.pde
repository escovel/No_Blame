/*  Hexagram generation
 
 These functions will query random line values of each poem for whether they are even or odd, then add those results
 to generate one of the four possible lines (see chart below), much like the standard coin tossing casting method.
 If the line value is even, 3 will be added to the count; if odd, then 2 will be added.
 
 6 = --- X ---  (divided changing)
 7 = ---------  (solid)
 8 = ---   ---  (divided)
 9 = ----O----  (solid changing)
 
 */

// Initialize variables
int LowerYPosOffset = 90;
int castingSum;
int lineNumber;
int lineXPos = 20;
int lineYPos = 190;
int adjustedLineYPos;
int oneCastingValue;
PFont font;
int aLineValue = 0;
String[] generatedHexArray;
String aHexagramTag = "";
String[] poemTitlesFromHexagrams = new String[64];

// Create counter for the hexagram casting loop to see how many times it runs before
// generating all 64 hexagrams.
int hexGenCounter = 0;

void castHexagrams() {

  // Note: For the first two sets, I don't need to get lineValuesForHexGen_____.
  // I can just use (the array index value + 1) for an array of each poem / linguistic list.
  // For the second two sets, get values from lineValuesForHexGen_____.
  // Populate lineValuesForHexGenUnshuffledSets with 256 elements, 1-16 repeated 16 times
  for (int i=0; i<16; i++) {
    for (int j=0; j<16; j++) {
      lineValuesForHexGenUnshuffledSets.append(j);
    }
  }

  // This IntList will ensure that each set uses the correct lineValuesForHexGen_____ values.
  IntList thisSetForHexGen = new IntList();

  // Initialize the setNumber for the first set.
  int setNumber = 1;
  // Loop until hexagrams for all sets have been cast.
  while (setNumber != 5) {
    if (setNumber == 1) {
      // Make the hexagrams for set one, the original poems.
      thisSetForHexGen = lineValuesForHexGenUnshuffledSets;
    } else if (setNumber == 2) {
      // Make the hexagrams for set two, the linguistic lists.
      thisSetForHexGen = lineValuesForHexGenUnshuffledSets;
    } else if (setNumber == 3) {
      // Make the hexagrams for set three, the shuffled linguistic poems.
      thisSetForHexGen = lineValuesForHexGenLinguistic;
    } else if (setNumber == 4) {
      // Make the hexagrams for set four, the shuffled original poems.
      thisSetForHexGen = lineValuesForHexGenOriginal;
    }

    // Create an ArrayList from thisSetForHexGen
    ArrayList<int[]> poemsLineValues = new ArrayList<int[]>();
    for (int i=0; i<16; i++) {
      int[] aPoemsLineValues = new int[16];
      for (int j=0; j<16; j++) {
        int aPoemLineValue = thisSetForHexGen.get(j+(i*16));
        aPoemsLineValues[j] = aPoemLineValue;
      }
      poemsLineValues.add(aPoemsLineValues);
    }
    
    // Check random lines from each poem (each set of 16 values from poemLineValuesForHexagramGenArray)
    // to get castingSum for each line to be drawn.
    for (int i=0; i<16; i++) {
      // Clear the background each time through for drawHexLine()
      background(255);
      // Get correct set of 16 values from poemLineValues.
      int[] thisPoemsLineValues = new int[16];
      thisPoemsLineValues = (int[]) poemsLineValues.get(i);      
      // Draw each hexagram and export PNG to /poem/hexagrams directory, numbered the same as
      // the corresponding poem number across all four sets (i.e. 1-64).
      for (int j=0; j<6; j++) {
        castingSum = 0;   
        for (int k=0; k<3; k++) {
          if (k == 0) {
            // Make the link between the poem casting results and the hexagram casting results
            // stronger for first toss. I will use one of the first two line values. 
            int randNum2 = (int) random(2);
            int aLineValue = thisPoemsLineValues[randNum2];
            if ((isEven(aLineValue) == true)) oneCastingValue = 3;
            else if ((isEven(aLineValue) == false)) oneCastingValue = 2;
          } else {
            // Introduce a "wild card" element this time with a random line value from the poem
            int randNum16 = (int) random(16);
            int aLineValue = thisPoemsLineValues[randNum16];
            if ((isEven(aLineValue) == true)) oneCastingValue = 3;
            else if ((isEven(aLineValue) == false)) oneCastingValue = 2;
          }
          castingSum += oneCastingValue;
        }
        // Use tagHexagramLines funtion to create hexagram tags
        tagHexagram(castingSum, j); // Get the hexagram tag for each line
        aHexagramTag += aHexagramTagChar; // Add each character to the tag (creating a 6 character tag by the end of this loop)

        // Draw the Hexagram line by line
        drawHexLine(castingSum, j);
      }

      // Increment hexGenCounter each time a hexagram is cast and tagged
      hexGenCounter += 1;

      // Export the Hexagram Image
      String exportFilename = "poems/hexagrams/hexagram" + ((i+1) + ((setNumber-1) * 16)) + ".png";
      saveFrame(exportFilename);
      
      // Check to see if hexagram has already been cast. Recast if it is already in hexagramTags.
      if (hexagramTags.hasValue(aHexagramTag) == true) {
        i -= 1;
      } else {
        // Add this hexagram tag to the list of generated hexagram tags
        hexagramTags.append(aHexagramTag);  
        // Display the number of iterations required to generate each hexagram
        println(hexGenCounter + " hexagrams were cast to find unique hexagram " + (i + ((setNumber-1) * 16)));
        hexGenCounter = 0;
      }
       
      // Clear aHexagramTag for the next generation
      aHexagramTag = "";
    }
    // Increment setNumber by 1 so the while loop moves to the next set of 16 poems
    setNumber += 1;
  }
}

// A simple function to check if an integer is even or odd. Used by castHexagrams().

boolean isEven (int aNumber) {
  if ((aNumber & 1) ==0) return true;
  else return false;
}

// This function is used by castHexagrams() to generate unique 6-character "tags" to each hexagram.
// The function will take as input the castingSum for each line and return the translated tag character.

// The hexagram tags are composed of ascending values from the bottom line (first) to the top (last).
// Broken lines will be represent by a letter a-f, and solid lines an integer 1-6.

// Initialize StringList for hexagram tags.
char solidLines[] = {'1','2','3','4','5','6'};
char brokenLines[] = {'a','b','c','d','e','f'};
StringList hexagramTags = new StringList();
char aHexagramTagChar;

char tagHexagram(int castingSum, int lineNumber) {
  // If the line is divided/broken, place a letter in the hexagram tag.
  if (castingSum == 6 || castingSum == 8) {
    aHexagramTagChar = brokenLines[lineNumber];
    // Otherwise, place an integer.
  } else if (castingSum == 7 || castingSum == 9) {
    aHexagramTagChar = solidLines[lineNumber];
  }
  return aHexagramTagChar;
}

// Draw each line of the hexagram as it is cast by castHexagrams(). This is exported
// as a PNG file within castHexagrams().

void drawHexLine(int castingSum, int lineNumber) {
  adjustedLineYPos = lineYPos-(lineNumber*32);
  strokeWeight(0);
  if (castingSum == 6) {
    fill(20);
    rect(lineXPos, adjustedLineYPos, 72, 4);
    rect(lineXPos+108, adjustedLineYPos, 72, 4);
    strokeWeight(4);
    line(width/2 - 10, adjustedLineYPos - 10, width/2 + 10, adjustedLineYPos + 10);
    line(width/2 + 10, adjustedLineYPos - 10, width/2 - 10, adjustedLineYPos + 10);
  } else if (castingSum == 7) {
    fill(20);
    rect(lineXPos, adjustedLineYPos, 180, 4);
  } else if (castingSum == 8) {
    fill(20);
    rect(lineXPos, adjustedLineYPos, 72, 4);
    rect(lineXPos+108, adjustedLineYPos, 72, 4);
  } else if (castingSum == 9) {
    fill(20);
    rect(lineXPos, adjustedLineYPos, 180, 4);
    textSize(32);
    text("O", width/2-12, adjustedLineYPos+14);
  }
}

// Now make sure that the set that has been generated is actually a full set of
// all 64 hexagrams with none repeated.

StringList hexComparisonList = new StringList();

void isSetComplete64Hexagrams() {
  for (int i=0; i<64; i++) {
    // Check if each generated hexagram tag is in the unique64HexagramTags list.
    // Send all results to a comparison list.
    hexComparisonList.append(str(hexagramTags.hasValue(unique64HexagramTags.get(i))));
  }
  if (hexComparisonList.hasValue("false") == true) {
    println("Oh no! The generated set of hexagrams IS NOT a complete set.");
  } else {
    println("Hurray! The generated set of hexagrams IS a complete set.");
  }
}

// These two StringLists below contain (1) the full set of hexagram tags
// for all possible hexagrams, and (2) the names and order as found in
// the Wilhelm/Baynes translation of the I Ching.

// The ordering of indices in the StringLists is taken from the order of the
// hexagrams as provided in the index of the Wilhelm/Baynes version as well
// (they appear in different orders in the index and book proper).

// The String array is being converted into a StringList here to take
// advantage of the hasValue() function available to StringLists.

final StringList unique64HexagramTags = new StringList(new String[] {
  "123456", // 1
  "a23456", 
  "1b3456", 
  "12c456", 
  "123d56", // 5
  "1234e6", 
  "12345f", 
  "ab3456", 
  "1bc456", // 9
  "12cd56", 
  "123de6", 
  "1234ef", 
  "a2c456", // 13
  "1b3d56", 
  "12c4e6", 
  "123d5f", 
  "a23d56", // 17 
  "1b34e6", 
  "12c45f", 
  "a234e6", 
  "1b345f", // 21
  "a2345f", 
  "abc456", 
  "1bcd56", 
  "12cde6", // 25
  "123def", 
  "a2cd56", 
  "1b3de6", 
  "12c4ef", // 29
  "ab3d56", 
  "1bc4e6", 
  "12cd5f", 
  "a23de6", // 33
  "1b34ef", 
  "ab34e6", 
  "1bc45f", 
  "a234ef", // 37
  "ab345f", 
  "a2c45f", 
  "a23d5f", 
  "1b3d5f", // 41
  "a2c4e6", 
  "abcd56", 
  "1bcde6", 
  "12cdef", // 45
  "a2cde6", 
  "1b3def", 
  "ab3de6", 
  "1bc4ef", // 49
  "abc4e6", 
  "1bcd5f", 
  "a23def", 
  "ab34ef", // 53
  "abc45f", 
  "a2cd5f", 
  "ab3d5f", 
  "a2c4ef", // 57 
  "1bcdef", 
  "a2cdef", 
  "ab3def", 
  "abc4ef", // 61
  "abcd5f", 
  "abcde6", 
  "abcdef"
}
);

// This StringList contains all of the names and titles of the hexagrams,
// listed in the same order as the StringList above so they can easily be
// accessed later.

final StringList unique64HexagramTagNames = new StringList(new String[] {
  "1. Ch'ien :: The Creative", // 1
  "44. Kou :: Coming to Meet", 
  "13. T'ung Jen :: Fellowship with Men", 
  "10. Lu :: Treading [Conduct]", 
  "9. Hsiao Ch'u :: The Taming Power of the Small", // 5
  "14. Ta Yu :: Possession in Great Measure", 
  "43. Kuai :: Break-through (Resoluteness)", 
  "33. Tun :: Retreat", 
  "25. Wu Wang :: Innocence (The Unexpected)", // 9
  "61. Chung Fu :: Inner Truth", 
  "26. Ta Ch'u :: The Taming Power of the Great", 
  "34. Ta Chuang :: The Power of the Great", 
  "6. Sung :: Conflict", // 13
  "37. Chia Jen :: The Family [The Clan]", 
  "38. K'uei :: Opposition", 
  "5. Hsu :: Waiting (Nourishment)", 
  "57. Sun :: The Gentle (The Penetrating, Wind)", // 17 
  "30. Li :: The Clinging, Fire", 
  "58. Tui :: The Joyous, Lake", 
  "50. Ting :: The Caldron", 
  "49. Ko :: Revolution (Molting)", // 21
  "28. Ta Kuo :: Preponderance of the Great", 
  "12. P'i :: Standstill [Stagnation]", 
  "42. I :: Increase", 
  "41. Sun :: Decrease", // 25
  "11. Ta'i :: Peace", 
  "59. Huan :: Dispersion [Dissolution]", 
  "22. Pi :: Grace", 
  "54. Kuei Mei :: The Marrying Maiden", // 29
  "53. Chien :: Development (Gradual Progress)", 
  "21. Shih Ho :: Biting Through", 
  "60. Chieh :: Limitation", 
  "18. Ku : Work on What Has Been Spoiled [Decay]", // 33
  "55. Feng :: Abundance [Fullness]", 
  "56. Lu :: The Wanderer", 
  "17. Sui :: Following", 
  "32. Heng :: Duration", // 37
  "31. Hsien :: Influence (Wooing)", 
  "47. K'un :: Oppression (Exhaustion)", 
  "48. Ching :: The Well", 
  "63. Chi Chi :: After Completion", // 41
  "64. Wei Chi :: Before Completion", 
  "20. Kuan :: Contemplation (View)", 
  "27. I :: The Corners of the Mouth (Providing Nourishment)", 
  "19. Lin :: Approach", // 45
  "4. Meng :: Youthful Folly", 
  "36. Ming I :: Darkening of the Light", 
  "52. Ken :: Keeping Still, Mountain", 
  "51. Chen :: The Arousing (Shock, Thunder)", // 49
  "35. Chin :: Progress", 
  "3. Chun :: Difficulty at the Beginning", 
  "46. Sheng :: Pushing Upward", 
  "62. Hsiao Kuo :: Preponderance of the Small", // 53
  "45. Ts'ui :: Gathering Together [Massing]", 
  "29. K'an :: The Abysmal (Water)", 
  "39. Chien :: Obstruction", 
  "40. Hsieh :: Deliverance", // 57 
  "24. Fu :: Return (The Turning Point)", 
  "7. Shih :: The Army", 
  "15. Ch'ien :: Modesty", 
  "16.Yu :: Enthusiasm", // 61
  "8. Pi :: Holding Together [Union]", 
  "23. Po :: Splitting Apart", 
  "2. K'un :: The Receptive"
}
);

