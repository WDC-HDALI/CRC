codeunit 50881 "WDC-ED Update Dtld. CV Led.Ent"
{

    trigger OnRun()
    var
        PaymentReportingMgt: Codeunit "WDC-ED Payment Reporting Mgt.";
    begin
        PaymentReportingMgt.UpdateUnrealizedAdjmtGLAccDtldCustLedgerEntries;
        PaymentReportingMgt.UpdateUnrealizedAdjmtGLAccDtldVendLedgerEntries;
    end;
}

