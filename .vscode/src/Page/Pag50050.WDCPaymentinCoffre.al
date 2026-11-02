page 50050 "WDC Payment in Coffre"
{
    ApplicationArea = All;
    CaptionML = ENU = 'Payment in Coffre', FRA = 'Paiement en coffre';
    PageType = List;
    SourceTable = "WDC Payment In Coffre";
    UsageCategory = Lists;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                Editable = Rec.Status = Rec.Status::Open;
                // field("Entry No."; Rec."Entry No.")
                // {
                //     ApplicationArea = all;
                // }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = all;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = all;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = all;
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ApplicationArea = all;
                }

                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = all;
                }
                field("Payment Type"; Rec."Payment Type")
                {
                    ApplicationArea = all;
                    ValuesAllowed = Draft, Cheque;
                }
                field("Payment Amount"; Rec."Payment Amount")
                {
                    ApplicationArea = all;
                }
                field("Payment Reference"; Rec."Payment Reference")
                {
                    ApplicationArea = all;
                }
                field("Bank Name"; Rec."Bank Name")
                {
                    ApplicationArea = all;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                }
                field("Payment Date"; Rec."Payment Date")
                {
                    ApplicationArea = all;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Release)
            {
                ApplicationArea = all;
                CaptionML = ENU = 'Release', FRA = 'Lancer';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = ReleaseDoc;
                trigger OnAction()
                var
                    lText001: TextConst ENU = 'Payment has been released successfully.',
                                        FRA = 'Le paiement a été lancé.';
                    lText002: TextConst ENU = 'Are you sure you want to release this payment?',
                                        FRA = 'Voulez-vous lancer ce paiement?';
                begin
                    if not Confirm(lText002) then
                        exit;
                    Rec.TestField(Status, Rec.Status::Open);
                    Rec.TestField("Payment Reference");
                    Rec.TestField("Bank Name");
                    Rec.TestField("Due Date");
                    Rec.TestField("Customer No.");
                    Rec.TestField("Payment Amount");
                    Rec.Status := Rec.Status::Released;
                    Rec.Modify();
                    Message(lText001);
                end;
            }
            action("Re-Open")
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                CaptionML = ENU = 'Reopen', FRA = 'Ré-Ouvrir';
                Image = ReOpen;
                trigger OnAction()
                var
                    lText001: TextConst ENU = 'Payment has been reopened successfully.',
                                        FRA = 'Le paiement a été ré-ouvert.';
                    lText002: TextConst ENU = 'Are you sure you want to reopen this payment?',
                                        FRA = 'Voulez-vous ré-ouvrir ce paiement?';
                begin
                    if Not Confirm(lText002) then
                        exit;
                    rec.TestField(Status, rec.Status::Released);
                    Rec.Status := Rec.Status::Open;
                    Rec.Modify();
                    Message(lText001);
                end;
            }
            action(Pay)
            {
                ApplicationArea = all;
                CaptionML = ENU = 'Pay', FRA = 'Payer';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Payment;
                trigger OnAction()
                var
                    lText001: TextConst ENU = 'Payment has been Paid successfully.',
                                        FRA = 'Le paiement a été payé.';
                    lText002: TextConst ENU = 'Are you sure you want to pay this payment?',
                                        FRA = 'Voulez-vous payer ce paiement?';
                begin
                    if not Confirm(lText002) then
                        exit;
                    rec.TestField(Status, rec.Status::Released);
                    Rec.Status := Rec.Status::Paied;
                    Rec."Payment Date" := WorkDate();
                    Rec.Modify();
                    Message(lText001);
                end;
            }

            // action(Post)
            // {
            //     ApplicationArea = all;
            //     CaptionML = ENU = 'Post', FRA = 'Comptabiliser';
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     PromotedIsBig = true;
            //     Image = Post;
            //     trigger OnAction()
            //     var
            //         lText001: TextConst ENU = 'Payment has been posted successfully.',
            //                             FRA = 'Le paiement a été comptabilisé.';
            //         lText002: TextConst ENU = 'Are you sure you want to post this payment?',
            //                             FRA = 'Voulez-vous comptabiliser ce paiement?';
            //     begin
            //         if not Confirm(lText002) then
            //             exit;
            //         rec.TestField(Status, rec.Status::Released);
            //         PostPayment(Rec);
            //         // Rec.Status := Rec.Status::Posted;
            //         // Rec.Modify();
            //         Message(lText001);
            //     end;
            // }

        }
    }
    // procedure PostPayment(Var pPayment: Record "WDC Payment In Coffre")
    // var
    //     lGenJournalLine: Record "Gen. Journal Line";
    //     lPaymentMethod: Record "Payment Method";
    //     lGenJnlPostBatch: Codeunit "Gen. Jnl.-Post Batch";
    //     lNoSeries: Codeunit "No. Series";
    //     lGenJournalBatch: Record "Gen. Journal Batch";
    // begin
    //     lPaymentMethod.Reset();
    //     lPaymentMethod.SetRange("Payment Type", pPayment."Payment Type");
    //     if lPaymentMethod.FindFirst() then begin
    //         lGenJournalBatch.Get('PAYMENTS', 'P_COFFRE');
    //         InitGenJournalLine;
    //         lGenJournalLine.Init();
    //         lGenJournalLine."Journal Template Name" := 'PAYMENTS';
    //         lGenJournalLine."Journal Batch Name" := 'P_COFFRE';
    //         lGenJournalLine."Document Date" := pPayment."Document Date";
    //         lGenJournalLine.Validate("Posting Date", workdate);
    //         lGenJournalLine."Line No." := lGenJournalLine.GetNewLineNo(lGenJournalLine."Journal Template Name", lGenJournalLine."Journal Batch Name");
    //         lGenJournalLine."Document No." := lNoSeries.PeekNextNo(lGenJournalBatch."No. Series", WorkDate);
    //         lGenJournalLine.Insert(true);
    //         lGenJournalLine."Document Type" := lGenJournalLine."Document Type"::Payment;
    //         lGenJournalLine."Account Type" := lGenJournalLine."Account Type"::Customer;
    //         lGenJournalLine."Account No." := pPayment."Customer No.";
    //         lGenJournalLine."Amount" := -pPayment."Payment Amount";
    //         lGenJournalLine."Bal. Account Type" := lPaymentMethod."Bal. Account Type";
    //         lGenJournalLine."Bal. Account No." := lPaymentMethod."Bal. Account No.";
    //         lGenJournalLine."Payment Method Code" := lPaymentMethod.Code;
    //         lGenJournalLine."Payment Reference" := pPayment."Payment Reference";
    //         lGenJournalLine."Bank Name" := pPayment."Bank Name";
    //         lGenJournalLine.Modify(true);
    //         lGenJnlPostBatch.Run(lGenJournalLine);
    //         pPayment."Posting Date" := lGenJournalLine."Posting Date";
    //         pPayment.Status := pPayment.Status::Posted;
    //         pPayment.Modify();

    //     end;


    //end;

    procedure InitGenJournalLine()
    var
        lGenJournalLine: Record "Gen. Journal Line";
    begin
        lGenJournalLine.Reset();
        lGenJournalLine.SetRange("Journal Template Name", 'PAYMENTS');
        lGenJournalLine.SetRange("Journal Batch Name", 'P_COFFRE');
        if lGenJournalLine.FindFirst() then
            lGenJournalLine.DeleteAll();
    end;
}