//
//  ObjectInspectorViewController.swift
//  ObjectInspector
//
//  Copyright (c) 2020 Rocket Insights, Inc.
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
//  DEALINGS IN THE SOFTWARE.
//

import UIKit

@objc
public protocol ObjectInspectorViewControllerDelegate: AnyObject {

    @objc optional func objectInspector(_ sender: ObjectInspectorViewController, customViewControllerForObject object: Any) -> UIViewController?

    @objc optional func objectInspector(_ sender: ObjectInspectorViewController, customViewControllerForDictionary dictionary: [AnyHashable: Any]) -> UIViewController?

    @objc optional func objectInspector(_ sender: ObjectInspectorViewController, customViewControllerForArray array: [Any]) -> UIViewController?

    @objc optional func objectInspector(_ sender: ObjectInspectorViewController, customDescriptionForObject object: Any) -> String?
}

public class ObjectInspectorViewController: UITableViewController {

    // MARK: - Initialization

    public static func inspecting(array: [Any], title: String = "Root", delegate: ObjectInspectorViewControllerDelegate? = nil) -> UINavigationController {
        return UINavigationController(rootViewController: ObjectInspectorViewController(array: array, title: title, delegate: delegate))
    }

    public static func inspecting(dictionary: [AnyHashable: Any], title: String = "Root", delegate: ObjectInspectorViewControllerDelegate? = nil) -> UINavigationController {
        return UINavigationController(rootViewController: ObjectInspectorViewController(dictionary: dictionary, title: title, delegate: delegate))
    }

    public static func inspecting(object: Any, title: String = "Root", delegate: ObjectInspectorViewControllerDelegate? = nil) -> UINavigationController {
        return UINavigationController(rootViewController: ObjectInspectorViewController(object: object, title: title, delegate: delegate))
    }

    public convenience init(array: [Any], title: String, delegate: ObjectInspectorViewControllerDelegate? = nil) {
        self.init(model: createModel(array: array), title: title, delegate: delegate)
    }

    public convenience init(dictionary: [AnyHashable: Any], title: String, delegate: ObjectInspectorViewControllerDelegate? = nil) {
        self.init(model: createModel(dictionary: dictionary), title: title, delegate: delegate)
    }

    public convenience init(object: Any, title: String, delegate: ObjectInspectorViewControllerDelegate? = nil) {
        self.init(model: createModel(object: object), title: title, delegate: delegate)
    }

    init(model: Model, title: String, delegate: ObjectInspectorViewControllerDelegate? = nil) {
        self.model = model
        self.delegate = delegate

        super.init(style: .plain)
        self.title = title
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    // MARK: - Properties

    public weak var delegate: ObjectInspectorViewControllerDelegate?

    private let model: Model

    // MARK: - Table view delegate and data source

    public override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.propertyNames.count
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let name = model.propertyNames[indexPath.row]
        let value = model.value(at: indexPath.row)

        let reuseIdentifier = "cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) ??
            UITableViewCell(style: .subtitle, reuseIdentifier: reuseIdentifier)

        cell.textLabel?.text = name
        cell.detailTextLabel?.text = value.flatMap {
            delegate?.objectInspector?(self, customDescriptionForObject: $0.rawValue) ?? $0.description
        } ?? "(nil)"

        let isLeaf = value?.isLeaf ?? true
        cell.accessoryType = isLeaf ? .none : .disclosureIndicator

        return cell
    }

    public override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let value = model.value(at: indexPath.row)
        let isLeaf = value?.isLeaf ?? true

        return isLeaf ? nil : indexPath
    }

    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = model.propertyNames[indexPath.row]
        guard let value = model.value(at: indexPath.row) else {
            return
        }

        let model: Model
        var vc: UIViewController? = nil

        switch value {
        case .array(let array):
            vc = delegate?.objectInspector?(self, customViewControllerForArray: array)
            model = createModel(array: array)

        case .dictionary(let dict):
            vc = delegate?.objectInspector?(self, customViewControllerForDictionary: dict)
            model = createModel(dictionary: dict)

        case .object(let obj):
            vc = delegate?.objectInspector?(self, customViewControllerForObject: obj)
            model = createModel(object: obj)

        case .scalar:
            return
        }

        navigationController?.pushViewController(vc ?? ObjectInspectorViewController(model: model, title: name, delegate: delegate),
                                                 animated: true)
    }
}
