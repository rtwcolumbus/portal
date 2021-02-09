table 60002 "Sub Topics.COL.US"
{
    DataClassification = SystemMetadata;
    Caption = 'Topics';
    DrillDownPageId = "Sub Topic.COL.US";
    LookupPageId = "Sub Topic.COL.US";

    fields
    {
        field(1; "Group Code.COL.US"; Code[20]) { DataClassification = SystemMetadata; Caption = 'Group Code'; TableRelation = "Topic Group.COL.US"."Code.COL.US"; }
        field(2; "Group Version.COL.US"; Integer) { DataClassification = SystemMetadata; Caption = 'Group Version'; TableRelation = "Topic Group.COL.US"."Version.COL.US"; }
        field(3; "Topic Code.COL.US"; Code[20]) { DataClassification = SystemMetadata; Caption = 'Topic Code'; }
        field(4; "Topic Type.COL.US"; Enum "Topic Type.COL.US") { DataClassification = SystemMetadata; Caption = 'Topic Type'; }
        field(5; "Code.COL.US"; Code[20]) { DataClassification = SystemMetadata; Caption = 'Code'; }
        field(6; "Name.COL.US"; Text[100]) { DataClassification = SystemMetadata; Caption = 'Name'; }
        field(7; "Desc.COL.US"; Text[250]) { DataClassification = SystemMetadata; Caption = 'Description'; }
        field(8; "Time.COL.US"; Integer) { DataClassification = SystemMetadata; Caption = 'Time to complete in mins'; }
        field(9; "Unit Number.COL.US"; integer) { DataClassification = SystemMetadata; Caption = 'Unit Number X of ...'; }

    }

    keys
    {
        key(PKey; "Group Code.COL.US", "Group Version.COL.US", "Topic Code.COL.US", "Topic Type.COL.US", "Code.COL.US") { Clustered = true; }
    }

    trigger OnDelete()
    var
        child: Record "Sub Detail.COL.US";
    begin
        child.SetRange("Group Code.COL.US", "Group Code.COL.US");
        child.SetRange("Group Version.COL.US", "Group Version.COL.US");
        child.SetRange("Topic Code.COL.US", "Topic Code.COL.US");
        child.SetRange("Topic Type.COL.US", "Topic Type.COL.US");
        child.SetRange("Sub Topic Code.COL.US", "Code.COL.US");
        if not child.IsEmpty then
            child.DeleteAll(true);
    end;

}