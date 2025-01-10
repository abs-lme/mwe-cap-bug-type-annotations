namespace db;

using { cuid } from '@sap/cds/common';

type Reusable {
    value   : Association to one Values @title : 'Value';
}

@fiori.draft.enabled
entity Test : cuid {
    test    : Reusable      @title : 'Test';
}

@cds.autoexpose
@readonly
entity Values {
    key ID      : String    @title : 'Value';
        text    : String    @title : 'Name';
}
