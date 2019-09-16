codeunit 50101 "BCA App Install"
{
    Subtype = Install;
    trigger OnInstallAppPerCompany();
    var
        AppInfo: ModuleInfo;
    begin
        NavApp.GetCurrentModuleInfo(AppInfo);
        if AppInfo.DataVersion() = Version.Create(0, 0, 0, 0) then
            HandleInstall()
        else
            HandleReInstall();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Service Connection", 'OnRegisterServiceConnection', '', false, false)]
    local procedure TAB1400_OnRegisterServiceConnection(var ServiceConnection: Record "Service Connection")
    var
        BeerSetup: Record "BCA Beer Setup";
        BeerSetupLbl: Label 'Initial Beer Setup';
    begin
        if not BeerSetup.Get() then begin
            if not BeerSetup.WritePermission() then
                exit;
            BeerSetup.Init();
            BeerSetup.Insert();
        end;
        ServiceConnection.Status := ServiceConnection.Status::Disabled;
        if (BeerSetup."Azure URL" <> '') and (BeerSetup."Azure Function Name" <> '') then
            ServiceConnection.Status := ServiceConnection.Status::Enabled;
        ServiceConnection.InsertServiceConnection(ServiceConnection, BeerSetup.RecordId(), BeerSetupLbl, '', page::"BCA Initial Setup Wizard");
    end;

    local procedure HandleInstall()
    var
        BeerCategory: Record "BCA Beer Category";
    begin
        with BeerCategory do begin
            Reset();
            DeleteAll();
            Init();

            Validate(Code, 'Initial Category 1');
            Validate(Name, 'Initial Category 1');
            Insert(true);
            Init();
            Validate(Code, 'Initial Category 2');
            Validate(Name, 'Initial Category 2');
            Insert(true);
        end
    end;

    local procedure HandleReInstall()
    var
        BeerCategory: Record "BCA Beer Category";
    begin
        with BeerCategory do begin
            if not BeerCategory.Get('Initial Category 1') then begin
                Init();
                Validate(Code, 'Initial Category 1');
                Validate(Name, 'Initial Category 1 (Restored)');
                Insert(true);
            end;
            if not BeerCategory.Get('Initial Category 2') then begin
                Init();
                Validate(Code, 'Initial Category 2');
                Validate(Name, 'Initial Category 2 (Restored)');
                Insert(true);
            end;
        end;
    end;

    var
        myInt: Integer;
}