/*
 * Copyright 2008-2011 Nokia Siemens Networks Oyj
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.robotframework.swing.keyword.tree;

import org.junit.Assert;
import org.netbeans.jemmy.operators.JPopupMenuOperator;
import org.robotframework.javalib.annotation.ArgumentNames;
import org.robotframework.javalib.annotation.RobotKeyword;
import org.robotframework.javalib.annotation.RobotKeywords;
import org.robotframework.swing.comparator.EqualsStringComparator;
import org.robotframework.swing.tree.TreeSupport;
import org.robotframework.swing.util.SwingWaiter;

@RobotKeywords
public class TreeNodePopupKeywords extends TreeSupport {
    @RobotKeyword("Selects an item from the tree node's popup menu.\n\n"
        + "Example:\n"
        + "| `Select From Tree Node Popup Menu` | myTree | Root|Folder | New Folder | ")
    @ArgumentNames({"identifier", "nodeIdentifier", "menuPath"})
    public void selectFromTreeNodePopupMenu(String identifier, String nodeIdentifier, String menuPath) {
        JPopupMenuOperator popupOperator = treeOperator(identifier).createPopupOperator(nodeIdentifier);
        popupOperator.pushMenu(menuPath, new EqualsStringComparator());
    }

    @RobotKeyword("Selects an item from the tree node's popup menu and does not wait for a result.\n"
        + "Needed if the action starts a process that stays running (e.g. opens a dialog) and the above keyword doesn't return.\n"
        + "Separator for items is ``|``.\n\n"
        + "Example:\n"
        + "| `Select From Tree Node Popup Menu In Separate Thread` | myTree | Root|Folder | New Folder | ")
    @ArgumentNames({"identifier", "nodeIdentifier", "menuPath"})
    public void selectFromTreeNodePopupMenuInSeparateThread(String identifier, String nodeIdentifier, String menuPath) {
        JPopupMenuOperator popupOperator = treeOperator(identifier).createPopupOperator(nodeIdentifier);
        popupOperator.pushMenuNoBlock(menuPath, new EqualsStringComparator());
    }

    @RobotKeyword("Invokes a menu action on all the selected tree nodes.\n"
    	+ "If ``checkItemIsEnabled`` is set to False, it does not wait for a result, "
        + "so even if the menu item is disabled, the keyword does not fail .\n "
        + "By default `checkItemIsEnabled` is True. \n"
        + "Separator for items is ``|``.\n\n"
        + "Examples:\n"
        + "| `Select Tree Node` | myTree | Root|Folder1 | true |\n"
        + "| `Select Tree Node` | myTree | Root|Folder2 |\n"
        + "| `Select From Popup Menu On Selected Tree Nodes` | myTree | Remove | ")
    @ArgumentNames({"identifier", "menuPath", "checkItemIsEnabled=True"})
    public void selectFromPopupMenuOnSelectedTreeNodes(String identifier, String menuPath, Boolean checkItemIsEnabled) {
        JPopupMenuOperator popupOperator = treeOperator(identifier).createPopupOperatorOnSelectedNodes();
        if (checkItemIsEnabled == Boolean.TRUE) {
            popupOperator.pushMenu(menuPath, new EqualsStringComparator());
        } else {
            popupOperator.pushMenuNoBlock(menuPath, new EqualsStringComparator());
            SwingWaiter.waitToAvoidInstability(300);
        }
    }

    @RobotKeyword("Fails if given popup menu item is disabled.\n\n"
        + "Examples:\n"
        + "| `Tree Node Popup Menu Item Should Be Enabled` | myTree | Root|Folder | New Folder |\n"
        + "| `Tree Node Popup Menu Item Should Be Enabled` | 0 | 1 | New Folder |\n")
    @ArgumentNames({"identifier", "nodeIdentifier", "menuPath"})
    public void treeNodePopupMenuItemShouldBeEnabled(String identifier, String nodeIdentifier, String menuPath) {
        isEnabledOrDisabled(identifier, menuPath, nodeIdentifier, true);
    }

    @RobotKeyword("Fails if given nodes popup menu item is disabled.\n\n"
            + "Examples:\n"
            + "| `Tree Nodes Popup Menu Item Should Be Enabled` | myTree | New Folder |\n"
            + "| `Tree Nodes Popup Menu Item Should Be Enabled` | 0 | New Folder |\n")
    @ArgumentNames({"identifier", "menuPath"})
    public void treeNodesPopupMenuItemShouldBeEnabled(String identifier, String menuPath) {
        isEnabledOrDisabled(identifier, menuPath, null, true);
    }

    @RobotKeyword("Fails if given nodes popup menu item is enabled.\n\n"
            + "Examples:\n"
            + "| `Tree Nodes Popup Menu Item Should Be Disabled` | myTree | New Folder |\n"
            + "| `Tree Nodes Popup Menu Item Should Be Disabled` | 0 | New Folder |\n")
    @ArgumentNames({"identifier", "menuPath"})
    public void treeNodesPopupMenuItemShouldBeDisabled(String identifier, String menuPath) {
        isEnabledOrDisabled(identifier, menuPath, null, false);
    }

    @RobotKeyword("Fails if given popup menu item is enabled.\n\n"
            + "Examples:\n"
            + "| `Tree Node Popup Menu Item Should Be Disabled` | myTree | Root|Folder | New Folder |\n"
            + "| `Tree Node Popup Menu Item Should Be Disabled` | 0      | 1 | New Folder |\n")
    @ArgumentNames({"identifier", "nodeIdentifier", "menuPath"})
    public void treeNodePopupMenuItemShouldBeDisabled(String identifier, String nodeIdentifier, String menuPath) {
        isEnabledOrDisabled(identifier, menuPath, nodeIdentifier, false);
    }

    private void isEnabledOrDisabled(String identifier, String menuPath, String nodeIdentifier, boolean isEnabled) {
        JPopupMenuOperator popupOperator;
        if (nodeIdentifier != null) {
            popupOperator = treeOperator(identifier).createPopupOperator(nodeIdentifier);
        } else {
            popupOperator = treeOperator(identifier).createPopupOperatorOnSelectedNodes();
        }
        popupOperator.setComparator(new EqualsStringComparator());
        boolean menuItemIsEnabled = popupOperator.showMenuItem(menuPath).isEnabled();
        if (isEnabled) {
            Assert.assertTrue("Menu item '" + menuPath + "' was disabled", menuItemIsEnabled);
        } else {
            Assert.assertFalse("Menu item '" + menuPath + "' was enabled", menuItemIsEnabled);
        }
        popupOperator.setVisible(false);
    }
}
