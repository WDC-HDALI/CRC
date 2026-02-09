namespace CRC.CRC;

using Microsoft.Finance.GeneralLedger.Journal;

pageextension 50066 "WDC General Journal" extends "General Journal"
{
    layout
    {
        addafter("Amount (LCY)")
        {
            field("Gen. Bus. Posting Group_"; Rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = All;
                Caption = 'Gen. Bus. Posting Group';
            }
        }


    }
}
