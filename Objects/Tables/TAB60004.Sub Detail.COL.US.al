table 60004 "Sub Detail.COL.US"
{
    DataClassification = SystemMetadata;
    Caption = 'Sub Topic Details';
    DrillDownPageId = "Sub Detail.COL.US";
    LookupPageId = "Sub Detail.COL.US";

    fields
    {
        field(1; "Group Code.COL.US"; Code[20]) { DataClassification = SystemMetadata; Caption = 'Group Code'; TableRelation = "Topic Group.COL.US"."Code.COL.US"; }
        field(2; "Group Version.COL.US"; Integer) { DataClassification = SystemMetadata; Caption = 'Group Version'; TableRelation = "Topic Group.COL.US"."Version.COL.US"; }
        field(3; "Topic Code.COL.US"; Code[20]) { DataClassification = SystemMetadata; Caption = 'Topic Code'; }
        field(4; "Topic Type.COL.US"; Enum "Topic Type.COL.US") { DataClassification = SystemMetadata; Caption = 'Topic Type'; }
        field(5; "Sub Topic Code.COL.US"; Code[20]) { DataClassification = SystemMetadata; Caption = 'Code'; }
        field(6; "Id.COL.US"; Integer) { DataClassification = SystemMetadata; Caption = 'ID'; }

        field(7; "Type.COL.US"; Enum "Detail Type.COL.US") { DataClassification = SystemMetadata; Caption = 'Type'; }
        field(8; "Txt.COL.US"; Blob) { DataClassification = SystemMetadata; Caption = 'Text'; Subtype = Memo; }
        field(9; "Image.COL.US"; Media) { DataClassification = SystemMetadata; Caption = 'Image'; }
        field(10; "Media.COL.US"; Blob) { DataClassification = SystemMetadata; Caption = 'Media'; Subtype = Bitmap; }
        field(11; "Desc.COL.US"; Text[50]) { DataClassification = SystemMetadata; Caption = 'Description'; }



    }

    keys
    {
        key(PKey; "Group Code.COL.US", "Group Version.COL.US", "Topic Code.COL.US", "Topic Type.COL.US", "Sub Topic Code.COL.US", "Id.COL.US") { Clustered = true; }
    }

}