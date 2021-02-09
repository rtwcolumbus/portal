page 60000 "Able To.COL.US"
{
    PageType = List;
    SourceTable = "Topic Able.COL.US";
    Caption = 'Able To';

    layout
    {
        area(Content)
        {
            repeater(lines)
            {
                field("Code.COL.US"; "Code.COL.US") { ApplicationArea = All; }
                field("Desc.COL.US"; "Desc.COL.US") { ApplicationArea = All; }
            }
        }
    }
}