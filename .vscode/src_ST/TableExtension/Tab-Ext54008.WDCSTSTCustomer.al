tableextension 54008 "WDC-ST-ST Customer" extends "Customer"
//*************Documentation***************************
//wdc01  WDC.FS  26/12/2025 : Existant CIN Couldn't be added
{
    fields
    {
        field(54000; "CIN"; Code[8])
        {
            CaptionML = ENU = 'CIN', FRA = 'CIN';
            DataClassification = CustomerContent;

            //<<wdc01
            trigger OnValidate()
            var
                Customer: Record Customer;
                Text001: Label 'Un client avec le CIN "%1" existe déjà (Client N° %2).';
            begin
                Customer.Reset();
                Customer.SetFilter("No.", '<>%1', Rec."No.");
                if Customer.FindFirst() then begin
                    repeat
                        IF UpperCase(Customer."CIN") = UpperCase(Rec."CIN") THEN
                            Error(Text001, Rec."CIN", Customer."No.");
                    until Customer.next() = 0;
                end;
            end;
            //>>wdc01

        }


    }


}