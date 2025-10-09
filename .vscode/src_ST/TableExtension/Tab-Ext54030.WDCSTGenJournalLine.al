tableextension 54030 "WDC-ST GenJournalLine" extends "Gen. Journal Line"
{
    fields
    {
        field(54075; "Payment Slip Type"; Enum "WDC-ST Payment Slip Type")
        {
            CaptionML = ENU = 'Payment Slip Type', FRA = 'Type bordoreau';
            Editable = false;
        }
    }
}