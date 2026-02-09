tableextension 54032 "WDC-ST G/L Entry" extends "G/L Entry"
{
    fields
    {
        field(54075; "Payment Slip Type"; Enum "WDC-ST Payment Slip Type")
        {
            CaptionML = ENU = 'Payment Slip Type', FRA = 'Type bordoreau';
            Editable = false;
        }
        field(54076; "Payment Slip Type Filter"; Enum "WDC-ST Payment Slip Type")
        {
            CaptionML = ENU = 'Payment Slip Type', FRA = 'Type bordoreau';
            FieldClass = FlowFilter;
            Editable = false;
        }
    }
}