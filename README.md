# MWE: Annotations for reusable types

This MWE demonstrates a bug that occurs with reusable types.

## Demo app description

There is a single entity `Test` that contains a field `test` of type `Reusable`.

`Reusable` is a structured type with two properties `value` and `name`.
The property `name` is configured to be the text for the property `value` (using `Common.Text`).

```cds
type Reusable {
    value   : String        @title : 'Value';
    name    : String        @title : 'Name';
}

entity Test : cuid {
    test    : Reusable      @title : 'Test';
}
```

There are a few Fiori annotations for a List Report for the `Test` entity.

## Reproducing the issue

1. Run the app with `cds watch`
2. Open the Fiori app at http://localhost:4004/$fiori-preview/srv.TestService/Test#preview-app
3. The app crashes immediately due to Fiori Elements trying to read a non-existent path.

## Further analysis

Any annotations targeting the `Reusable` type are not correctly prefixed with the property name.

### Example 1

This CDS annotation...

```cds
annotate db.Reusable with {
    @Common : {
        Text : name,
        TextArrangement : #TextFirst,
    }
    value;
}
```

...produces this annotation in the metadata:

```xml
<Annotations Target="srv.TestService.Test/test_value">
    <Annotation Term="Common.Text" Path="name"> <!-- name (which does not exist in entity Test) -->
        <Annotation Term="UI.TextArrangement" EnumMember="UI.TextArrangementType/TextFirst"/>
    </Annotation>
    <Annotation Term="Common.Label" String="Value"/>
</Annotations>
```

The `Path` attribute in line 2 should be `test_name` instead of `name` in order for Fiori to correctly display the name. The annotation above makes fiori try to read the path `name` which does not exist, causing the app to crash.

### Example 2

This CDS annotation...

```cds
annotate db.Reusable with {
    @Common : {
        Text : test_name,
        TextArrangement : #TextFirst,
    }
    value;
}
```

...produces the expected annotation in the metadata:

```xml
<Annotations Target="srv.TestService.Test/test_value">
    <Annotation Term="Common.Text" Path="test_name"> <!-- test_name, correctly prefixed -->
        <Annotation Term="UI.TextArrangement" EnumMember="UI.TextArrangementType/TextFirst"/>
    </Annotation>
    <Annotation Term="Common.Label" String="Value"/>
</Annotations>
```

However, this makes the `Reusable` annotations depend on how the type is used (how the property is named) and thus not usable any more; also it gets reported as error by CDS language support.
I would have to copy this annotation for any usage of the reuse type, annotation the corresponding properties instead of the reuse type itself.

## Expected behavior

The annotation should be prefixed with the property name of the structured type. The annotation targets the entity property already, so it would be possible to prefix the referencing paths.

This CDS annotation...

```cds
annotate db.Reusable with {
    @Common : {
        Text : name,
        TextArrangement : #TextFirst,
    }
    value;
}
```

...should produce this annotation in the metadata:

```xml
<Annotations Target="srv.TestService.Test/test_value">
    <Annotation Term="Common.Text" Path="test_name"> <!-- test_name, correctly prefixed -->
        <Annotation Term="UI.TextArrangement" EnumMember="UI.TextArrangementType/TextFirst"/>
    </Annotation>
    <Annotation Term="Common.Label" String="Value"/>
</Annotations>
```
