namespace app;

using { db } from '../db/schema';

annotate db.Reusable with {
    @Common : {
        Text : (value.text),    // #1.1: does not work in Fiori (text not displayed, there is no corresponding annotation to be found in the metadata document)
        // Text : value.text,      // #1.2: does not work in Fiori (field not displayed in object page; Error while processing building block)
        // Text : test_value.text, // #1.3: works in fiori, but gets reported as error by CDS language support
        TextArrangement : #TextFirst,
        ValueListWithFixedValues,
        ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'Values',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : value_ID,       // #2.1: does not work in fiori; browser error when selecting an entry in edit mode: Uncaught Error: KeyPath missing
                    // LocalDataProperty : test_value_ID,  // #2.2: works in fiori but gets reported as error in CDS language support; also depends on entity's property name
                    // LocalDataProperty : (value_ID),     // #2.3: [ERROR] app/annotations.cds:16:42-50: Element “value_ID” has not been found (in type:“db.Reusable”/element:“value”/“@Common.ValueList.Parameters”)
                    ValueListProperty : 'ID',
                },
            ],
        },
    }
    value;
}

// #2.4: auto-generated value mapping; only works for a single key field
// annotate db.Values with @cds.odata.valuelist;

// make sure the text is shown in the dropdown list
annotate db.Values with {
    @Common : {
        Text : text,
        TextArrangement : #TextFirst,
    }
    ID;
}

annotate db.Test @(
    UI : {
        LineItem  : [
            {
                $Type : 'UI.DataField',
                Value : test_value_ID,
            },
        ],
        FieldGroup #Values : {
            $Type : 'UI.FieldGroupType',
            Data : [
                {
                    $Type : 'UI.DataField',
                    Value : test_value_ID,
                },
            ],
        },
        Facets  : [
            {
                $Type : 'UI.ReferenceFacet',
                Target : '@UI.FieldGroup#Values',
                Label : 'Values',
            },
        ],
    },
);
