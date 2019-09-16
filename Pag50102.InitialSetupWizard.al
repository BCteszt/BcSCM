page 50104 "BCA Initial Setup Wizard"
{
    PageType = NavigatePage;
    Caption = 'Initial Setup Wizard';
    SourceTable = "BCA Beer Setup";
    UsageCategory = Administration;
    layout
    {
        area(Content)
        {
            group(WelcomeStep)
            {
                Visible = StepWelcomeVisible;
                group(WelcomeStep1)
                {
                    Caption = 'Welcome to Beer Setup Wizard';
                    InstructionalText = 'This setup will allow you to easily specify information for initial data load';
                }
                group(WelcomStep2)
                {
                    Caption = '', locked = true;
                    InstructionalText = 'Choose Next to start.';
                }
            }
            group(StepAzureURL)
            {
                Visible = StepURLVisible;
                InstructionalText = 'Please specify Azure URL address';
                field(AzureURL; AzureURL)
                {
                    ApplicationArea = All;
                    Caption = 'URL Address';
                    ToolTip = 'E.g. extv2workshop.azurewebsites.net';
                }
            }
            group(StepAzureFunction)
            {
                Visible = StepFunctionVisible;
                InstructionalText = 'Please specify Azure function name';
                field(AzureFunctionName; AzureFunctionName)
                {
                    ApplicationArea = All;
                    Caption = 'Function Name';
                    ToolTip = 'E.g. HttpTriggerCSharp1';
                }
            }
            group(StepFinish)
            {
                Visible = StepFinishVisible;
                InstructionalText = 'Finish setup';
                group(StepFinish1)
                {
                    Caption = '';
                    InstructionalText = 'To enable changes, choose Finish.';
                }

                group(StepFinish2)
                {
                    Caption = '';
                    InstructionalText = 'Notice: All fields must be filled to enable finish button.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Back)
            {
                Enabled = BackActionEnabled;
                Caption = 'Back';
                Image = PreviousRecord;
                InFooterBar = true;
                ApplicationArea = All;
                trigger OnAction();
                begin
                    NextStep(true);
                end;
            }
            action(Next)
            {
                Enabled = NextActionEnabled;
                Caption = 'Next';
                Image = NextRecord;
                InFooterBar = true;
                ApplicationArea = All;
                trigger OnAction();
                begin
                    NextStep(false);
                end;
            }
            action(Finish)
            {
                Enabled = FinishActionEnabled;
                Caption = 'Finish';
                Image = Approve;
                InFooterBar = true;
                ApplicationArea = All;
                trigger OnAction();
                begin
                    FinishAction();
                end;
            }
        }
    }
    local procedure EnableControls();
    begin
        if (AzureURL <> '') and (AzureFunctionName <> '') then
            FinishActionEnabled := true
        else
            FinishActionEnabled := false;
        BackActionEnabled := true;
        NextActionEnabled := true;
        StepWelcomeVisible := false;
        StepURLVisible := false;
        StepFunctionVisible := false;
        StepFinishVisible := false;
        case Step of
            Step::StepWelcome:
                begin
                    StepWelcomeVisible := true;
                    BackActionEnabled := false;
                    FinishActionEnabled := false;
                end;
            Step::StepURL:
                StepURLVisible := true;
            Step::StepFunction:
                StepFunctionVisible := true;
            Step::StepFinish:
                begin
                    StepFinishVisible := true;
                    NextActionEnabled := false;
                end;
        end;
    end;

    local procedure NextStep(Backwards: Boolean);
    begin
        if Backwards then
            Step := Step - 1
        else
            Step := Step + 1;
        EnableControls();
    end;

    local procedure InsertRecord();
    var
        BeerSetup: Record "BCA Beer Setup";
    begin
        if not BeerSetup.Get() then
            BeerSetup.Insert();
        if AzureURL <> '' then
            BeerSetup.Validate("Azure URL", AzureURL);
        if AzureFunctionName <> '' then
            BeerSetup.Validate("Azure Function Name", AzureFunctionName);
        BeerSetup.Modify(true);
    end;

    local procedure FinishAction();
    begin
        InsertRecord();
        CurrPage.Close();
    end;

    trigger OnOpenPage();
    begin
        EnableControls();
    end;

    var
        Step: Option StepWelcome,StepURL,StepFunction,StepFinish;
        AzureURL: Text[250];
        AzureFunctionName: Text[250];
        NextActionEnabled: Boolean;
        BackActionEnabled: Boolean;
        FinishActionEnabled: Boolean;
        StepWelcomeVisible: Boolean;
        StepURLVisible: Boolean;
        StepFunctionVisible: Boolean;
        StepFinishVisible: Boolean;

}