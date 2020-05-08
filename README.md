# ObjectInspector

The `ObjectInspector` microframework provides a quick way to add a debug interface to an app. You simply create and present an `ObjectInspectorViewController`. This shows a table view that inspects the object, array, or dictionary that you pass in. Each row of the table corresponds to a field, array element, or dictionary key-value pair. Selecting a row recurses into the selected item.

Creating and showing an `ObjectInspectorViewController` is as simple as calling:

```swift
class YourViewController: UIViewController {

    // ...
    present(ObjectInspectorViewController.inspecting(object: objectToInspect), animated: true)
```

You can provide an object implementing the `ObjectInspectorViewControllerDelegate` protocol to customize the presented object inspectors.

See `Examples/ObjectInspectorExample` for an example of it in use.

