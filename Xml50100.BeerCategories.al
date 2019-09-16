xmlport 50100 "BCA Beer Categories"
{
    schema
    {
        textelement(BCA_Beer_Categories)
        {
            tableelement(BCA_Beer_Category; "BCA Beer Category")
            {
                AutoReplace = true;
                fieldattribute(Name; BCA_Beer_Category.Name)
                {
                }
                fieldattribute(Code; BCA_Beer_Category.Code)
                {
                }
            }
        }
    }

}