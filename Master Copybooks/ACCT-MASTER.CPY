       01  ACC-MASTER-REC.
       05  ACC-NUM         PIC 9(6).         *> stored as 6 numeric digits (XXXXXX)
       05  ACC-NAME        PIC X(50).
       05 ACC-TYPE PIC X.
           88 ACC-ASSET     VALUE 'A'.
           88 ACC-LIABILITY VALUE 'L'.
           88 ACC-EQUITY    VALUE 'E'.
           88 ACC-REVENUE   VALUE 'R'.
           88 ACC-EXPENSE   VALUE 'X'.
       05 ACC-STATUS PIC X.
           88 ACC-ACTIVE VALUE 'A'.
           88 ACC-CLOSED VALUE 'C'.
       05  ACC-OPEN-BAL    PIC S9(11)V99 COMP-3. *> signed, 2 implied decimals, Init only
       05  ACC-CURRENCY    PIC X(3).         *> ISO code
       05  FILLER          PIC X(17).
