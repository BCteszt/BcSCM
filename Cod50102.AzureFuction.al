codeunit 50102 "BCA Azure Function"
{


    procedure GetBeerCategoriesAzure();
    var
        HttpClientVar: HttpClient;
        ResponseMessage: HttpResponseMessage;
        HttpContentVar: HttpContent;
        HttpHeadersVar: HttpHeaders;
        RequestMessage: HttpRequestMessage;
    begin
        HttpContentVar.WriteFrom('{"WhatToGet" : "Beer"}');
        RequestMessage.Content(HttpContentVar);
        RequestMessage.Method('POST');
        HttpContentVar.GetHeaders(HttpHeadersVar);
        HttpHeadersVar.Remove('Content-Type');
        HttpHeadersVar.Add('Content-Type', 'application/json');
        HttpClientVar.Post(GetAzureURL(), HttpContentVar, ResponseMessage);
        ProcessHttpResponseMessage(ResponseMessage);
    end;

    local procedure GetAzureURL(): Text;
    var
        BeerSetup: Record "BCA Beer Setup";
        URL: Text;
    begin
        BeerSetup.GET();
        BeerSetup.TestField("Azure URL");
        BeerSetup.TestField("Azure Function Name");
        URL := 'https://' + BeerSetup."Azure URL" + '/api/' + BeerSetup."Azure Function Name";
        exit(URL);
    end;

    local procedure ProcessHttpResponseMessage(ResponseMessage: HttpResponseMessage);
    var
        TempBeerCategory: Record "BCA Beer Category" temporary;
        BeerCategory: Record "BCA Beer Category";
        Result: Text;
        ResponseData: JsonArray;
        ResponseElement: JsonToken;
        JsonTokenVar: JsonToken;

    begin
        if ResponseMessage.IsSuccessStatusCode() then begin
            ResponseMessage.Content().ReadAs(Result);
            ResponseData.ReadFrom(Result);
            TempBeerCategory.Reset();
            TempBeerCategory.DeleteAll();
            foreach ResponseElement in ResponseData do begin
                Clear(JsonTokenVar);
                ResponseElement.SelectToken('Category', JsonTokenVar);
                if not BeerCategory.get(JsonTokenVar.AsValue().AsText()) then begin
                    TempBeerCategory.Init();
                    TempBeerCategory.Code := COPYSTR(JsonTokenVar.AsValue().AsText(), 1, 20);
                    Clear(JsonTokenVar);
                    ResponseElement.SelectToken('Description', JsonTokenVar);
                    TempBeerCategory.Name := COPYSTR(JsonTokenVar.AsValue().AsText(), 1, 50);
                    TempBeerCategory.Insert();
                end;
            end;
            if TempBeerCategory.Count() > 0 then
                if Confirm(StrSubstNo('%1 new Categories were found. Do you want to insert new categories?', TempBeerCategory.Count()), false) then begin
                    TempBeerCategory.Reset();
                    TempBeerCategory.FindSet();
                    repeat
                        BeerCategory.init();
                        BeerCategory.TransferFields(TempBeerCategory);
                        BeerCategory.Insert(true);
                    until TempBeerCategory.next() = 0;
                end;
        end
        else begin
            ResponseMessage.Content().ReadAs(Result);
            Message('Failed: %1 %2', ResponseMessage.HttpStatusCode(), Result);
        end;
    end;
}