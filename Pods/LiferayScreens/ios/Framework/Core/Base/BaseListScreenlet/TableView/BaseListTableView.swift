/**
* Copyright (c) 2000-present Liferay, Inc. All rights reserved.
*
* This library is free software; you can redistribute it and/or modify it under
* the terms of the GNU Lesser General Public License as published by the Free
* Software Foundation; either version 2.1 of the License, or (at your option)
* any later version.
*
* This library is distributed in the hope that it will be useful, but WITHOUT
* ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
* FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
* details.
*/
import UIKit

#if LIFERAY_SCREENS_FRAMEWORK
	import ODRefreshControl
#endif


public class BaseListTableView: BaseListView, UITableViewDataSource, UITableViewDelegate {

	@IBOutlet public var tableView: UITableView?

	internal var refreshControlView: ODRefreshControl?

	internal var refreshClosure: (Void -> Bool)? {
		didSet {
			updateRefreshControl()
		}
	}

	override public var progressMessages: [String:ProgressMessages] {
		return [
			BaseListScreenlet.LoadInitialPageAction : [
				.Working : LocalizedString("core", key: "base-list-loading-message", obj: self),
				.Failure : LocalizedString("core", key: "base-list-loading-error", obj: self)
			]
		]
	}


	// MARK: BaseListView

	public override func onCreated() {
		super.onCreated()

		tableView?.delegate = self
		tableView?.dataSource = self

		doRegisterCellNibs()
	}

	override public func onChangedRows(oldRows: [AnyObject?]) {
		super.onChangedRows(oldRows)

		if self.rows.isEmpty {
			clearAllRows(oldRows)
		}
		else if oldRows.isEmpty {
			insertFreshRows()
		}
		else if let visibleRows = tableView!.indexPathsForVisibleRows {
			updateVisibleRows(visibleRows)
		}
		else {
			tableView!.reloadData()
		}
	}

	override public func onFinishInteraction(result: AnyObject?, error: NSError?) {
		if let currentRefreshControl = refreshControlView {
			dispatch_delayed(0.3) {
				currentRefreshControl.endRefreshing()
			}
		}
	}


	//MARK: UITableViewDataSource

	public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return rowCount
	}

	public func tableView(tableView: UITableView,
			cellForRowAtIndexPath
			indexPath: NSIndexPath)
			-> UITableViewCell {

		let object: AnyObject? = rows[indexPath.row]

		let cell = doDequeueReusableCell(row: indexPath.row, object: object)

		if let object = object {
			doFillLoadedCell(row: indexPath.row, cell: cell, object: object)
		}
		else {
			doFillInProgressCell(row: indexPath.row, cell: cell)

			fetchPageForRow?(indexPath.row)
		}

		return cell
	}

	public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: false)

		if let row:AnyObject = rows[indexPath.row] {
			onSelectedRowClosure?(row)
		}
	}

	public func doDequeueReusableCell(row row: Int, object: AnyObject?) -> UITableViewCell {
		let cellId = doGetCellId(row: row, object: object)

		guard let result = tableView!.dequeueReusableCellWithIdentifier(cellId) else {
			return doCreateCell(cellId)
		}

		return result
	}

	public func doFillLoadedCell(row row: Int, cell: UITableViewCell, object:AnyObject) {
	}

	public func doFillInProgressCell(row row: Int, cell: UITableViewCell) {
	}

	public func doRegisterCellNibs() {
	}

	public func doGetCellId(row row: Int, object: AnyObject?) -> String {
		return "defaultCellId"
	}

	public func doCreateCell(cellId: String) -> UITableViewCell {
		return UITableViewCell(style: .Default, reuseIdentifier: cellId)
	}


	//MARK: Internal methods

	internal func updateRefreshControl() {
		if refreshClosure != nil {
			if refreshControlView == nil {
				refreshControlView = ODRefreshControl(
						inScrollView: self.tableView)
				refreshControlView!.addTarget(self,
						action: #selector(BaseListTableView.refreshControlBeginRefresh(_:)),
						forControlEvents: .ValueChanged)
			}
		}
		else if let currentControl = refreshControlView {
			currentControl.endRefreshing()
			currentControl.removeFromSuperview()
			refreshControlView = nil
		}
	}

	internal func refreshControlBeginRefresh(sender:AnyObject?) {
		dispatch_delayed(0.3) {
			self.refreshClosure?()
		}
	}

	internal func insertFreshRows() {
		let indexPaths = (0..<self.rows.count).map {
			NSIndexPath(forRow: $0, inSection: 0)
		}

		tableView!.insertRowsAtIndexPaths(indexPaths, withRowAnimation:.Top)
	}

	internal func clearAllRows(currentRows: [AnyObject?]) {
		tableView!.beginUpdates()

		for (index,_) in currentRows.enumerate() {
			let indexPath = NSIndexPath(forRow:index, inSection:0)
			tableView!.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
		}

		tableView!.endUpdates()
	}

	internal func updateVisibleRows(visibleRows: [NSIndexPath]) {
		if visibleRows.count > 0 {
			tableView!.reloadRowsAtIndexPaths(visibleRows, withRowAnimation:.None)
		}
		else {
			tableView!.reloadData()
		}
	}

}
