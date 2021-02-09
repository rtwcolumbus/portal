table 60001 "Topics.COL.US"
{
    DataClassification = SystemMetadata;
    Caption = 'Topics';
    DrillDownPageId = "Topics.COL.US";
    LookupPageId = "Topics.COL.US";

    fields
    {
        field(1; "Group Code.COL.US"; Code[20]) { DataClassification = SystemMetadata; Caption = 'Group Code'; TableRelation = "Topic Group.COL.US"."Code.COL.US"; }
        field(2; "Group Version.COL.US"; Integer) { DataClassification = SystemMetadata; Caption = 'Group Version'; TableRelation = "Topic Group.COL.US"."Version.COL.US"; }
        field(3; "Code.COL.US"; Code[20]) { DataClassification = SystemMetadata; Caption = 'Code'; }
        field(4; "Type.COL.US"; Enum "Topic Type.COL.US") { DataClassification = SystemMetadata; Caption = 'Type'; }
        field(5; "Name.COL.US"; Text[100]) { DataClassification = SystemMetadata; Caption = 'Name'; }
        field(6; "Desc.COL.US"; Text[250]) { DataClassification = SystemMetadata; Caption = 'Short Desc'; }
        field(11; "Long Desc.COL.US"; Text[250]) { DataClassification = SystemMetadata; Caption = 'Long Desc'; }
        field(7; "Image Name.COL.US"; Text[100]) { DataClassification = SystemMetadata; Caption = 'Image Filename'; ObsoleteState = Removed; }
        field(8; "Units.COL.US"; Integer) { Caption = 'Unit Count'; FieldClass = FlowField; CalcFormula = count("Sub Topics.COL.US" where("Group Code.COL.US" = field("Group Code.COL.US"), "Group Version.COL.US" = field("Group Version.COL.US"), "Topic Code.COL.US" = field("Code.COL.US"), "Topic Type.COL.US" = field("Type.COL.US"))); }
        field(9; "Time.COL.US"; Integer) { Caption = 'Unit Time'; FieldClass = FlowField; CalcFormula = sum("Sub Topics.COL.US"."Time.COL.US" where("Group Code.COL.US" = field("Group Code.COL.US"), "Group Version.COL.US" = field("Group Version.COL.US"), "Topic Code.COL.US" = field("Code.COL.US"), "Topic Type.COL.US" = field("Type.COL.US"))); }
        field(10; "PreReq.COL.US"; TExt[250]) { DataClassification = SystemMetadata; Caption = 'Prerequisite'; }
        field(12; "Able Count.COL.US"; Integer) { Caption = 'Able Tos'; FieldClass = FlowField; CalcFormula = count("Topic Able.COL.US" where("Group Code.COL.US" = field("Group Code.COL.US"), "Group Version.COL.US" = field("Group Version.COL.US"), "Topic Code.COL.US" = field("Code.COL.US"), "Topic Type.COL.US" = field("Type.COL.US"))); }
        field(13; "Media.COL.US"; Blob) { DataClassification = SystemMetadata; Caption = 'Image'; Subtype = Bitmap; }


    }

    keys
    {
        key(PKey; "Group Code.COL.US", "Group Version.COL.US", "Code.COL.US", "Type.COL.US") { Clustered = true; }
    }

    trigger OnDelete()
    var
        child: Record "Sub Topics.COL.US";
        childA: Record "Topic Able.COL.US";
    begin
        child.SetRange("Group Code.COL.US", "Group Code.COL.US");
        child.SetRange("Group Version.COL.US", "Group Version.COL.US");
        child.SetRange("Topic Code.COL.US", "Code.COL.US");
        child.SetRange("Topic Type.COL.US", "Type.COL.US");
        if not child.IsEmpty then
            child.DeleteAll(true);

        childA.SetRange("Group Code.COL.US", "Group Code.COL.US");
        childA.SetRange("Group Version.COL.US", "Group Version.COL.US");
        childA.SetRange("Topic Code.COL.US", "Code.COL.US");
        childA.SetRange("Topic Type.COL.US", "Type.COL.US");
        if not childA.IsEmpty then
            childA.DeleteAll(true);
    end;
}