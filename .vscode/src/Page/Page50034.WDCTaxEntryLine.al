//**************Documentation****************
//WDC01  WDC.HG 25/09/2025 Add Fields "Customer No." and "Customer Name"
page 50034 "WDC Details Tax Ledger Entry"
{
    PageType = ListPart;
    SourceTable = "WDC Tax Ledger Entry";
    CaptionML = ENU = 'Tax Ledger Entry', FRA = 'Ecritures TVA';
    ApplicationArea = All;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }

                field("Type Document"; Rec."Type Document")
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("orderer No."; rec."orderer No.")
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Orderer No.', FRA = 'N° donneur d''ordre';
                }
                field("Orderer Name"; Rec."Orderer Name")
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Orderer Name', FRA = 'Nom donneur d''ordre';
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Type Mouvement"; Rec."Type Mouvement")
                {
                    ApplicationArea = All;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Catégorie Article"; Rec."Catégorie Article")
                {
                    ApplicationArea = All;
                }
                field("Quantité"; Rec."Quantité")
                {
                    ApplicationArea = All;
                }
                field("Prix unitaire"; Rec."Prix unitaire")
                {
                    ApplicationArea = All;
                }
                field("Montant HT"; Rec."Montant HT")
                {
                    ApplicationArea = All;
                }
                field("TVA %"; Rec."TVA %")
                {
                    ApplicationArea = All;
                }
                field("Montant TVA"; Rec."Montant TVA")
                {
                    ApplicationArea = All;
                }
                field("Montant TTC"; Rec."Montant TTC")
                {
                    ApplicationArea = All;
                }
                field("Posting Group"; Rec."Posting Group")
                {
                    ApplicationArea = All;
                }
                field("TVA Group"; Rec."TVA Group")
                {
                    ApplicationArea = All;
                }
            }

        }
    }
}