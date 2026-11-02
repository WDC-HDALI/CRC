namespace CRC.CRC;

using Microsoft.Inventory.Item;
using Microsoft.Finance.VAT.Setup;

report 50913 "WDC Item Ticket"
{
    ApplicationArea = All;
    CaptionML = ENU = 'Item Ticket', FRA = 'Ticket article';
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/src/Report/RDLC/ItemTicket.rdlc';
    dataset
    {
        dataitem(Item; Item)
        {
            RequestFilterFields = "No.", "Item Category Code", SubCategorie;
            column(No; "No.")
            {
            }
            column(Description; Description)
            {
            }
            column(UnitPriceTTC; PrixTTC)
            {
            }
            trigger OnAfterGetRecord()

            var
                VATPostingSetup: Record "VAT Posting Setup";
            begin
                PrixTTC := 0;
                if Item."Unit Price" <> 0 then begin
                    if VATPostingSetup.Get('ASSUJETTI', Item."VAT Prod. Posting Group") then
                        PrixTTC := Item."Unit Price" * (1 + (VATPostingSetup."VAT %" / 100));
                end;
            end;

        }



    }
    var
        PrixTTC: Decimal;
}
