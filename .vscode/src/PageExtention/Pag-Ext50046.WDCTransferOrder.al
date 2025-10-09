//****************Documentation**********************

pageextension 50046 "WDC Transfer Order" extends "Transfer Order"
{
    layout
    {
        addafter("Status")
        {
            field("Customer No."; Rec."Customer No.")
            {
                ApplicationArea = all;
                trigger OnValidate()
                var
                    Customer: Record Customer;
                begin
                    if Customer.Get(Rec."Customer No.") then
                        Rec."Customer Name" := Customer.Name;
                end;
            }
            field("Customer Name"; Rec."Customer Name")
            {
                ApplicationArea = all;
            }

        }
    }

}
