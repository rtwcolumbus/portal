page 60005 "Sub Detail.COL.US"
{
    PageType = ListPlus;
    SourceTable = "Sub Detail.COL.US";
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(lines)
            {
                field("Type.COL.US"; "Type.COL.US") { ApplicationArea = All; }
                field("Desc.COL.US"; "Desc.COL.US") { ApplicationArea = All; }
            }
            group(x)
            {
                Caption = 'Text';
                Visible = ("Type.COL.US" = "Type.COL.US"::Text);
                field(bigTxt; txt)
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    ShowCaption = false;

                    trigger OnValidate()
                    begin
                        WriteTxt();
                    end;
                }
            }
            group(y)
            {
                Caption = 'Image';
                Visible = ("Type.COL.US" = "Type.COL.US"::Image);
                field("Media.COL.US"; "Media.COL.US")
                {
                    ApplicationArea = All;
                    ShowCaption = false;
                    trigger OnValidate()
                    begin
                        CurrPage.SaveRecord();
                    end;
                }
            }
            group(z)
            {
                Caption = 'HTML';
                Visible = ("Type.COL.US" = "Type.COL.US"::HJTML);
                field(htmlTxt; txt)
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    ShowCaption = false;

                    trigger OnValidate()
                    begin
                        WriteTxt();
                    end;
                }
                usercontrol(html; HTML)
                {
                    ApplicationArea = All;
                    trigger ControlReady()
                    begin
                        CurrPage.html.Render('<label>Search for <i>Users</i>, open the page and click <i>New</i>. Populate the fields:</label>');
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        CalcTxt();
    end;

    trigger OnAfterGetRecord()
    begin
        CalcTxt();
    end;

    var
        txt: BigText;

    local procedure CalcTxt()
    var
        iStrm: InStream;
    begin
        clear(txt);
        if ("Type.COL.US" = "Type.COL.US"::Text) or ("Type.COL.US" = "Type.COL.US"::HJTML) then begin
            CalcFields("Txt.COL.US");
            "Txt.COL.US".CreateInStream(iStrm);
            txt.Read(iStrm);
        end;
    end;

    local procedure WriteTxt()
    var
        oStrm: OutStream;
    begin
        clear("Txt.COL.US");
        "Txt.COL.US".CreateOutStream(oStrm);
        txt.Write(oStrm);
        Modify();
    end;
}