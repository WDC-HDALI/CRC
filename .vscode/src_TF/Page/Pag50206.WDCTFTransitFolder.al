page 50206 "WDC-TF Transit Folder"
{
    CaptionML = ENU = 'Transit Folder', FRA = 'Dossier importation';
    PageType = Document;
    SourceTable = "WDC-TF Transit Folder";
    SourceTableView = SORTING("No.");
    ApplicationArea = all;
    layout
    {
        area(content)
        {
            group(General)
            {
                CaptionML = ENU = 'General', FRA = 'Général';
                field("No."; Rec."No.")
                {
                    Editable = false;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = all;
                }
                field("Vendor Name"; Rec."Vendor Name")
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
                field("Freight Forwarder Code"; Rec."Freight Forwarder Code")
                {
                    ApplicationArea = all;
                }
                field("Freight Forwarder Name"; Rec."Freight Forwarder Name")
                {
                    ApplicationArea = all;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = all;
                }
                field("Opening Date"; Rec."Opening Date")
                {
                    Enabled = false;
                }
                field("Date de clôture"; Rec."Closing Date")
                {
                    Enabled = false;
                }
                field("Proforma No."; Rec."Proforma No.")
                {
                    ApplicationArea = all;
                }
                field("Letter of credit No."; Rec."Letter of credit No.")
                {
                    ApplicationArea = all;
                }
                field(Statut; Rec.Statut)
                {
                    Editable = false;
                }
            }
            group("Structure du coût")
            {
                field("Invoiced amount Vendor Dev"; Rec."Invoiced amount Vendor Dev")
                {
                    ApplicationArea = all;
                }
                field("Vendor Invoice Amount LCY"; Rec."Vendor Invoice Amount LCY")
                {
                    ApplicationArea = all;
                }
                field("Frei. Forw. Inv. Amount LCY"; Rec."Frei. Forw. Inv. Amount LCY")
                {
                    ApplicationArea = all;
                }
                field("Affected Charge Amount"; Rec."Affected Charge Amount")
                {
                    Editable = false;
                }
                field("% Frais"; Rec.CalcChargeRate)
                {
                    ApplicationArea = all;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = all;
                }
            }
            group("Livraison/Transport")
            {
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
                field("Doc. Trans. sednding Date"; Rec."Doc. Trans. sednding Date")
                {
                    ApplicationArea = all;
                }
                field("Place of loading"; Rec."Place of loading")
                {
                    ApplicationArea = all;
                }
                field("Number of packages"; Rec."Number of packages")
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
            }
            part(Frais; "WDC-TF Charge Folder")
            {
                CaptionML = ENU = 'Charges Folder', FRA = 'Frais dossier';
                Editable = true;
                SubPageLink = "Transit Folder No." = FIELD("No.");
            }
            part("Purchase Inv. Lines"; "WDC-TF Purchase Inv. Lines")
            {
                CaptionML = ENU = 'Purchase Inv. Lines', FRA = 'Lignes factures';
                Editable = false;
                SubPageLink = "Transit Folder No." = FIELD("No.");
                SubPageView = SORTING("Document No.", "Line No.")
                              WHERE(Type = CONST("Charge (Item)"));
                Visible = false;
            }
            part("Purchase Recep. Lines"; "WDC-TF Purchase Recept. Lines")
            {
                CaptionML = ENU = 'Purchase Recep. Lines', FRA = 'Marchandise réceptionnées';
                Editable = false;
                SubPageLink = "Transit Folder No." = FIELD("No."),
                              Quantity = FILTER(<> 0);
                SubPageView = SORTING("Document No.", "Line No.")
                              WHERE(Type = FILTER(Item | "Fixed Asset"));
                Visible = true;

            }
            part("Purchase CR. Lines"; "WDC-TF Purchase CR. Lines")
            {
                CaptionML = ENU = 'Purchase CR. Lines', FRA = 'Lignes Avoirs';
                Editable = false;
                SubPageLink = "Transit Folder No." = FIELD("No.");
                SubPageView = SORTING("Document No.", "Line No.");
                Visible = true;
            }
            part("Purchase Lines"; "WDC-TF Purchase line")
            {
                CaptionML = ENU = 'Purchase Lines', FRA = 'Frais en attente';
                Editable = false;
                SubPageLink = "Transit Folder No." = FIELD("No.");
                SubPageView = SORTING("Document Type", "Document No.", "Line No.")
                              WHERE(Type = CONST("Charge (Item)"));
                Visible = true;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Cloturer)
            {
                CaptionML = FRA = 'Clôturer';
                Image = Close;
                Promoted = true;

                trigger OnAction()
                begin
                    Rec.CloseFolder;
                end;
            }
            action(Reouvrir)
            {
                CaptionML = FRA = 'Réouvrir';
                Image = ReOpen;
                Promoted = false;
                trigger OnAction()
                begin
                    Rec.ReopenFolder;
                end;
            }
            action(RafraichirFrais)
            {
                CaptionML = FRA = 'Rafraîchir frais';
                Image = RefreshVoucher;
                Promoted = false;

                trigger OnAction()
                begin
                    Rec.RefreshDefaultCharges
                end;
            }
            group(Print)
            {
                CaptionML = ENU = 'Print', FRA = 'Impression';
                action("Folder contents")
                {
                    CaptionML = ENU = 'Folder contents', FRA = 'Contenu dossier';
                    Image = Receipt;
                    trigger OnAction()
                    var
                        NDossier: Record "WDC-TF Transit Folder";
                    begin
                        NDossier.RESET;
                        NDossier.SETFILTER("No.", Rec."No.");
                        IF NDossier.FINDFIRST THEN BEGIN
                            REPORT.RUNMODAL(50200, TRUE, FALSE, NDossier);

                        END
                    end;
                }
                action("Folder synthesis")
                {
                    CaptionML = ENU = 'Folder synthesis', FRA = 'Synthèse dossier';
                    Image = ReceivablesPayables;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    Visible = true;

                    trigger OnAction()
                    var
                        NDossier: Record "WDC-TF Transit Folder";
                    begin

                        NDossier.RESET;
                        NDossier.SETFILTER("No.", Rec."No.");
                        IF NDossier.FINDFIRST THEN
                            REPORT.RUNMODAL(50201, TRUE, FALSE, NDossier);
                    end;
                }
            }
            action("&Navigate")
            {
                CaptionML = ENU = '&Navigate', FRA = 'Naviguer';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    // Rec.Navigate;
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.Frais.PAGE.SetFolderNo(Rec."No.");
    end;

    var
        DescGTotFraisEnIns: Decimal;
        DescGTotFrais: Decimal;
        sms: Text[250];
}

