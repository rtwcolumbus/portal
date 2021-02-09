page 60004 "Group Topics.COL.US"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Topic Group.COL.US";
    Caption = 'Group Topics';

    layout
    {
        area(Content)
        {
            repeater(lines)
            {
                field("Code.COL.US"; "Code.COL.US") { ApplicationArea = All; }
                field("Version.COL.US"; "Version.COL.US") { ApplicationArea = All; }
                field("Name.COL.US"; "Name.COL.US") { ApplicationArea = All; }
                field("Desc.COL.US"; "Desc.COL.US") { ApplicationArea = All; }
                field("Topci Count.COL.US"; "Topci Count.COL.US") { ApplicationArea = All; Width = 3; }
                field("Time.COL.US"; "Time.COL.US") { ApplicationArea = All; Width = 3; }
                field("Media.COL.US"; "Media.COL.US") { ApplicationArea = All; }

            }
            group(Image)
            {
                field("MediaBox.COL.US"; "Media.COL.US")
                {
                    ApplicationArea = All;
                    ShowCaption = false;
                    trigger OnValidate()
                    begin
                        CurrPage.SaveRecord();
                    end;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(topics)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Caption = 'Topics';
                RunObject = page "Topics.COL.US";
                RunPageLink = "Group Code.COL.US" = field("Code.COL.US"), "Group Version.COL.US" = field("Version.COL.US");
            }
            action(Generate)
            {
                ApplicationArea = All;
                Promoted = true;
                Caption = 'Generate HTML';
                RunObject = codeunit "Topic Mgmt.COL.US";
            }
        }
    }
}