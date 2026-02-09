page 50045 "Suivi Paiement List"
{
    PageType = List;
    SourceTable = "Payment Tracking Buffer";
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Suivi Paiement Buffer';

    layout
    {
        area(content)
        {
            // --- CHAMPS EN HAUT ---
            group(Filtres)
            {
                Caption = 'Paramètres';

                field(StartDateField; StartDate)
                {
                    ApplicationArea = All;
                    Caption = 'Date Début';
                }

                field(EndDateField; EndDate)
                {
                    ApplicationArea = All;
                    Caption = 'Date Fin';
                }

                field(SalesPersonField; SalesPersonFilter)
                {
                    ApplicationArea = All;
                    Caption = 'Sales Person';
                    TableRelation = "Salesperson/Purchaser".Code;
                }
            }

            // --- TABLEAU D'ORIGINE ---
            repeater(Group)
            {
                field(EntryNo; Rec."Entry No.") { ApplicationArea = All; }
                field(DocumentNo; Rec."Document No.") { ApplicationArea = All; }

                field(CustomerNo; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    TableRelation = Customer."No.";
                }

                field(CustomerName; Rec."Customer Name") { ApplicationArea = All; }

                field(Salesperson; Rec."Salesperson Code")
                {
                    ApplicationArea = All;
                    TableRelation = "Salesperson/Purchaser".Code;
                }

                field(PostingDate; Rec."Posting Date") { ApplicationArea = All; }

                field(ItemNo; Rec."Item No.")
                {
                    ApplicationArea = All;
                    TableRelation = Item."No.";
                }

                field(ItemDescription; Rec."Item Description") { ApplicationArea = All; }
                field(ItemCategory; Rec."Item Category Code") { ApplicationArea = All; }

                field(Quantity; Rec.Quantity) { ApplicationArea = All; }
                field(AmountHT; Rec."Amount Excl. VAT") { ApplicationArea = All; }
                field(AmountTTC; Rec."Amount Incl. VAT") { ApplicationArea = All; }

                field(PaymentDoc; Rec."Payment Document No.") { ApplicationArea = All; }
                field(PaymentAmount; Rec."Payment Amount") { ApplicationArea = All; }

                field(PaymentType; Rec."Payment Type") { ApplicationArea = All; }
                field(PaymentDate; Rec."Payment Date") { ApplicationArea = All; }
                field(DueDate; Rec."Due Date") { ApplicationArea = All; }
                field(DocumentType; Rec."Document Type") { ApplicationArea = All; }
                field(UnitCost; Rec."Unit Cost") { ApplicationArea = All; }
                field(CustomerAmount; Rec."Customer Amount") { ApplicationArea = All; }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(RunProcess)
            {
                ApplicationArea = All;
                Caption = 'Exécuter';
                Image = Action;

                trigger OnAction()
                var
                    SuiviCU: Codeunit "Suivi Paiement";
                begin
                    // Appelle le CU avec 3 paramètres
                    SuiviCU.BuildMatrix(SalesPersonFilter, StartDate, EndDate);
                    Message('Traitement Terminé');
                end;
            }
        }
    }

    // --- VARIABLES ---
    var
        StartDate: Date;
        EndDate: Date;
        SalesPersonFilter: Code[20];
}
