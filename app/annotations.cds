namespace app;

using { db } from '../db/schema';

annotate db.Reusable with {
    @Common : {
        Text : name, // does not work in fiori
        // Text : test_name, // works in fiori but gets reported as error by CDS. also this should not be the correct way as it depends on how this type is named in the entity
        TextArrangement : #TextFirst,
    }
    value;
}

annotate db.Test @(
    UI : {
        LineItem  : [
            {
                $Type : 'UI.DataField',
                Value : test_value,
            },
        ],
    },
);
