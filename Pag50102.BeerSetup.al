page 50103 "BCA Beer Setup"
{
    PageType = Card;
    Caption = 'Beer Setup';
    ApplicationArea = All;
    UsageCategory = Documents;
    SourceTable = "BCA Beer Setup";
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("Azure URL"; "Azure URL")
                {
                    ApplicationArea = All;
                }
                field("Azure Function Name"; "Azure Function Name")
                {
                    ApplicationArea = All;
                }
            }
        }

    }

    trigger OnOpenPage();
    begin
        Reset();
        if not Get() then begin
            Init();
            Insert();
        end;
    end;

}