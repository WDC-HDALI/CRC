xmlport 50863 "WDC-ED Import/Exp Parameters"
{
    captionML = ENU = 'Import/Export Parameters', FRA = 'Importer/Exporter paramètres';
    DefaultFieldsValidation = false;
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement("Payment Class"; "WDC-ED Payment Class")
            {
                XmlName = 'PaymentClass';
                // SourceTableView = SORTING (Field1); TODO:
                fieldelement(Code; "Payment Class".Code)
                {
                }
                fieldelement(Name; "Payment Class".Name)
                {
                }
                fieldelement(HeaderNoSeries; "Payment Class"."Header No. Series")
                {
                }
                fieldelement(Enable; "Payment Class".Enable)
                {
                }
                fieldelement(LineNoSeries; "Payment Class"."Line No. Series")
                {
                }
                fieldelement(Suggestions; "Payment Class".Suggestions)
                {
                }
                fieldelement(UnrealizedVATReversal; "Payment Class"."Unrealized VAT Reversal")
                {
                }
            }
            tableelement("Payment Status"; "WDC-ED Payment Status")
            {
                XmlName = 'PaymentStatus';
                // SourceTableView = SORTING (Field1, Field2); TODO:
                fieldelement(PaymentClass; "Payment Status"."Payment Class")
                {
                }
                fieldelement(Line; "Payment Status"."Line No.")
                {
                }
                fieldelement(Name; "Payment Status".Name)
                {
                }
                fieldelement(RIB; "Payment Status".RIB)
                {
                }
                fieldelement(Look; "Payment Status".Look)
                {
                }
                fieldelement(ReportMenu; "Payment Status".ReportMenu)
                {
                }
                fieldelement(AcceptationCode; "Payment Status"."Acceptation Code")
                {
                }
                fieldelement(Amount; "Payment Status".Amount)
                {
                }
                fieldelement(Debit; "Payment Status".Debit)
                {
                }
                fieldelement(Credit; "Payment Status".Credit)
                {
                }
                fieldelement(BankAccount; "Payment Status"."Bank Account")
                {
                }
                fieldelement(PaymentInProgress; "Payment Status"."Payment in Progress")
                {
                }
            }
            tableelement("Payment Step"; "WDC-ED Payment Step")
            {
                XmlName = 'PaymentStep';
                // SourceTableView = SORTING (Field1, Field2); TODO:
                fieldelement(PaymentClass; "Payment Step"."Payment Class")
                {
                }
                fieldelement(Line; "Payment Step"."Line No.")
                {
                }
                fieldelement(Name; "Payment Step".Name)
                {
                }
                fieldelement(PreviousStatus; "Payment Step"."Previous Status")
                {
                }
                fieldelement(NextStatus; "Payment Step"."Next Status")
                {
                }
                fieldelement(ActionType; "Payment Step"."Action Type")
                {
                }
                fieldelement(ReportNo; "Payment Step"."Report No.")
                {
                }
                fieldelement(ExportType; "Payment Step"."Export Type")
                {
                }
                fieldelement(ExportNo; "Payment Step"."Export No.")
                {
                }
                fieldelement(VerifyLinesRIB; "Payment Step"."Verify Lines RIB")
                {
                }
                fieldelement(HeaderNoSeries; "Payment Step"."Header Nos. Series")
                {
                }
                fieldelement(ReasonCode; "Payment Step"."Reason Code")
                {
                }
                fieldelement(SourceCode; "Payment Step"."Source Code")
                {
                }
                fieldelement(AcceptationCode; "Payment Step"."Acceptation Code<>No")
                {
                }
                fieldelement(Correction; "Payment Step".Correction)
                {
                }
                fieldelement(VerifyHeaderRIB; "Payment Step"."Verify Header RIB")
                {
                }
                fieldelement(VerifyDueDate; "Payment Step"."Verify Due Date")
                {
                }
                fieldelement(RealizeVAT; "Payment Step"."Realize VAT")
                {
                }
            }
            tableelement("Payment Step Ledger"; "WDC-ED Payment Step Ledger")
            {
                XmlName = 'PaymentStepLedger';
                // SourceTableView = SORTING(Field1, Field2, Field3); TODO:
                fieldelement(PaymentClass; "Payment Step Ledger"."Payment Class")
                {
                }
                fieldelement(Line; "Payment Step Ledger"."Line No.")
                {
                }
                fieldelement(Sign; "Payment Step Ledger".Sign)
                {
                }
                fieldelement(Description; "Payment Step Ledger".Description)
                {
                }
                fieldelement(AccountingType; "Payment Step Ledger"."Accounting Type")
                {
                }
                fieldelement(AccountType; "Payment Step Ledger"."Account Type")
                {
                }
                fieldelement(AccountNo; "Payment Step Ledger"."Account No.")
                {
                }
                fieldelement(CustomerPostingGroup; "Payment Step Ledger"."Customer Posting Group")
                {
                }
                fieldelement(VendorPostingGroup; "Payment Step Ledger"."Vendor Posting Group")
                {
                }
                fieldelement(Root; "Payment Step Ledger".Root)
                {
                }
                fieldelement(DetailLevel; "Payment Step Ledger"."Detail Level")
                {
                }
                fieldelement(Application; "Payment Step Ledger".Application)
                {
                }
                fieldelement(MemorizeEntry; "Payment Step Ledger"."Memorize Entry")
                {
                }
                fieldelement(DocumentType; "Payment Step Ledger"."Document Type")
                {
                }
                fieldelement(DocumentNo; "Payment Step Ledger"."Document No.")
                {
                }
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }
}

