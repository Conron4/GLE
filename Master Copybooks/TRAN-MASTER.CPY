01  GL-TRAN-REC.
    05  TRAN-ID            PIC X(20).
    05  TRAN-DATE          PIC 9(8).            *> YYYYMMDD
    05  TRAN-PERIOD        PIC 9(6).            *> YYYYMM
    05  ACC-NUM            PIC 9(6).
    05  LINE-AMOUNT        PIC S9(11)V99 COMP-3. *> signed, 2 implied decimals
    05  DRCR-IND           PIC X(1).            *> 'D'/'C' optional
    05  CURR-CODE          PIC X(3).
    05  EXCH-RATE          PIC 9(9)V9 COMP-3.  *> optional, implied 1 decimal
    05  SRC-DOC-TYPE       PIC X(4).
    05  SRC-DOC-ID         PIC X(20).
    05  DESCRIPTION        PIC X(80).
    05  FILLER             PIC X(18).