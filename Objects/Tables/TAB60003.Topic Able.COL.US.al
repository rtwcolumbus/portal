table 60003 "Topic Able.COL.US"
{
    DataClassification = SystemMetadata;
    Caption = 'Able To';
    DrillDownPageId = "Able To.COL.US";
    LookupPageId = "Able To.COL.US";

    fields
    {
        field(1; "Group Code.COL.US"; Code[20]) { DataClassification = SystemMetadata; Caption = 'Group Code'; TableRelation = "Topic Group.COL.US"."Code.COL.US"; }
        field(2; "Group Version.COL.US"; Integer) { DataClassification = SystemMetadata; Caption = 'Group Version'; TableRelation = "Topic Group.COL.US"."Version.COL.US"; }
        field(3; "Topic Code.COL.US"; Code[20]) { DataClassification = SystemMetadata; Caption = 'Topic Code'; }
        field(4; "Topic Type.COL.US"; Enum "Topic Type.COL.US") { DataClassification = SystemMetadata; Caption = 'Topic Type'; }
        field(5; "Code.COL.US"; Code[20]) { DataClassification = SystemMetadata; Caption = 'Code'; }
        field(6; "Desc.COL.US"; Text[250]) { DataClassification = SystemMetadata; Caption = 'Description'; }
    }

    keys
    {
        key(PKey; "Group Code.COL.US", "Group Version.COL.US", "Topic Code.COL.US", "Topic Type.COL.US", "Code.COL.US") { Clustered = true; }
    }

}