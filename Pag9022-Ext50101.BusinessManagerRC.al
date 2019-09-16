pageextension 50101 "BCA Business Manager RC" extends "Business Manager Role Center"
{
    actions
    {
        addlast(Sections)
        {
            group(BCA_Beer_Categories)
            {
                Caption = 'Beer Categories';
                action(BCA_Beer_Categories_Action)
                {
                    Caption = 'Beer Categories';
                    ApplicationArea = All;
                    RunObject = page "BCA Beer Category List";
                }
            }
        }
    }


    var
        myInt: Integer;

}