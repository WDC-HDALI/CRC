page 50041 "WDC Customer Balance Status"
{
    ApplicationArea = All;
    CaptionML = ENU = 'Customer Balance Status', FRA = 'Solde client';
    PageType = List;
    SourceTable = Customer;
    UsageCategory = Lists;
    CardPageId = "Customer Card";
    layout
    {

        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }

                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }

                field(TotalCustomerAmount; TotalCustomerAmount)
                {
                    CaptionML = ENU = 'Total Customer Amount', FRA = 'Solde client';
                    ApplicationArea = all;
                    Style = Strong;
                    StyleExpr = StyleTxt;
                    Editable = false;
                }
                field(BalanceNotEncashed; BalanceNotEncashed)
                {
                    CaptionML = ENU = 'Balance Not Encased', FRA = 'Solde non encaissé';
                    ApplicationArea = All;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = StyleTxtBalanceNotEncashed;

                }
                field("Last Payment Date"; Rec."Last Payment Date")
                {
                    ApplicationArea = All;
                }
                field("Last Payment Amount"; Rec."Last Payment Amount")
                {
                    ApplicationArea = All;
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ApplicationArea = All;
                }
            }
        }



    }
    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
        GLSetup: record "General Ledger Setup";
    begin
        GLSetup.get;
        UserSetup.Get(UserId);

        Rec.SetFilter("Start Year Filter", '..%1', GLSetup."Go Live Date");
        rec.SetFilter("Due Date Filter", '%1..', WorkDate);
        //rec.SetFilter("Due Date Filter for balance", '..%1', WorkDate);
    end;

    trigger OnAfterGetRecord()
    var
        UserSetup: Record "User Setup";
    begin

        rec.CalcFields("Balance (LCY)", "Total Shipment");
        TotalCustomerAmount := Rec."Balance (LCY)" + (Rec."Total Shipment");
        Rec.CalcFields("Draft Not Due");
        BalanceNotEncashed := TotalCustomerAmount + Rec."Draft Not Due";
        StyleTxt := Color(); //WDC01
        //StyleTxtBalanceNotEncashed := ColorBalanceNotEncashed();
    end;

    procedure Color(): text[50]
    begin
        if TotalCustomerAmount > 0 then
            exit('unfavorable')
        else
            exit('favorable');
    end;

    procedure ColorBalanceNotEncashed(): text[50]
    begin
        if BalanceNotEncashed > 0 then
            exit('unfavorable')
        else
            exit('favorable');

    end;

    var
        TotalCustomerAmount: Decimal;
        StyleTxt: Text[50];
        StyleTxtBalanceNotEncashed: Text[50];
        BalanceNotEncashed: Decimal;
}