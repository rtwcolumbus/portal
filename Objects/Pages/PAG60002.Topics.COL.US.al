page 60002 "Topics.COL.US"
{
    PageType = List;
    SourceTable = "Topics.COL.US";
    Caption = 'Topics';
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(lines)
            {
                field("Code.COL.US"; "Code.COL.US") { ApplicationArea = All; }
                field("Type.COL.US"; "Type.COL.US") { ApplicationArea = All; }
                field("Name.COL.US"; "Name.COL.US") { ApplicationArea = All; }
                field("Units.COL.US"; "Units.COL.US") { ApplicationArea = All; Width = 3; }
                field("Able Count.COL.US"; "Able Count.COL.US") { ApplicationArea = All; Width = 3; }
                field("Desc.COL.US"; "Desc.COL.US") { ApplicationArea = All; }
                field("Long Desc.COL.US"; "Long Desc.COL.US") { ApplicationArea = All; }
                field("Media.COL.US"; "Media.COL.US") { ApplicationArea = All; }
                field("PreReq.COL.US"; "PreReq.COL.US") { ApplicationArea = All; }
            }

            group(Image)
            {
                field("Mediaa.COL.US"; "Media.COL.US")
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
            action(ableTo)
            {
                Caption = 'Able To';
                ApplicationArea = All;
                Promoted = true;
                RunObject = page "Able To.COL.US";
                RunPageLink = "Group Code.COL.US" = field("Group Code.COL.US"), "Group Version.COL.US" = field("Group Version.COL.US"), "Topic Code.COL.US" = field("Code.COL.US"), "Topic Type.COL.US" = field("Type.COL.US");
            }
            action(subTopics)
            {
                Caption = 'Sub Topics';
                ApplicationArea = All;
                Promoted = true;
                RunObject = page "Sub Topic.COL.US";
                RunPageLink = "Group Code.COL.US" = field("Group Code.COL.US"), "Group Version.COL.US" = field("Group Version.COL.US"), "Topic Code.COL.US" = field("Code.COL.US"), "Topic Type.COL.US" = field("Type.COL.US");
            }
        }
    }
}