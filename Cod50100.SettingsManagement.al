codeunit 50100 "BCA Settings Management"
{
    [EventSubscriber(ObjectType::Table, Database::"BCA Beer Category", 'OnBeforeValidateEvent', 'Code', false, false)]
    local procedure OnBeerCategoryCodeValidate(Rec: Record "BCA Beer Category"; XRec: Record "BCA Beer Category");
    var
        notBeerMessageLbl: Label 'This is not a beer!';
    begin
        if StrPos(Rec.Code, 'WINE') > 0 then Error(notBeerMessageLbl);
    end;

    [EventSubscriber(ObjectType::page, Page::"O365 Activities", 'OnOpenPageEvent', '', false, false)]
    local procedure O365Activities_OnOpenPage();
    begin
        ShowBeerSetupWarning();
    end;

    procedure ExportBeerCategories();
    var
        TmpBlob: Record TempBlob temporary;
        BCABeerCategoriesXML: XmlPort "BCA Beer Categories";
        OutStr: OutStream;
        InStr: InStream;
        FileName: Text;
        FileNameLbl: Label 'BeerCategories.xml';
        DialogTitleLbl: Label 'Beer Categories Export';
    begin
        TmpBlob.Init();
        TmpBlob.Blob.CreateOutStream(OutStr);
        BCABeerCategoriesXML.SetDestination(OutStr);
        BCABeerCategoriesXML.Export();
        TmpBlob.Blob.CreateInStream(InStr);
        FileName := FileNameLbl;
        file.DownloadFromStream(InStr, DialogTitleLbl, '', '', FileName);
    end;

    procedure ImportBeerCategories1();
    var
        TmpBlob: Record TempBlob temporary;
        BCABeerCategoriesXML: XmlPort "BCA Beer Categories";
        InStr: InStream;
        FileName: Text;
        DialogTitleLbl: Label 'Select XML file for Import';
        FromFilterLbl: Label 'XML Files (*.xml)|*.xml', locked = true;
    begin
        TmpBlob.Init();
        TmpBlob.Blob.CreateInStream(InStr);
        file.UploadIntoStream(DialogTitleLbl, '', FromFilterLbl, FileName, InStr);
        BCABeerCategoriesXML.SetSource(InStr);
        BCABeerCategoriesXML.Import();
    end;

    procedure ImportBeerCategories()
    var
        TmpBlob: Record TempBlob temporary;
        BCABeerCategories: XmlPort "BCA Beer Categories";
        InStr: InStream;
        FileName: Text;
        DialogTitleLbl: Label 'Select file for Import';
        FromFilterLbl: Label 'Import Files (*.csv)|*.csv)', locked = true;
    begin
        TmpBlob.Init();
        TmpBlob.Blob.CreateInStream(InStr);
        file.UploadIntoStream(DialogTitleLbl, '', FromFilterLbl, FileName, InStr);
        BCABeerCategories.SetSource(InStr);
        BCABeerCategories.Import();
    end;

    local procedure ShowBeerSetupWarning()
    var
        BeerSetup: Record "BCA Beer Setup";
        BeerNotification: Notification;
        BeerSetupOk: Boolean;
        NotificationTxt: Label 'Beer Setup isn''t finished. Do you want to run the wizard?';
        RunWizardTxt: Label 'Run Beer Setup Wizard';
    begin
        if BeerSetup.Get() then
            BeerSetupOk := (BeerSetup."Azure URL" <> '') and (BeerSetup."Azure Function Name" <> '');
        if not BeerSetupOk then begin
            BeerNotification.ID(format(CREATEGUID(), 0, 9));
            BeerNotification.Scope(NotificationScope::LocalScope);
            BeerNotification.Message(NotificationTxt);
            BeerNotification.AddAction(RunWizardTxt, Codeunit::"BCA Settings Management", 'RunBeerSetupWizard');
            BeerNotification.Send();
        end;
    end;

    procedure RunBeerSetupWizard(BeerNotification: Notification);
    begin
        Page.Run(Page::"BCA Initial Setup Wizard");
    end;
}