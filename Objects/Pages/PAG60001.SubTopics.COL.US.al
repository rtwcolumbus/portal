page 60001 "Sub Topic.COL.US"
{
    PageType = List;
    SourceTable = "Sub Topics.COL.US";
    Caption = 'Sub Topics';

    layout
    {
        area(Content)
        {
            repeater(lines)
            {
                field("Code.COL.US"; "Code.COL.US") { ApplicationArea = All; }
                field("Name.COL.US"; "Name.COL.US") { ApplicationArea = Alll; }
                field(deets; '...')
                {
                    ApplicationArea = All;
                    Caption = 'Detail';
                    trigger OnAssistEdit()
                    var
                        det: Record "Sub Detail.COL.US";
                    begin
                        det.SetRange("Group Code.COL.US", "Group Code.COL.US");
                        det.SetRange("Group Version.COL.US", "Group Version.COL.US");
                        det.SetRange("Topic Code.COL.US", "Topic Code.COL.US");
                        det.SetRange("Topic Type.COL.US", "Topic Type.COL.US");
                        det.SetRange("Sub Topic Code.COL.US", "Code.COL.US");
                        Page.RunModal(0, det);
                    end;
                }
                field("Desc.COL.US"; "Desc.COL.US") { ApplicationArea = All; }
                field("Time.COL.US"; "Time.COL.US") { ApplicationArea = All; }
                field("Unit Number.COL.US"; "Unit Number.COL.US") { ApplicationArea = All; }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(detail)
            {
                Caption = 'Detail';
                ApplicationArea = All;
                Promoted = true;
                RunObject = page "Sub Detail.COL.US";
                RunPageLink = "Group Code.COL.US" = field("Group Code.COL.US"), "Group Version.COL.US" = field("Group Version.COL.US"), "Topic Code.COL.US" = field("Topic Code.COL.US"), "Topic Type.COL.US" = field("Topic Type.COL.US"), "Sub Topic Code.COL.US" = field("Code.COL.US");
            }
        }
    }
}