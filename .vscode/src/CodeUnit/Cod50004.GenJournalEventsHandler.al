namespace CRC.CRC;
using Microsoft.Finance.GeneralLedger.Journal;

// codeunit 50004 GenJournalEventsHandler
// {
//     [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterValidateEvent', 'Journal Batch Name', false, false)]
//     local procedure OnAfterValidateJournalBatchName(var Rec: Record "Gen. Journal Line"; xRec: Record "Gen. Journal Line")
//     var
//         GenJournalLine: Record "Gen. Journal Line";
//         GenJournalBatch: Record "Gen. Journal Batch";
//         NextLineNo: Integer;
//     begin

//         if not GenJournalBatch.Get(Rec."Journal Template Name", Rec."Journal Batch Name") then
//             exit;


//         GenJournalLine.Reset();
//         GenJournalLine.SetRange("Journal Template Name", Rec."Journal Template Name");
//         GenJournalLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");

//         if GenJournalLine.FindSet() then begin

//             repeat
//                 GenJournalLine."Account Type" := GenJournalBatch."Account Type";
//                 GenJournalLine."Account No." := GenJournalBatch."Account No.";
//                 GenJournalLine."Bal. Account Type" := GenJournalBatch."Bal. Account Type";
//                 GenJournalLine."Bal. Account No." := GenJournalBatch."Bal. Account No.";
//                 GenJournalLine.Modify();
//             until GenJournalLine.Next() = 0;
//         end else begin

//             GenJournalLine.Init();
//             GenJournalLine."Journal Template Name" := Rec."Journal Template Name";
//             GenJournalLine."Journal Batch Name" := Rec."Journal Batch Name";
//             GenJournalLine."Line No." := 10000;

//             GenJournalLine."Account Type" := GenJournalBatch."Account Type";
//             GenJournalLine."Account No." := GenJournalBatch."Account No.";
//             GenJournalLine."Bal. Account Type" := GenJournalBatch."Bal. Account Type";
//             GenJournalLine."Bal. Account No." := GenJournalBatch."Bal. Account No.";


//             GenJournalLine."Posting Date" := WorkDate();

//             GenJournalLine.Insert();
//         end;
//     end;


// }
