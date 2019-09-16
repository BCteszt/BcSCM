pageextension 50102 "BCA Item Card" extends "Item Card"
{
    layout
    {
        addlast(Content)
        {
            group(BCA_Beer_Category)
            {
                Caption = 'Beer Category';

                field("BCA Beer Category Code"; "BCA Beer Category Code")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("BCA Beer Category Name"; "BCA Beer Category Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

}