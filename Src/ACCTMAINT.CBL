       IDENTIFICATION DIVISION.
       PROGRAM-ID. ACCTMAINT.

      *> ------------------------------------------------------------
      *> Account Master Maintenance
      *> Checkpoint 1 program
      *> ------------------------------------------------------------

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.

       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT ACC-MASTER
               ASSIGN TO "accmaster.dat"
               ORGANIZATION IS INDEXED
               ACCESS MODE IS DYNAMIC
               RECORD KEY IS ACC-NUM
               FILE STATUS IS WS-ACC-STATUS.

       DATA DIVISION.
       FILE SECTION.

       FD  ACC-MASTER.
       COPY "../Master Copybooks/ACCT-MASTER.CPY".
       

       WORKING-STORAGE SECTION.

      *> ---------- File status ----------
       01  WS-ACC-STATUS        PIC XX.

           88  FS-OK            VALUE "00".
           88  FS-NOT-FOUND     VALUE "23".
           88  FS-DUPLICATE     VALUE "22".
           88  FS-EOF           VALUE "10".

      *> ---------- Menu ----------
       01  WS-MENU-OPTION       PIC 9.
           88  OPT-ADD           VALUE 1.
           88  OPT-UPDATE        VALUE 2.
           88  OPT-CLOSE         VALUE 3.
           88  OPT-EXIT          VALUE 9.

      *> ---------- Input fields ----------
       01  WS-IN-ACC-NUM        PIC 9(6).
       01  WS-IN-ACC-NAME       PIC X(50).
       01  WS-IN-ACC-TYPE       PIC X.
       01  WS-IN-OPEN-BAL       PIC S9(11)V99.
       01  WS-IN-CURRENCY       PIC X(3).

      *> ---------- Control ----------
       01  WS-EOF-FLAG          PIC X VALUE 'N'.
           88  EOF               VALUE 'Y'.

       PROCEDURE DIVISION.
       MAIN.
           PERFORM INIT
           PERFORM UNTIL OPT-EXIT
              PERFORM DISPLAY-MENU
              PERFORM PROCESS-OPTION
           END-PERFORM
           PERFORM CLEANUP
           STOP RUN.

      *> ============================================================
       INIT.
           OPEN I-O ACC-MASTER
           IF WS-ACC-STATUS = "35"
              OPEN OUTPUT ACC-MASTER
              CLOSE ACC-MASTER
              OPEN I-O ACC-MASTER
           END-IF
           IF NOT FS-OK
              DISPLAY "ERROR OPENING ACC-MASTER: " WS-ACC-STATUS
              STOP RUN
           END-IF
           .

      *> ============================================================
       DISPLAY-MENU.
           DISPLAY SPACE
           DISPLAY "ACCOUNT MASTER MAINTENANCE"
           DISPLAY "1. ADD ACCOUNT"
           DISPLAY "2. UPDATE ACCOUNT NAME"
           DISPLAY "3. CLOSE ACCOUNT"
           DISPLAY "9. EXIT"
           ACCEPT WS-MENU-OPTION
           .

      *> ============================================================
       PROCESS-OPTION.
           EVALUATE TRUE
               WHEN OPT-ADD
                   PERFORM ADD-ACCOUNT
               WHEN OPT-UPDATE
                   PERFORM UPDATE-ACCOUNT
               WHEN OPT-CLOSE
                   PERFORM CLOSE-ACCOUNT
               WHEN OPT-EXIT
                   CONTINUE
               WHEN OTHER
                   DISPLAY "INVALID OPTION"
           END-EVALUATE
           .

      *> ============================================================
       ADD-ACCOUNT.
           PERFORM PROMPT-ADD-FIELDS

           MOVE WS-IN-ACC-NUM TO ACC-NUM
           READ ACC-MASTER
               INVALID KEY
                   PERFORM BUILD-NEW-ACCOUNT
                   WRITE ACC-MASTER-REC
                   IF NOT FS-OK
                       DISPLAY "WRITE FAILED: " WS-ACC-STATUS
                   END-IF
               NOT INVALID KEY
                   DISPLAY "ACCOUNT ALREADY EXISTS"
           END-READ
           .

      *> ============================================================
       UPDATE-ACCOUNT.
           PERFORM PROMPT-ACC-NUM
           MOVE WS-IN-ACC-NUM TO ACC-NUM

           READ ACC-MASTER
               INVALID KEY
                   DISPLAY "ACCOUNT NOT FOUND"
               NOT INVALID KEY
                   IF ACC-CLOSED
                       DISPLAY "ACCOUNT IS CLOSED"
                   ELSE
                       PERFORM PROMPT-NEW-NAME
                       MOVE WS-IN-ACC-NAME TO ACC-NAME
                       REWRITE ACC-MASTER-REC
                       IF NOT FS-OK
                           DISPLAY "REWRITE FAILED: " WS-ACC-STATUS
                       END-IF
                   END-IF
           END-READ
           .

      *> ============================================================
       CLOSE-ACCOUNT.
           PERFORM PROMPT-ACC-NUM
           MOVE WS-IN-ACC-NUM TO ACC-NUM

           READ ACC-MASTER
               INVALID KEY
                   DISPLAY "ACCOUNT NOT FOUND"
               NOT INVALID KEY
                   IF ACC-CLOSED
                       DISPLAY "ACCOUNT ALREADY CLOSED"
                   ELSE
                       SET ACC-CLOSED TO TRUE
                       REWRITE ACC-MASTER-REC
                       IF NOT FS-OK
                           DISPLAY "REWRITE FAILED: " WS-ACC-STATUS
                       END-IF
                   END-IF
           END-READ
           .

      *> ============================================================
       PROMPT-ADD-FIELDS.
           DISPLAY "ACCOUNT NUMBER (6 DIGITS): "
           ACCEPT WS-IN-ACC-NUM
           DISPLAY "ACCOUNT NAME: "
           ACCEPT WS-IN-ACC-NAME
           DISPLAY "ACCOUNT TYPE (A/L/E/R/X): "
           ACCEPT WS-IN-ACC-TYPE
           DISPLAY "OPENING BALANCE: "
           ACCEPT WS-IN-OPEN-BAL
           DISPLAY "CURRENCY (ISO): "
           ACCEPT WS-IN-CURRENCY
           .

       PROMPT-ACC-NUM.
           DISPLAY "ACCOUNT NUMBER: "
           ACCEPT WS-IN-ACC-NUM
           .

       PROMPT-NEW-NAME.
           DISPLAY "NEW ACCOUNT NAME: "
           ACCEPT WS-IN-ACC-NAME
           .

      *> ============================================================
       BUILD-NEW-ACCOUNT.
           MOVE WS-IN-ACC-NUM     TO ACC-NUM
           MOVE WS-IN-ACC-NAME    TO ACC-NAME
           MOVE WS-IN-ACC-TYPE    TO ACC-TYPE
           SET  ACC-ACTIVE        TO TRUE
           MOVE WS-IN-OPEN-BAL    TO ACC-OPEN-BAL
           MOVE WS-IN-CURRENCY    TO ACC-CURRENCY
           .

      *> ============================================================
       CLEANUP.
           CLOSE ACC-MASTER
           .
