namespace db;

using { cuid } from '@sap/cds/common';

type Reusable {
    value   : String        @title : 'Value';
    name    : String        @title : 'Name';
}

entity Test : cuid {
    test    : Reusable      @title : 'Test';
}
