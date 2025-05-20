page 50868 "WDC-ED Payment Slip"
{
    CaptionML = ENU = 'Payment Slip', FRA = 'Bordereau paiement';
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = "WDC-ED Payment Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                CaptionML = ENU = 'General', FRA = 'Général';
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    AssistEdit = false;

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
                }
                field("Payment Class"; Rec."Payment Class")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Lookup = false;
                }
                field("Payment Class Name"; Rec."Payment Class Name")
                {
                    ApplicationArea = All;
                    DrillDown = false;
                    Editable = false;
                    Importance = Promoted;
                }
                field("Status Name"; Rec."Status Name")
                {
                    ApplicationArea = All;
                    DrillDown = false;
                    Editable = false;
                    Importance = Promoted;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;

                    trigger OnAssistEdit()
                    begin
                        ChangeExchangeRate.SetParameter(Rec."Currency Code", Rec."Currency Factor", Rec."Posting Date");
                        if ChangeExchangeRate.RunModal = ACTION::OK then begin
                            Rec.Validate("Currency Factor", ChangeExchangeRate.GetParameter);
                            CurrPage.Update;
                        end;
                        Clear(ChangeExchangeRate);
                    end;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        DocumentDateOnAfterValidate;
                    end;
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field(Suggestions; Rec.Suggestions)
                {
                    ApplicationArea = all;
                }

            }
            part(Lines; "WDC-ED Payment Slip Subform")
            {
                ApplicationArea = All;
                SubPageLink = "No." = FIELD("No.");
            }
            group(Posting)
            {
                CaptionML = ENU = 'Posting', FRA = 'Validation';
                field("Source Code"; Rec."Source Code")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
            }
        }

    }

    actions
    {
        area(navigation)
        {
            group("&Header")
            {
                CaptionML = ENU = '&Header', FRA = '&Bordereau';
                Image = DepositSlip;
                action(Dimensions)
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Dimensions', FRA = 'Axes analytiques';
                    Image = Dimensions;

                    trigger OnAction()
                    begin
                        Rec.ShowDocDim;
                        CurrPage.SaveRecord;
                    end;
                }
                action("Header RIB")
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Header RIB', FRA = 'Relevé d''identité bancaire';
                    Image = Check;
                    RunObject = Page "WDC-ED Payment Bank";
                    RunPageLink = "No." = FIELD("No.");
                }
            }
            group("&Navigate")
            {
                CaptionML = ENU = '&Navigate', FRA = 'Navi&guer';
                action(Header)
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Header', FRA = 'En-tête';
                    Image = DepositSlip;

                    trigger OnAction()
                    begin
                        Navigate.SetDoc(Rec."Posting Date", Rec."No.");
                        Navigate.Run;
                    end;
                }
                action(Line)
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Line', FRA = 'Ligne';
                    Image = Line;

                    trigger OnAction()
                    begin
                        CurrPage.Lines.PAGE.NavigateLine(Rec."Posting Date");
                    end;
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                CaptionML = ENU = 'F&unctions', FRA = 'Fonction&s';
                Image = "Action";
                action(SuggestVendorPayments)
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Suggest &Vendor Payments', FRA = 'Proposer paiements &fournisseur';
                    Image = SuggestVendorPayments;
                    Promoted = true;
                    PromotedCategory = Process;
                    trigger OnAction()
                    var
                        PaymentClass: Record "WDC-ED Payment Class";
                        CreateVendorPmtSuggestion: Report "WDC-ED Suggest Vend. Pay. FR";
                        pp: Page 256;
                    begin
                        if Rec."Status No." <> 0 then
                            Message(Text003)
                        else
                            if PaymentClass.Get(Rec."Payment Class") then
                                if PaymentClass.Suggestions = PaymentClass.Suggestions::Vendor then begin
                                    CreateVendorPmtSuggestion.SetGenPayLine(Rec);
                                    CreateVendorPmtSuggestion.RunModal;
                                    Clear(CreateVendorPmtSuggestion);
                                end else
                                    Message(Text001);
                    end;
                }
                action(SuggestCustomerPayments)
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Suggest &Customer Payments', FRA = 'Proposer règlements &client';
                    Image = SuggestCustomerPayments;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        Customer: Record Customer;
                        PaymentClass: Record "WDC-ED Payment Class";
                        CreateCustomerPmtSuggestion: Report "WDC-ED Suggest Cust. Payments";
                    begin
                        if Rec."Status No." <> 0 then
                            Message(Text003)
                        else
                            if PaymentClass.Get(Rec."Payment Class") then
                                if PaymentClass.Suggestions = PaymentClass.Suggestions::Customer then begin
                                    CreateCustomerPmtSuggestion.SetGenPayLine(Rec);
                                    Customer.SetRange("Partner Type", Rec."Partner Type");
                                    CreateCustomerPmtSuggestion.SetTableView(Customer);
                                    CreateCustomerPmtSuggestion.RunModal;
                                    Clear(CreateCustomerPmtSuggestion);
                                end else
                                    Message(Text002);
                    end;
                }
                action(Archive)
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Archive', FRA = 'Archiver';
                    Image = Archive;

                    trigger OnAction()
                    begin
                        if Rec."No." = '' then
                            exit;
                        if not Confirm(Text009) then
                            exit;
                        PaymentMgt.ArchiveDocument(Rec);
                    end;
                }
            }
            group("P&osting")
            {
                CaptionML = ENU = 'P&osting', FRA = '&Validation';
                Image = Post;
                // action(GenerateFile)
                // {
                //     ApplicationArea = All;
                //     CaptionML = ENU = 'Generate file', FRA = 'Générer fichier';
                //     Image = CreateDocument;

                //     trigger OnAction()
                //     begin
                //         PaymentStep.SetRange("Action Type", PaymentStep."Action Type"::"File");
                //         PaymentMgt.ProcessPaymentSteps(Rec, PaymentStep);
                //     end;
                // }
                action(Post)
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Post', FRA = 'Valider';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        PaymentStep.SetFilter(
                          "Action Type",
                          '%1|%2|%3',
                          PaymentStep."Action Type"::None, PaymentStep."Action Type"::Ledger, PaymentStep."Action Type"::"Cancel File");
                        PaymentMgt.ProcessPaymentSteps(Rec, PaymentStep);
                    end;
                }
                action(Print)
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Print', FRA = 'Imprimer';
                    Image = Print;

                    trigger OnAction()
                    begin
                        CurrPage.Lines.PAGE.MarkLines(true);
                        PaymentStep.SetRange("Action Type", PaymentStep."Action Type"::Report);
                        PaymentMgt.ProcessPaymentSteps(Rec, PaymentStep);
                        CurrPage.Lines.PAGE.MarkLines(false);
                    end;
                }
            }
        }
    }

    local procedure DocumentDateOnAfterValidate()
    begin
        CurrPage.Update;
    end;

    var
        PaymentStep: Record "WDC-ED Payment Step";
        PaymentMgt: Codeunit "WDC-ED Payment Management";
        ChangeExchangeRate: Page "Change Exchange Rate";
        Navigate: Page Navigate;
        Text001: TextConst ENU = 'This payment class does not authorize vendor suggestions.',
                           FRA = 'Ce type de règlement n''autorise pas les propositions fournisseur.';
        Text002: TextConst ENU = 'This payment class does not authorize customer suggestions.',
                           FRA = 'Ce type de règlement n''autorise pas les propositions client.';
        Text003: TextConst ENU = 'You cannot suggest payments on a posted header.',
                           FRA = 'Vous n''êtes pas autorisé à faire des propositions de paiement sur un bordereau validé.';
        Text009: TextConst ENU = 'Do you want to archive this document',
                           FRA = 'Souhaitez-vous archiver ce document ?';
}

