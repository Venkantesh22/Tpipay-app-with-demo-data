class OdiaNumberLanguages {
  // --- Add this helper function above processPaymentVoice ---
  static String translateAmountToOdia(String amount) {
    // 1. Remove the .00 so it doesn't say "point zero zero"
    String cleanAmount = amount;
    if (amount.endsWith(".00")) {
      cleanAmount = amount.substring(0, amount.length - 3);
    }

    // Parse the string into an integer
    int? val = int.tryParse(cleanAmount);

    // If it's not a whole number (like "10.50"), just return the number to be read safely
    if (val == null) return cleanAmount;
    if (val == 0) return "ଶୂନ୍ୟ"; // Suna

    // The core 1-99 dictionary in Native Odia Script
    Map<int, String> odiaNumbers = {
      1: "ଏକ",
      2: "ଦୁଇ",
      3: "ତିନି",
      4: "ଚାରି",
      5: "ପାଞ୍ଚ",
      6: "ଛଅ",
      7: "ସାତ",
      8: "ଆଠ",
      9: "ନଅ",
      10: "ଦଶ",
      11: "ଏଗାର",
      12: "ବାର",
      13: "ତେର",
      14: "ଚଉଦ",
      15: "ପନ୍ଦର",
      16: "ଷୋହଳ",
      17: "ସତର",
      18: "ଅଠର",
      19: "ଉଣେଇଶ",
      20: "କୋଡିଏ",
      21: "ଏକୋଇଶ",
      22: "ବାଇଶ",
      23: "ତେଇଶ",
      24: "ଚବିଶ",
      25: "ପଚିଶ",
      26: "ଛବିଶ",
      27: "ସତେଇଶ",
      28: "ଅଠେଇଶ",
      29: "ଅଣତିରିଶ",
      30: "ତିରିଶ",
      31: "ଏକତିରିଶ",
      32: "ବତିଶ",
      33: "ତେତିଶ",
      34: "ଚଉତିରିଶ",
      35: "ପଞ୍ଚତିରିଶ",
      36: "ଛତିଶ",
      37: "ସତତିରିଶ",
      38: "ଅଠତିରିଶ",
      39: "ଅଣଚାଳିଶ",
      40: "ଚାଳିଶ",
      41: "ଏକଚାଳିଶ",
      42: "ବୟାଳିଶ",
      43: "ତେୟାଳିଶ",
      44: "ଚଉରାଳିଶ",
      45: "ପଞ୍ଚାଳିଶ",
      46: "ଛୟାଳିଶ",
      47: "ସତଚାଳିଶ",
      48: "ଅଠଚାଳିଶ",
      49: "ଅଣଚାଶ",
      50: "ପଚାଶ",
      51: "ଏକାବନ",
      52: "ବାବନ",
      53: "ତେପନ",
      54: "ଚଉବନ",
      55: "ପଞ୍ଚାବନ",
      56: "ଛପନ",
      57: "ସତାବନ",
      58: "ଅଠାବନ",
      59: "ଅଣଷଠି",
      60: "ଷାଠିଏ",
      61: "ଏକଷଠି",
      62: "ବାଷଠି",
      63: "ତେଷଠି",
      64: "ଚଉଷଠି",
      65: "ପଞ୍ଚଷଠି",
      66: "ଛଷଠି",
      67: "ସତଷଠି",
      68: "ଅଠଷଠି",
      69: "ଅଣସ୍ତରୀ",
      70: "ସତୁରୀ",
      71: "ଏକସ୍ତରୀ",
      72: "ବାସ୍ତରୀ",
      73: "ତେସ୍ତରୀ",
      74: "ଚଉସ୍ତରୀ",
      75: "ପଞ୍ଚସ୍ତରୀ",
      76: "ଛସ୍ତରୀ",
      77: "ସତସ୍ତରୀ",
      78: "ଅଠସ୍ତରୀ",
      79: "ଅଣାଶୀ",
      80: "ଅଶୀ",
      81: "ଏକାଶୀ",
      82: "ବୟାଶୀ",
      83: "ତେୟାଶୀ",
      84: "ଚଉରାଶୀ",
      85: "ପଞ୍ଚାଶୀ",
      86: "ଛୟାଶୀ",
      87: "ସତାଶୀ",
      88: "ଅଠାଶୀ",
      89: "ଅଣାନବେ",
      90: "ନବେ",
      91: "ଏକାନବେ",
      92: "ବୟାନବେ",
      93: "ତେୟାନବେ",
      94: "ଚଉରାନବେ",
      95: "ପଞ୍ଚାନବେ",
      96: "ଛୟାନବେ",
      97: "ସତାନବେ",
      98: "ଅଠାନବେ",
      99: "ଅନେଶ୍ୱତ",
    };

    // 2. Dynamic Calculation Builder
    String words = "";

    // Crores (Koti) - Handles up to 99,00,00,000
    if (val >= 10000000) {
      int crores = val ~/ 10000000;
      words += "${odiaNumbers[crores]} କୋଟି "; // koti
      val %= 10000000;
    }

    // Lakhs (Lakha) - Handles up to 99,00,000
    if (val >= 100000) {
      int lakhs = val ~/ 100000;
      words += "${odiaNumbers[lakhs]} ଲକ୍ଷ "; // lakha
      val %= 100000;
    }

    // Thousands
    if (val >= 1000) {
      int thousands = val ~/ 1000;
      words += "${odiaNumbers[thousands]} ହଜାର "; // hajara
      val %= 1000;
    }

    // Hundreds
    if (val >= 100) {
      int hundreds = val ~/ 100;
      if (hundreds == 1) {
        words += "ଶହେ "; // Sahe
      } else {
        words += "${odiaNumbers[hundreds]} ଶହ "; // Saha
      }
      val %= 100;
    }

    // Remaining 1-99
    if (val > 0) {
      words += odiaNumbers[val]!;
    }

    return words.trim();
  }
}
