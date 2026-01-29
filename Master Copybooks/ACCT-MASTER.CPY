01  ACC-MASTER-REC.
    05  ACC-NUM         PIC 9(6).         *> stored as 6 numeric digits (XXXXXX)
    05  ACC-NAME        PIC X(50).
    05  ACC-TYPE        PIC X(1).         *> A/L/E/R/X etc.
    05  ACC-NORM-BAL    PIC X(1).         *> 'D' or 'C'
    05  ACC-STATUS      PIC X(1).         *> 'A' or 'I'
    05  ACC-OPEN-BAL    PIC S9(11)V99 COMP-3. *> signed, 2 implied decimals
    05  ACC-CURRENCY    PIC X(3).         *> ISO code
    05  FILLER          PIC X(17).