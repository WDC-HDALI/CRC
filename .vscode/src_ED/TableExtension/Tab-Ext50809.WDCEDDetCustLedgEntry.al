tableextension 50809 "WDC-ED Det. Cust. Ledg. Entry" extends "Detailed Cust. Ledg. Entry"
{
    fields
    {
        field(50801; "Curr. Adjmt. G/L Account No."; Code[20])
        {
            captionML = ENU = 'Curr. Adjmt. G/L Account No.', FRA = 'N° compte général ajustement courant';
            TableRelation = "G/L Account";
        }
    }

}