namespace db;

using { cuid } from '@sap/cds/common';

type Reusable {
    value   : String        @title : 'Value';
    name    : String        @title : 'Name';
}

entity Test : cuid {
    test    : Reusable      @title : 'Test';
}

@cds.odata.valuelist
@cds.autoexpose
@readonly
entity Values {
    key ID      : String    @title : 'Value';
        text    : String    @title : 'Name';
}
