table 60005 "Menu.COL.US"
{
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "ID.COL.US"; Integer) { DataClassification = SystemMetadata; }
        field(2; "Parent.COL.US"; Integer) { DataClassification = SystemMetadata; Caption = 'Parent'; }
        field(3; "Name.COL.US"; Text[100]) { DataClassification = SystemMetadata; Caption = 'Name'; }
        field(4; "URL.COL.US"; Text[250]) { DataClassification = SystemMetadata; }
    }

    keys
    {
        key(PKey; "ID.COL.US") { Clustered = true; }
    }
}