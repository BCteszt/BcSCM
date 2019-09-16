report 50100 "BCA Beer Categories"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Beer Categories';
    DefaultLayout = RDLC;
    RDLCLayout = '.\BeerCategories.rdl';

    dataset
    {
        dataitem(BCABeerCategory; "BCA Beer Category")
        {
            column(Code; Code)
            {
                IncludeCaption = true;
            }
            column(Name; Name)
            {
                IncludeCaption = true;
            }
        }
    }

}