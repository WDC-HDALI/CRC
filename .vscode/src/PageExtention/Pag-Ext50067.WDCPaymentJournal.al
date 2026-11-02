namespace CRC.CRC;

using Microsoft.Finance.GeneralLedger.Journal;

pageextension 50067 "WDC Payment Journal " extends "Payment Journal"
{
    layout
    {
        modify(Amount)
        {
            trigger OnAfterValidate()
            begin
                TotalSheetAmount := GetTotalAmount(Rec."Journal Template Name", Rec."Journal Batch Name");
                CurrPage.Update(false);
            end;
        }
        addbefore("Number of Lines")
        {
            group("Total Amount_")
            {
                CaptionML = ENU = 'Total Amount', FRA = 'Montant total';
                field(TotalSheetAmount; TotalSheetAmount)
                {
                    CaptionML = ENU = 'Total Amount', FRA = 'Montant total';
                    ApplicationArea = All;
                    AutoFormatType = 1;
                    ShowCaption = false;
                    Style = Attention;
                    Editable = false;
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        TotalSheetAmount := GetTotalAmount(Rec."Journal Template Name", Rec."Journal Batch Name");
        CurrPage.Update(false);
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        TotalSheetAmount := GetTotalAmount(Rec."Journal Template Name", Rec."Journal Batch Name");
        CurrPage.Update(false);
    end;

    trigger OnAfterGetCurrRecord()
    begin
        TotalSheetAmount := GetTotalAmount(Rec."Journal Template Name", Rec."Journal Batch Name");
        CurrPage.Update(false);
    end;

    procedure GetTotalAmount(pTemplatename: Code[10]; pBatchName: Code[10]): Decimal
    var
        lGenJnlLine: Record "Gen. Journal Line";
        lTotalAmount: Decimal;
    begin
        TotalSheetAmount := 0;
        lGenJnlLine.Reset();
        lGenJnlLine.SetCurrentKey("Journal Batch Name", "Journal Template Name");
        lGenJnlLine.SetRange("Journal Template Name", pTemplatename);
        lGenJnlLine.SetRange("Journal Batch Name", pBatchName);
        if lGenJnlLine.FindFirst() then
            repeat
                lTotalAmount += lGenJnlLine."Amount (LCY)";
            until lGenJnlLine.Next() = 0;
        exit(lTotalAmount);
    end;

    var
        TotalSheetAmount: Decimal;

}
