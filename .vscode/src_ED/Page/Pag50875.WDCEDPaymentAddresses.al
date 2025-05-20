page 50875 "WDC-ED Payment Addresses"
{
    CaptionML = ENU = 'Payment Address', FRA = 'Adresse de règlement';
    DataCaptionExpression = Legend;
    PageType = List;
    SourceTable = "WDC-ED Payment Address";

    layout
    {
        area(content)
        {
            repeater(Control1120000)
            {
                ShowCaption = false;
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field("Default Value"; Rec."Default Value")
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field("Search Name"; Rec."Search Name")
                {
                    ApplicationArea = All;
                }
                field("Name 2"; Rec."Name 2")
                {
                    ApplicationArea = All;
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = All;
                }
                field("Address 2"; Rec."Address 2")
                {
                    ApplicationArea = All;
                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = All;
                }
                field(City; Rec.City)
                {
                    ApplicationArea = All;
                }
                field(Contact; Rec.Contact)
                {
                    ApplicationArea = All;
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ApplicationArea = All;
                }
                field(County; Rec.County)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        AfterGetCurrentRecord;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        AfterGetCurrentRecord;
    end;

    local procedure AfterGetCurrentRecord()
    begin
        xRec := Rec;
        if Rec."Account Type" = Rec."Account Type"::Customer then begin
            Cust.Get(Rec."Account No.");
            Legend := Text001 + ' ' + Format(Rec."Account No.") + ' ' + Cust.Name;
        end else begin
            Vend.Get(Rec."Account No.");
            Legend := Text002 + ' ' + Format(Rec."Account No.") + ' ' + Vend.Name;
        end;
    end;

    var
        Text001: TextConst ENU = 'Customer',
                           FRA = 'Client';
        Text002: TextConst ENU = 'Vendor',
                           FRA = 'Fournisseur';
        Cust: Record Customer;
        Vend: Record Vendor;
        Legend: Text[250];
}

