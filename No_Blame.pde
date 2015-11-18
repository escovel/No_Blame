// No Blame
// A specialized poetry line sorting and hexagram generating program
// Text by Tyler Carter, code by Eric Goddard-Scovel
// Begun in July of 2015, version 1 completed September 18, 2015

/* This program can be used to create a 64-poem series consisting of 4 sets of 16 poems.
 All sets are composed from the same set of 256 lines written by Tyler Carter. Two of
 the sets were assembled before this program was written, and the others are generated
 by the program from the first two sets.
 
 The four sets will be placed in this order, and the hexagrams will be cast according
 to this order as well: (1) the original set of poems, (2) the linguistic lists, which
 are a reordering of the original poem's 256 into 16 sets of 16 lines according to
 grammatical or syntactical features of the lines, (3) the linguistic lists shuffled, and
 (4) the original poems shuffled.
 
 The shuffled poems are not simply a random reordering or shuffling of the original poems,
 nor do the just grab lines randomly from the list of 256 available lines until there are
 none left. The poems implement stanza patterns of 4 unique (non-repeating) number between
 1 and 16; this pattern determines which original poem or linguistic list the new poem's
 lines will come from. Each poem is 4 stanzas of four lines, so the pattern is applied 4
 times to each poem during generation. As each poem is created, the subsequent poems have
 fewer and fewer lines to choose from, leading in the end to a final poem (in each set of
 16 poems) which has been fully determined by generation of the previous poems in the set.
 
 Based upon line number values (ordered in the first two sets, shuffled in the second two),
 an I Ching hexagram is cast for each poem by a modified "coin toss" method, building the
 hexagrams one line at a time. The hexagrams are exported as PNG files, and the corresponding
 titles of each hexagram are used as titles for the poems.
 
 All 64 hexagrams, one assigned to each poem, are present in the set after generation,
 contributing a completeness to the book through its connection to the ancient system
 of the I Ching. The poems were cast in a similar fashion to the I Ching Hexagrams, and
 values from the casting of the poems are used to in part determine the generation of
 the hexagrams.
*/

// Initialize variables for stanza pattern and poem generation.
final int patternSlots = 4, patternRange = 16, numberOfPoems = 16;
final int LinesPerStanza = 4, numberOfStanzas = 4, numberOfLines = 16;
final int poemNum = 0;

// IntList for initial generation of shuffled 1-16 integers (for stanza pattern generation).
IntList randomizedPatternSlotsIntList;

// ArrayList to hold all generated stanza patterns.
ArrayList stanzaPatternsArrayList = new ArrayList();

// Initialize intlists for pattern slots arrays.
int [] randomizedPatternSlotsArray1 = new int[numberOfPoems];
int [] randomizedPatternSlotsArray2 = new int[numberOfPoems];
int [] randomizedPatternSlotsArray3 = new int[numberOfPoems];
int [] randomizedPatternSlotsArray4 = new int[numberOfPoems];

// Initiate the duplicate array indices counter with a non-zero value (any old non-zero value will do).
// This is used by checkForDuplicateArrayIndices() in the stanza_patterns tab.
int DuplicateIndices = 3;

// ArrayLists for stanza patterns, poem source lists, and patterned poems (final output).
ArrayList stanzaPatterns;
ArrayList<String[]> poemSourceListsOriginal;
ArrayList<String[]> poemSourceListsLinguistic;

// Initialize IntLists to hold all used line values in a signle 256 item list.
// I will cast the hexagrams later using the values in this list.
IntList lineValuesForHexGenOriginal = new IntList();
IntList lineValuesForHexGenLinguistic = new IntList();
IntList lineValuesForHexGenUnshuffledSets = new IntList();

// Initialize StringList for all 256 lines of the final poem sets ( 2 set of 16 16-line poems).
StringList allPatternedPoemLinesOriginal = new StringList();
StringList allPatternedPoemLinesLinguistic = new StringList();

// Boolean to avoid duplicate lines being drawn
boolean lineHasBeenUsed;
String aLine;

// Main program loop.
void setup() {
  // Set display frame size and font for drawing of hexagrams.
  size(220, 220);
  font = createFont("Arial", 32, true); 

  // Make the stanza patterns then make the shuffled poems set from the original poems.
  makeStanzaPatternSlotArrays(); // Create the four shuffled arrays of 1-16.
  checkForDuplicateArrayIndices(); // Initial check for duplicates, extremely likely to have duplicates.
  // This loop will continue creating new stanza pattern slot arrays until there are no duplicate indices.
  while (DuplicateIndices > 0) {
    DuplicateIndices = 0;
    makeStanzaPatternSlotArrays();
    checkForDuplicateArrayIndices();
  }
  // Translate the 4 pattern slots arrays into the 16 patterns for the third set of poems (the first shuffled set).
  makeStanzaPatterns(); 
  makePoemSet(3); // Generate the 16 poem sets from the linguistic poem set.
  exportStanzaPatternsArray(3); // Export the stanza patterns for the shuffled linguistic poem set.

  // Make the stanza patterns then make the shuffled poems set from the linguistic poems.
  makeStanzaPatternSlotArrays(); // Create the four shuffled arrays of 1-16.
  checkForDuplicateArrayIndices(); // Initial check for duplicates, extremely likely to have duplicates.
  // This loop will continue creating new stanza pattern slot arrays until there are no duplicate indices.
  while (DuplicateIndices > 0) {
    DuplicateIndices = 0;
    makeStanzaPatternSlotArrays();
    checkForDuplicateArrayIndices();
  }
  // Translate the 4 pattern slots arrays into the 16 patterns for the fourth set of poems (the second shuffled set).
  makeStanzaPatterns();
  makePoemSet(4); // Generate the 16 poem sets from the original poem set.
  exportStanzaPatternsArray(4); // Export the stanza patterns for the shuffled original poem set.

  // Cast and draw hexagrams from all 64 poems across the 4 sets.
  castHexagrams();
  isSetComplete64Hexagrams();

  // Export all of the other files.
  exportFinalPoemSets(3);
  exportFinalPoemSets(4);
  exportHexagramTags();
  exportPoemTitlesFromHexagrams();
}