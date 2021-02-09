table 60000 "Topic Group.COL.US"
{
    DataClassification = SystemMetadata;
    Caption = 'Topic Group';

    fields
    {
        field(1; "Code.COL.US"; Code[20]) { DataClassification = SystemMetadata; Caption = 'Code'; NotBlank = true; }
        field(2; "Version.COL.US"; Integer) { DataClassification = SystemMetadata; Caption = 'Version'; }
        field(3; "Name.COL.US"; Text[100]) { DataClassification = SystemMetadata; Caption = 'Name'; }
        field(4; "Desc.COL.US"; Text[250]) { DataClassification = SystemMetadata; Caption = 'Description'; }
        field(7; "Image Name.COL.US"; Text[100]) { DataClassification = SystemMetadata; Caption = 'Image Filename'; ObsoleteState = Removed; }
        field(5; "Topci Count.COL.US"; integer) { Caption = 'Topics'; FieldClass = FlowField; CalcFormula = count("Topics.COL.US" where("Group Code.COL.US" = field("Code.COL.US"), "Group Version.COL.US" = field("Version.COL.US"), "Type.COL.US" = const(Learning))); Editable = false; }
        field(6; "Time.COL.US"; Integer) { Caption = 'Topic Time'; FieldClass = FlowField; CalcFormula = sum("Sub Topics.COL.US"."Time.COL.US" where("Group Code.COL.US" = field("Code.COL.US"), "Group Version.COL.US" = field("Version.COL.US"), "Topic Type.COL.US" = const(Learning))); Editable = false; }
        field(8; "Media.COL.US"; Blob) { DataClassification = SystemMetadata; Caption = 'Image'; Subtype = Bitmap; }
    }

    keys
    {
        key(PKey; "Code.COL.US", "Version.COL.US") { Clustered = true; }
    }

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    var
        topic: Record "Topics.COL.US";
    begin
        topic.SetRange("Group Code.COL.US", "Code.COL.US");
        topic.SetRange("Group Version.COL.US", "Version.COL.US");
        if not topic.IsEmpty then
            topic.DeleteAll(true);
    end;

    trigger OnRename()
    begin

    end;

}