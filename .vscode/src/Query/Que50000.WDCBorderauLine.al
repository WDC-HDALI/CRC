namespace CRC.CRC;

using Microsoft.Finance.GeneralLedger.Ledger;
//****************Documentation**************************
//WDC01  WDC.HG  10/06/2025  create the current object 
query 50000 "WDC Borderau Line"
{
    CaptionML = ENU = 'Borderau Line', FRA = 'Ligne Bordereau';
    QueryType = Normal;
    OrderBy = descending(Posting_Date);

    elements
    {
        dataitem(GLEntry; "G/L Entry")
        {
            column(Document_Type; "Document Type")
            {
                ColumnFilter = Document_Type = filter(" ");

            }
            column(Document_No_; "Document No.")
            {

            }
            column(Count_)
            {
                Method = Count;
            }
            column(Posting_Date; "Posting Date")
            {

            }

        }
    }

    trigger OnBeforeOpen()
    begin
    end;
}
