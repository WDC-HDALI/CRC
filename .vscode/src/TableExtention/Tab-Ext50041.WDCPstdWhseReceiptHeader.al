namespace CRC.CRC;
using Microsoft.Warehouse.Document;
using Microsoft.Warehouse.History;

tableextension 50041 "WDC Pstd Whse. Receipt Header" extends "Posted Whse. Receipt Header"
{
    fields
    {
        field(50000; Note; Text[250])
        {
            CaptionML = ENU = 'Note', FRA = 'Note';
            DataClassification = ToBeClassified;
        }
    }
}
