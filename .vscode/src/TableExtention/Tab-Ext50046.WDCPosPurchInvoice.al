tableextension 50046 "WDC Purch. Inv. Header" extends "Purch. Inv. Header"
{
    fields
    {
        field(54005; "Replacment Invoice No."; Code[20])
        {
            CaptionML = ENU = 'Replacment Invoice No.', FRA = 'N° facture remplaçante';
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

}