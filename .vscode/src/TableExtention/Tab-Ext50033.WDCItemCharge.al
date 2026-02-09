//****************Documentation**********************


tableextension 50033 "WDC Item Charge" extends "Item Charge"
{
    fields
    {
        field(50000; "Not Editable in Sales Line"; Boolean)
        {
            CaptionML = ENU = 'Not Editable in Sales Line', FRA = 'Non modifiable dans la ligne de vente';
            DataClassification = ToBeClassified;
        }
    }
}