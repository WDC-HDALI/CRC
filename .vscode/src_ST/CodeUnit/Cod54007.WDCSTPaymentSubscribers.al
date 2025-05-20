// codeunit 54007 "WDC-ST PaymentSubscribers"
// {
//     [EventSubscriber(ObjectType::Table, Database::"Payment Line", 'OnAfterValidateEvent', 'Amount', FALSE, FALSE)]
//     local procedure OnAfterValidateEventAmountPayLine(var Rec: Record "Payment Line"; var xRec: Record "Payment Line"; CurrFieldNo: Integer)
//     begin
//         IF (Rec."Montant Retenue" = 0) AND (Rec."Montant Retenue Validé" = 0) AND (Rec."Montant Retenue TVA" = 0)
//             AND (Rec."Montant Retenue TVA Validé" = 0) AND (Rec."Montant Commission" = 0) AND (Rec."Montant Commission Validé" = 0)
//             AND (Rec."Montant TVA sur Commission" = 0) AND (Rec."Montant TVA sur Com. validé" = 0) THEN BEGIN
//             Rec."Montant Initial" := Rec.Amount;
//             Rec."Montant Initial DS" := Rec."Amount (LCY)";
//         END;
//     end;
// }