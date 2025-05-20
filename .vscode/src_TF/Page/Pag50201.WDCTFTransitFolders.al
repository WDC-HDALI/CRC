page 50201 "WDC-TF Transit Folders"
{
    CardPageID = "WDC-TF Transit Folder";
    PageType = List;
    SourceTable = "WDC-TF Transit Folder";
    CaptionML = ENU = 'Transit Folders', FRA = 'Dossiers importations';
    Editable = false;
    UsageCategory = Lists;
    ApplicationArea = all;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                }
                field("Opening Date"; Rec."Opening Date")
                {
                    ApplicationArea = all;
                }
                field("Date de clôture"; Rec."Closing Date")
                {
                    ApplicationArea = all;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = all;
                }
                field(Souche; Rec.Souche)
                {
                    ApplicationArea = all;
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = all;
                }
                field(Statut; Rec.Statut)
                {
                    ApplicationArea = all;
                }
                field("Shipment Method Code"; Rec."Shipment Method Code")
                {
                    ApplicationArea = all;
                }
                field("Decalaration Date"; Rec."Decalaration Date")
                {
                    ApplicationArea = all;
                }
                field("Last Order No."; Rec."Last Order No.")
                {
                    ApplicationArea = all;
                }
                field("Freight Forwarder Code"; Rec."Freight Forwarder Code")
                {
                    ApplicationArea = all;
                }
                field("Freight Forwarder Name"; Rec."Freight Forwarder Name")
                {
                    ApplicationArea = all;
                }
                field("Freight Forwarder address"; Rec."Freight Forwarder address")
                {
                    ApplicationArea = all;
                }
                field("Freight Forwarder address 2"; Rec."Freight Forwarder address 2")
                {
                    ApplicationArea = all;
                }
                field("Freight Forwarder Post Code"; Rec."Freight Forwarder Post Code")
                {
                    ApplicationArea = all;
                }
                field("Freight Forwarder City"; Rec."Freight Forwarder City")
                {
                    ApplicationArea = all;
                }
                field("Vendor address"; Rec."Vendor address")
                {
                    ApplicationArea = all;
                }
                field("Vendor address 2"; Rec."Vendor address 2")
                {
                    ApplicationArea = all;
                }
                field("Vendor Post Code"; Rec."Vendor Post Code")
                {
                    ApplicationArea = all;
                }
                field("Vendor City"; Rec."Vendor City")
                {
                    ApplicationArea = all;
                }
                field("Vendor Country Code"; Rec."Vendor Country Code")
                {
                    ApplicationArea = all;
                }

                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = all;
                }
                field("Transporter code"; Rec."Transporter code")
                {
                    ApplicationArea = all;
                }
                field("Transporter Name"; Rec."Transporter Name")
                {
                    ApplicationArea = all;
                }
                field("Transporter address"; Rec."Transporter address")
                {
                    ApplicationArea = all;
                }
                field("Transporter address 2"; Rec."Transporter address 2")
                {
                    ApplicationArea = all;
                }
                field("Transporter City"; Rec."Transporter City")
                {
                    ApplicationArea = all;
                }
                field("Transporter Post code"; Rec."Transporter Post code")
                {
                    ApplicationArea = all;
                }
                field("Folder profile"; Rec."Folder profile")
                {
                    ApplicationArea = all;
                }
                field("Vessel Name / vol / Truck"; Rec."Vessel Name / vol / Truck")
                {
                    ApplicationArea = all;
                }
                field("Trip No."; Rec."Trip No.")
                {
                    ApplicationArea = all;
                }
                field("Transport Doc No."; Rec."Transport Doc No.")
                {
                    ApplicationArea = all;
                }
                field("Doc. Trans. sednding Date"; Rec."Doc. Trans. sednding Date")
                {
                    ApplicationArea = all;
                }
                field("Place of loading"; Rec."Place of loading")
                {
                    ApplicationArea = all;
                }
                field("gross weight"; Rec."gross weight")
                {
                    ApplicationArea = all;
                }
                field("Arrival Date at port Unloading"; Rec."Arrival Date at port Unloading")
                {
                    ApplicationArea = all;
                }
                field("Arrival Date at ending dest."; Rec."Arrival Date at ending dest.")
                {
                    ApplicationArea = all;
                }
                field("Confirmed Reception Date"; Rec."Confirmed Reception Date")
                {
                    ApplicationArea = all;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = all;
                }
                field("Proforma No."; Rec."Proforma No.")
                {
                    ApplicationArea = all;
                }
                field("Letter of credit No."; Rec."Letter of credit No.")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
    }
}

