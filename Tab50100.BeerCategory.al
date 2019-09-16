table 50100 "BCA Beer Category"
{
    DataClassification = ToBeClassified;
    Caption = 'Beer Category';
    fields
    {
        field(1; Code; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Code';
            NotBlank = true;
        }

        field(2; Name; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Name';
        }
    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }

}