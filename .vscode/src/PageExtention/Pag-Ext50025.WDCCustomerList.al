pageextension 50025 "WDC Customer List" extends "Customer List"
{
    layout
    {

        modify("Balance Due (LCY)")
        {
            Visible = false;
        }
        modify("Balance (LCY)")
        {
            Visible = false;
        }
        modify("Responsibility Center")
        {
            Visible = false;
        }
        modify("Location Code")
        {
            Visible = false;
        }
        modify(Blocked)
        {
            Visible = true;
        }
        modify("Sales (LCY)")
        {
            Visible = true;
        }
        modify(Contact)
        {
            Visible = false;
        }
        addafter(Name)
        {
            field(Address; Rec.Address)
            {
                ApplicationArea = All;
            }
            field(City; Rec.City)
            {
                ApplicationArea = All;
            }

        }
        addafter("Phone No.")
        {

            field(Report; Rec.Report)
            {
                ApplicationArea = all;
                Style = Strong;
            }
            field(Debit; Rec.Debit)
            {
                CaptionML = ENU = 'Invoiced Shipments', FRA = 'BL Facturés';
                ApplicationArea = all;
                Style = Strong;
            }
            field("Total Shipment"; Rec."Total Shipment")
            {
                CaptionML = ENU = 'Shipments not invoiced', FRA = 'BL Non facturés';
                ApplicationArea = all;
                Style = Strong;
            }
            field(Credit; Rec.Credit)
            {
                CaptionML = ENU = 'Payments', FRA = 'Paiements';
                ApplicationArea = all;
                Style = StrongAccent;
            }

            field(TotalCustomerAmount; TotalCustomerAmount)
            {
                CaptionML = ENU = 'Total Customer Amount', FRA = 'Solde client';
                ApplicationArea = all;
                Style = Strong;
                StyleExpr = StyleTxt;
                Editable = false;
            }

        }
        MoveAfter(Name; "Credit Limit (LCY)")
        moveafter("Payments (LCY)"; Blocked)
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

        StyleTxt := Color(); //WDC01
    end;

    procedure Color(): text[50]
    begin
        if TotalCustomerAmount > 0 then
            exit('unfavorable')
        else
            exit('favorable');
    end;

    var
        TotalCustomerAmount: Decimal;
        StyleTxt: Text[50];
}