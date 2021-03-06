*** Settings ***
Suite Setup     setTimeoutsAndDelays
Library         Collections
Library         TestSwingLibrary

*** Variables ***
${delay}  0
${treeName}  testTree
${nodeIndex}  2
${rootNode}  the java series
${childNode1}  books for java programmers
${childNode2}  books for java implementers
${leafNode}  the java tutorial: a short course on the basics
${leafNode2}  the java tutorial continued: the rest of the jdk
${anotherNodePath}  ${rootNode}|${childNode1}
${leafNodePath}  ${anotherNodePath}|${leafNode}
${insertChildMenuEntry}  Insert a child
${childCount}  6

*** Test Cases ***
Expand Node by Index
    expandTreeNode  ${treeName}  0
    expandTreeNode  ${treeName}  ${nodeIndex}
    treeNodeShouldBeExpanded  ${treeName}  ${nodeIndex}
    collapseTreeNode  ${treeName}  ${nodeIndex}
    collapseTreeNode  ${treeName}  0

Expand Node By Name
    expandTreeNode  ${treeName}  ${rootNode}
    expandTreeNode  ${treeName}  ${anotherNodePath}
    treeNodeShouldBeExpanded  ${treeName}  ${anotherNodePath}
    collapseTreeNode  ${treeName}  ${anotherNodePath}
    collapseTreeNode  ${treeName}  ${rootNode}

Expand Node By Name With Jemmy Timeout
    expandTreeNode  ${treeName}  ${rootNode}
    expandTreeNode  ${treeName}  ${anotherNodePath}
    treeNodeShouldBeExpanded  ${treeName}  ${anotherNodePath}  4
    collapseTreeNode  ${treeName}  ${anotherNodePath}
    collapseTreeNode  ${treeName}  ${rootNode}

Collapse Node By Index
    expandTreeNode  ${treeName}  0
    expandTreeNode  ${treeName}  ${nodeIndex}
    treeNodeShouldBeExpanded  ${treeName}  ${nodeIndex}
    collapseTreeNode  ${treeName}  ${nodeIndex}
    treeNodeShouldBeCollapsed  ${treeName}  ${nodeIndex}
    collapseTreeNode  ${treeName}  ${nodeIndex}
    collapseTreeNode  ${treeName}  0

Collapse Node By Index With Jemmy Timeout
    expandTreeNode  ${treeName}  0
    expandTreeNode  ${treeName}  ${nodeIndex}
    treeNodeShouldBeExpanded  ${treeName}  ${nodeIndex}  4
    collapseTreeNode  ${treeName}  ${nodeIndex}
    treeNodeShouldBeCollapsed  ${treeName}  ${nodeIndex}  4
    collapseTreeNode  ${treeName}  ${nodeIndex}
    collapseTreeNode  ${treeName}  0

Collapse Node By Name
    expandTreeNode  ${treeName}  ${rootNode}
    treeNodeShouldBeExpanded  ${treeName}  ${rootNode}
    collapseTreeNode  ${treeName}  ${rootNode}
    treeNodeShouldBeCollapsed  ${treeName}  ${rootNode}
    collapseTreeNode  ${treeName}  ${rootNode}

Collapse Node By Name With Duplicated Node Instance
    expandTreeNode  ${treeName}  ${rootNode}
    expandTreeNode  ${treeName}  ${childNode1}  \#0
    treeNodeShouldBeExpanded  ${treeName}  ${childNode1}  \#0
    collapseTreeNode  ${treeName}  ${childNode1}  \#0

Tree Node Should Be Collapsed
    collapseTreeNode  ${treeName}  ${rootNode}
    treeNodeShouldBeCollapsed  ${treeName}  0
    treeNodeShouldBeCollapsed  ${treeName}  ${rootNode}

Tree Node Should Be Expanded
    expandTreeNode  ${treeName}  ${rootNode}
    treeNodeShouldBeExpanded  ${treeName}  0
    treeNodeShouldBeExpanded  ${treeName}  ${rootNode}

Tree Node Should Be Expanded With Jemmy Timeout
    expandTreeNode  ${treeName}  ${rootNode}
    treeNodeShouldBeExpanded  ${treeName}  0  3
    treeNodeShouldBeExpanded  ${treeName}  ${rootNode}  3

Select Tree Node By Index
    clearTreeSelection  ${treeName}
    selectTreeNode  ${treeName}  0
    treeNodeShouldBeSelected  ${treeName}  0
    unselectTreeNode  ${treeName}  0

Select Tree Node By Name
    clearTreeSelection  ${treeName}
    selectTreeNode  ${treeName}  ${rootNode}
    treeNodeShouldBeSelected  ${treeName}  ${rootNode}
    [Teardown]  unselectTreeNode  ${treeName}  ${rootNode}

Select Tree Node By Name With Duplicate Node
    clearTreeSelection  ${treeName}
    selectTreeNode  ${treeName}  ${childNode1}  \#1
    treeNodeShouldBeSelected  ${treeName}  ${childNode1}  \#1
    Run Keyword And Expect Error  Tree node 'books for java programmers' is not selected.  treeNodeShouldBeSelected  ${treeName}  ${childNode1}  \#0
    Run Keyword And Expect Error  Tree node 'books for java programmers' is selected.  treeNodeShouldNotBeSelected  ${treeName}  ${childNode1}  \#1
    [Teardown]  clearTreeSelection  ${treeName}

Select Tree Node By Path With Duplicate Nodes
    clearTreeSelection  ${treeName}
    selectTreeNode  ${treeName}  ${rootNode}|${childNode1}  \#1
    treeNodeShouldBeSelected  ${treeName}  ${childNode1}  \#1
    [Teardown]  clearTreeSelection  ${treeName}

Select Tree Node By Name With Duplicate Node And Additional Node Identifiers
    clearTreeSelection  ${treeName}
    selectTreeNode  ${treeName}  ${childNode1}  \#1  ${childNode2}
    treeNodeShouldBeSelected  ${treeName}  ${childNode1}  \#1
    treeNodeShouldNotBeSelected  ${treeName}  ${childNode1}  \#0
    treeNodeShouldBeSelected  ${treeName}  ${childNode2}  \#0
    [Teardown]  clearTreeSelection  ${treeName}

Select Tree Node By Name With Jemmy Timeout
    clearTreeSelection  ${treeName}
    selectTreeNode  ${treeName}  ${rootNode}
    treeNodeShouldBeSelected  ${treeName}  ${rootNode}  4
    [Teardown]  unselectTreeNode  ${treeName}  ${rootNode}

Select Tree Node Should Work With Nodes Other Than javax.swing.tree.TreeNode
    ${path}=  setVariable  root|node3|node5|node6
    selectTreeNode  otherTree  ${path}
    treeNodeShouldBeSelected  otherTree  ${path}

Select Tree Node Keyword Selects Multiple Nodes
    clearTreeSelection  ${treeName}
    selectTreeNode  ${treeName}  ${rootNode}|${childNode1}  ${rootNode}|${childNode2}
    treeNodeShouldBeSelected  ${treeName}  ${rootNode}|${childNode1}
    treeNodeShouldBeSelected  ${treeName}  ${rootNode}|${childNode2}

Unselect Tree Node By Index
    clearTreeSelection  ${treeName}
    selectTreeNode  ${treeName}  0
    unselectTreeNode  ${treeName}  0
    treeNodeShouldNotBeSelected  ${treeName}  0

Unselect Tree Node By Name
    clearTreeSelection  ${treeName}
    selectTreeNode  ${treeName}  ${rootNode}
    unselectTreeNode  ${treeName}  ${rootNode}
    treeNodeShouldNotBeSelected  ${treeName}  ${rootNode}

Unselect Tree Node By Name Using Node Instance
    clearTreeSelection  ${treeName}
    selectTreeNode  ${treeName}  ${childNode1}  \#1
    unselectTreeNode  ${treeName}  ${childNode1}  \#1
    treeNodeShouldNotBeSelected  ${treeName}  ${childNode1}  \#1
    selectTreeNode  ${treeName}  ${childNode1}  \#1  3
    unselectTreeNode  ${treeName}  ${childNode1}  \#1
    treeNodeShouldNotBeSelected  ${treeName}  ${childNode1}  \#1
    sleep  10s

Unselect Tree Node By Name With Jemmy Timeout
    clearTreeSelection  ${treeName}
    selectTreeNode  ${treeName}  ${rootNode}
    unselectTreeNode  ${treeName}  ${rootNode}
    treeNodeShouldNotBeSelected  ${treeName}  ${rootNode}  3

Tree Node Should Be Selected AND Tree Node Should Not Be Selected
    clearTreeSelection  ${treeName}
    treeNodeShouldNotBeSelected  ${treeName}  0
    treeNodeShouldNotBeSelected  ${treeName}  ${rootNode}
    selectTreeNode  ${treeName}  0
    treeNodeShouldBeSelected  ${treeName}  0
    treeNodeShouldBeSelected  ${treeName}  ${rootNode}

Select From Tree Node Popup Menu
    selectFromTreeNodePopupMenu  ${treeName}  ${rootNode}  ${insertChildMenuEntry}
    expandTreeNode  ${treeName}  ${rootNode}
    treeNodeShouldBeVisible  ${treeName}  ${rootNode}|child
    selectFromTreeNodePopupMenu  ${treeName}  ${rootNode}|child  Remove

Select From Tree Node Popup Menu Should Accept Only Exact Matches For Menupaths
    runKeywordAndExpectError  *  selectFromTreeNodePopupMenu  ${treeName}  ${rootNode}  Submenu|Enabled

Select From Tree Node Popup Menu Fails If Menu Item Is Disabled
    runKeywordAndExpectError  *Disabled menuitem*  selectFromTreeNodePopupMenu  ${treeName}  ${rootNode}  Disabled menuitem

Select From Tree Node Popup Menu In Separate Thread
    selectFromTreeNodePopupMenuInSeparateThread  ${treeName}  ${rootNode}  Show dialog
    dialogShouldBeOpen  Message
    closeDialog  Message

Tree Node Should Be Visible
    expandAllTreeNodes  ${treeName}
    treeNodeShouldBeVisible  ${treeName}  ${rootNode}
    treeNodeShouldBeVisible  ${treeName}  ${anotherNodePath}
    treeNodeShouldBeVisible  ${treeName}  ${leafNodePath}
    collapseTreeNode  ${treeName}  ${rootNode}
    runKeywordAndExpectError  Tree node '${anotherNodePath}' is not visible.  treeNodeShouldBeVisible  ${treeName}  ${anotherNodePath}
    runKeywordAndExpectError  Tree node '${leafNodePath}' is not visible.  treeNodeShouldBeVisible  ${treeName}  ${leafNodePath}

Tree Node Should Be Visible With Duplicated Nodes
    expandAllTreeNodes  ${treeName}
    treeNodeShouldBeVisible  ${treeName}  ${childNode1}  \#1
    treeNodeShouldBeVisible  ${treeName}  ${childNode1}  \#1  3
    treeNodeShouldBeVisible  ${treeName}  ${anotherNodePath}  \#1
    treeNodeShouldBeVisible  ${treeName}  ${anotherNodePath}  \#1  3
    collapseTreeNode  ${treeName}  ${rootNode}
    runKeywordAndExpectError  Tree node '${anotherNodePath}' is not visible.  treeNodeShouldBeVisible  ${treeName}  ${anotherNodePath}  \#1
    runKeywordAndExpectError  Tree node '${childNode1}' is not visible.  treeNodeShouldBeVisible  ${treeName}  ${childNode1}  \#1

Tree Node Should Not Be Visible
    collapseTreeNode  ${treeName}  ${rootNode}
    treeNodeShouldNotBeVisible  ${treeName}  ${anotherNodePath}
    treeNodeShouldNotBeVisible  ${treeName}  ${leafNodePath}
    expandAllTreeNodes  ${treeName}
    runKeywordAndExpectError  Tree node '${anotherNodePath}' is visible.  treeNodeShouldNotBeVisible  ${treeName}  ${anotherNodePath}
    runKeywordAndExpectError  Tree node '${leafNodePath}' is visible.  treeNodeShouldNotBeVisible  ${treeName}  ${leafNodePath}

Tree Node Should Not Be Visible With Duplicated Nodes
    collapseTreeNode  ${treeName}  ${rootNode}
    treeNodeShouldNotBeVisible  ${treeName}  ${childNode1}  \#1
    treeNodeShouldNotBeVisible  ${treeName}  ${childNode1}  \#1  3
    treeNodeShouldNotBeVisible  ${treeName}  ${anotherNodePath}  \#1
    treeNodeShouldNotBeVisible  ${treeName}  ${anotherNodePath}  \#1  3
    expandAllTreeNodes  ${treeName}
    runKeywordAndExpectError  Tree node '${anotherNodePath}' is visible.  treeNodeShouldNotBeVisible  ${treeName}  ${anotherNodePath}  \#1
    runKeywordAndExpectError  Tree node '${childNode1}' is visible.  treeNodeShouldNotBeVisible  ${treeName}  ${childNode1}  \#1

Tree Node Should Be Visible With Jemmy Timeout
    expandAllTreeNodes  ${treeName}
    treeNodeShouldBeVisible  ${treeName}  ${rootNode}  6000 ms
    treeNodeShouldBeVisible  ${treeName}  ${anotherNodePath}
    treeNodeShouldBeVisible  ${treeName}  ${leafNodePath}
    collapseTreeNode  ${treeName}  ${rootNode}
    runKeywordAndExpectError  Tree node '${anotherNodePath}' is not visible.  treeNodeShouldBeVisible  ${treeName}  ${anotherNodePath}
    runKeywordAndExpectError  Tree node '${leafNodePath}' is not visible.  treeNodeShouldBeVisible  ${treeName}  ${leafNodePath}

Tree Node Should Be Leaf AND Tree Node Should Not Be Leaf
    expandTreeNode  ${treeName}  ${rootNode}
    expandTreeNode  ${treeName}  ${anotherNodePath}
    treeNodeShouldBeLeaf  ${treeName}  ${leafNodePath}
    treeNodeShouldNotBeLeaf  ${treeName}  ${anotherNodePath}
    collapseTreeNode  ${treeName}  ${rootNode}
    treeNodeShouldNotBeLeaf  ${treeName}  ${rootNode}

Tree Node Should Be/Should Not Be Leaf With Duplicated Node Instance
    expandTreeNode  ${treeName}  ${rootNode}
    treeNodeShouldBeLeaf  ${treeName}  ${childNode1}  \#1
    treeNodeShouldNotBeLeaf  ${treeName}  ${anotherNodePath}  \#0

Tree Node Should Exist By Name
    treeNodeShouldExist  ${treeName}  ${rootNode}
    treeNodeShouldExist  ${treeName}  ${anotherNodePath}
    treeNodeShouldExist  ${treeName}  ${leafNodePath}

Tree Node Should Exist By Index
    treeNodeShouldExist  ${treeName}  0

Tree Node Should Not Exist By Name
    treeNodeShouldNotExist  ${treeName}  Unexisting|node|name
    treeNodeShouldNotExist  ${treeName}  Unexisting_root_node_name

Tree Node Should Not Exist By Index
    treeNodeShouldNotExist  ${treeName}  9999

Test Selecting Multiple Nodes
    expandTreeNode  ${treeName}  ${rootNode}
    clearTreeSelection  ${treeName}
    selectTreeNode  ${treeName}  ${rootNode}
    selectTreeNode  ${treeName}  ${anotherNodePath}
    treeNodeShouldBeSelected  ${treeName}  ${rootNode}
    treeNodeShouldBeSelected  ${treeName}  ${anotherNodePath}
    collapseTreeNode  ${treeName}  ${rootNode}
    clearTreeSelection  ${treeName}

Tree Node Popup Menu Item Should Be Enabled
    [Tags]  display-required
    treeNodePopupMenuItemShouldBeEnabled  ${treeName}  ${rootNode}  ${insertChildMenuEntry}
    treeNodePopupMenuItemShouldBeEnabled  ${treeName}  ${rootNode}  Submenu|Enabled menuitem
    popupMenuShouldNotBeDisplayed

Tree Node Popup Menu Item Should Be Disabled
    [Tags]  display-required
    treeNodePopupMenuItemShouldBeDisabled  ${treeName}  ${rootNode}  Disabled menuitem
    treeNodePopupMenuItemShouldBeDisabled  ${treeName}  ${rootNode}  Submenu|Disabled menuitem
    popupMenuShouldNotBeDisplayed

Tree Nodes Popup Menu Items Should Be Disabled
    [Tags]  display-required
    clearSavedNodes
    selectNodes
    treeNodesPopupMenuItemShouldBeDisabled  ${treeName}  Disabled menuitem
    popupMenuShouldNotBeDisplayed

Tree Nodes Popup Menu Items Should Be Enabled
    [Tags]  display-required
    clearSavedNodes
    selectNodes
    treeNodesPopupMenuItemShouldBeEnabled  ${treeName}  Submenu|Enabled menuitem
    popupMenuShouldNotBeDisplayed

Tree Node Popup Menu Item Should Be Disabled Should Fail If Menu Item Is Enabled
    [Tags]  display-required
    runKeywordAndExpectError  *Menu item '${insertChildMenuEntry}' was enabled*  treeNodePopupMenuItemShouldBeDisabled  ${treeName}  ${rootNode}  ${insertChildMenuEntry}

Tree Node Popup Menu Item Should Be Enabled Should Fail If Menu Item Is Disabled
    [Tags]  display-required
    runKeywordAndExpectError  *Menu item 'Disabled menuitem' was disabled*  treeNodePopupMenuItemShouldBeEnabled  ${treeName}  ${rootNode}  Disabled menuitem

Get Tree Node Count Returns The Count Of All Visible Nodes
    [Setup]  resetNodes
    ${visibleNodes}=  getTreeNodeCount  ${treeName}
    shouldBeEqualAsIntegers  4  ${visibleNodes}
    expandTreeNode  ${treeName}  ${rootNode}|${childNode1}
    ${visibleNodes}=  getTreeNodeCount  ${treeName}
    shouldBeEqualAsIntegers  7  ${visibleNodes}
    collapseTreeNode  ${treeName}  ${rootNode}|${childNode1}
    ${visibleNodes}=  getTreeNodeCount  ${treeName}
    shouldBeEqualAsIntegers  4  ${visibleNodes}
    hideRootNode
    ${visibleNodes}=  getTreeNodeCount  ${treeName}
    shouldBeEqualAsIntegers  3  ${visibleNodes}

Get Node Items From Tree Popup Menu
    [Setup]  resetNodes
    ${popupMenuItems}=  getNodeItemsFromTreePopupMenu  ${treeName}  ${leafNodePath}  Submenu
    ${expectedMenuItems}=  createList  Disabled menuitem  Enabled menuitem
    listsShouldBeEqual  ${expectedMenuItems}  ${popupMenuItems}

Get Tree Node Child Names
    [Setup]  resetNodes
    ${expectedChildnames}=  createList  ${childNode1}  ${childNode2}  ${childNode1}
    ${childNames}=  getTreeNodeChildNames  ${treeName}  ${rootNode}
    listsShouldBeEqual  ${expectedChildnames}  ${childNames}

Select From Popup Menu On Selected Tree Nodes Keyword Operates On All Selected Nodes
    [Setup]  resetNodes
    selectFromPopupMenuOnSelectedTreeNodesKeywordOperatesOnAllSelectedNodes

Get Tree Node Label Keyword Returns The Last Nodes Name
    [Setup]  resetNodes
    expandTreeNode  ${treeName}  ${rootNode}|${childNode1}
    ${treeNodeLabel}=  getTreeNodeLabel  ${treeName}  3
    shouldBeEqual  The Java Tutorial Continued: The Rest of the JDK  ${treeNodeLabel}

Get Tree Node Label Keyword Works With Hidden Root
    [Setup]  resetNodes
    expandTreeNode  ${treeName}  ${rootNode}|${childNode1}
    hideRootNode
    ${treeNodeLabel}=  getTreeNodeLabel  ${treeName}  2
    shouldBeEqual  The Java Tutorial Continued: The Rest of the JDK  ${treeNodeLabel}

Get Tree Node Index Keyword Returns The Node Index
    [Setup]  resetNodes
    expandTreeNode  ${treeName}  ${rootNode}|${childNode1}
    ${nodeIndex}=  getTreeNodeIndex  ${treeName}  ${rootNode}|${childNode1}|${leafNode2}
    shouldBeEqualAsIntegers  3  ${nodeIndex}

Get Tree Node Index Keyword Works With Hidden Root
    [Setup]  resetNodes
    expandTreeNode  ${treeName}  ${rootNode}|${childNode1}
    hideRootNode
    ${nodeIndex}=  getTreeNodeIndex  ${treeName}  ${childNode1}|${leafNode2}
    shouldBeEqualAsIntegers  2  ${nodeIndex}

Click On Tree Node
    resetNodes
    clearSavedNodes
    clickOnTreeNode  ${treeName}  ${rootNode}|${childNode1}|${leafNode2}  3
    clickedNodesShouldBe  ${leafNode2}
    clickCountShouldBe  3

Click On Tree Node Without Click Count
    resetNodes
    clearSavedNodes
    clickOnTreeNode  ${treeName}  ${rootNode}|${childNode1}  \#1
    clickCountShouldBe  1

Click On Tree Node With Duplicated Node Instance
    resetNodes
    clearSavedNodes
    clickOnTreeNode  ${treeName}  ${rootNode}|${childNode1}|${leafNode2}
    clickCountShouldBe  1

Click On Tree Node With Duplicated Node Instance And Click Count
    resetNodes
    clearSavedNodes
    clickOnTreeNode  ${treeName}  ${rootNode}|${childNode1}  \#1  3
    clickCountShouldBe  3
    Sleep  5s

Expand All Tree Nodes
    [Setup]  resetNodes
    expandAllTreeNodes  ${treeName}
    allTreeNodesShouldBeExpanded  ${treeName}

Expand All Tree Nodes Should Work With Invisible Root
    [Setup]  resetNodes
    hideRootNode
    expandAllTreeNodes  ${treeName}
    allTreeNodesShouldBeExpanded  ${treeName}

Collapse All Tree Nodes
    [Setup]  resetNodes
    collapseAllTreeNodes  ${treeName}
    allTreeNodesShouldBeCollapsed  ${treeName}

Keywords Also Work With Unnamed Root
    resetNodes
    selectFromTreeNodePopupMenu  0  ${rootNode}  Remove root name
    clearSavedNodes
    clickOnTreeNode  ${treeName}  |${childNode1}|${leafNode2}  3
    clickedNodesShouldBe  ${leafNode2}
    clickCountShouldBe  3
    selectFromTreeNodePopupMenu  0  ${EMPTY}  Restore root name

Keywords Also Work With Invisible Root
    [Setup]  resetNodes
    hideRootNode
    treeNodeShouldBeVisible  ${treeName}  ${childNode2}
    treeNodeShouldBeVisible  ${treeName}  ${childNode1}
    treeNodeShouldExist  ${treeName}  ${childNode2}
    treeNodeShouldExist  ${treeName}  ${childNode1}
    treeNodeShouldExist  ${treeName}  ${childNode1}|${leafNode}
    expandTreeNode  ${treeName}  ${childNode1}
    treeNodeShouldBeVisible  ${treeName}  ${childNode1}|${leafNode}
    collapseTreeNode  ${treeName}  ${childNode1}
    selectFromPopupMenuOnSelectedTreeNodesKeywordOperatesOnAllSelectedNodes  ${EMPTY}
    [Teardown]  selectFromTreeNodePopupMenu  ${treeName}  0  Show root node

List Children With Invisible Root
    [Setup]  resetNodes
    ${expectedChildnames}=  createList  ${childNode1}  ${childNode2}  ${childNode1}
    hideRootNode
    ${childNames}=  getTreeNodeChildNames  ${treeName}
    listsShouldBeEqual  ${expectedChildnames}  ${childNames}
    ${childNames}=  getTreeNodeChildNames  ${treeName}  ${EMPTY}
    listsShouldBeEqual  ${expectedChildnames}  ${childNames}
    [Teardown]  selectFromTreeNodePopupMenu  ${treeName}  0  Show root node

Tree Keywords Fail If Context Is Not Correct
    selectEmptyContext
    keywordShouldFailBecauseContextIsIllegal  clearTreeSelection  ${treeName}
    keywordShouldFailBecauseContextIsIllegal  expandTreeNode  ${treeName}  Path|To|Tree|Node
    keywordShouldFailBecauseContextIsIllegal  collapseTreeNode  ${treeName}  Path|To|Tree|Node
    keywordShouldFailBecauseContextIsIllegal  treeNodeShouldBeExpanded  ${treeName}  Path|To|Tree|Node
    keywordShouldFailBecauseContextIsIllegal  treeNodeShouldBeCollapsed  ${treeName}  Path|To|Tree|Node
    keywordShouldFailBecauseContextIsIllegal  selectFromTreeNodePopupMenu  ${treeName}  Path|To|Tree|Node  SomethingInMenu
    keywordShouldFailBecauseContextIsIllegal  selectFromTreeNodePopupMenuInSeparateThread  ${treeName}  Path|To|Tree|Node  SomethingInMenu
    keywordShouldFailBecauseContextIsIllegal  selectTreeNode  ${treeName}  Path|To|Tree|Node
    keywordShouldFailBecauseContextIsIllegal  unselectTreeNode  ${treeName}  Path|To|Tree|Node
    keywordShouldFailBecauseContextIsIllegal  treeNodeShouldBeSelected  ${treeName}  Path|To|Tree|Node
    keywordShouldFailBecauseContextIsIllegal  treeNodeShouldNotBeSelected  ${treeName}  Path|To|Tree|Node
    keywordShouldFailBecauseContextIsIllegal  treeNodeShouldBeVisible  ${treeName}  Path|To|Tree|Node
    keywordShouldFailBecauseContextIsIllegal  treeNodeShouldNotBeVisible  ${treeName}  Path|To|Tree|Node
    keywordShouldFailBecauseContextIsIllegal  treeNodeShouldBeLeaf  ${treeName}  Path|To|Tree|Node
    keywordShouldFailBecauseContextIsIllegal  treeNodeShouldNotBeLeaf  ${treeName}  Path|To|Tree|Node
    keywordShouldFailBecauseContextIsIllegal  treeNodeShouldExist  ${treeName}  Path|To|Tree|Node
    keywordShouldFailBecauseContextIsIllegal  treeNodeShouldNotExist  ${treeName}  Path|To|Tree|Node
    keywordShouldFailBecauseContextIsIllegal  treeNodePopupMenuItemShouldBeDisabled  ${treeName}  Path|To|Tree|Node  SomethingInMenu
    keywordShouldFailBecauseContextIsIllegal  treeNodePopupMenuItemShouldBeDisabled  ${treeName}  Path|To|Tree|Node  SomethingInMenu
    keywordShouldFailBecauseContextIsIllegal  selectFromPopupMenuOnSelectedTreeNodes  ${treeName}  SomethingInMenu
    keywordShouldFailBecauseContextIsIllegal  getTreeNodeLabel  ${treeName}  0
    [Teardown]  selectMainWindow

Tree Item With Same Name As Menu Item Enablement Status
    [Tags]  display-required
    menuItemShouldBeDisabled  Test Menu|Menu Item
    selectMainWindow
    treeNodePopupMenuItemShouldBeEnabled  ${treeName}  ${rootNode}  Menu Item
    popupMenuShouldNotBeDisplayed

Get Current Selection Paths
    [Setup]  resetNodes
    selectNodes
    ${expected_elements} =  createList  The Java Series|Books for Java Implementers  The Java Series|Books for Java Programmers
    ${selected_elements} =  getSelectionPaths  ${treeName}
    listsShouldBeEqual  ${selected_elements}  ${expected_elements}

Select From Popup Menu On Selected Tree Nodes Check Menu Item
    [Setup]  resetNodes
    selectNodes
    selectFromPopupMenuOnSelectedTreeNodes  ${treeName}  Disabled menuitem  False
    Run Keyword And Expect Error  Menu pushing: (JMenuItem with text "Disabled menuitem")  selectFromPopupMenuOnSelectedTreeNodes  ${treeName}  Disabled menuitem  True

*** Keywords ***
keywordShouldFailBecauseContextIsIllegal
    [Arguments]  ${keyword}  @{arguments}
    runKeywordAndExpectError  *To use this keyword you must first select a correct context*  ${keyword}  @{arguments}

popupMenuShouldNotBeDisplayed
    componentShouldNotExist  popupMenu

resetNodes
    selectFromTreeNodePopupMenu  ${treeName}  0  Show root node
    expandTreeNode  ${treeName}  ${rootNode}
    collapseTreeNode  ${treeName}  ${rootNode}|${childNode1}
    collapseTreeNode  ${treeName}  ${rootNode}|${childNode2}

selectFromPopupMenuOnSelectedTreeNodesKeywordOperatesOnAllSelectedNodes
    [Arguments]  ${root}=${rootNode}|
    clearSavedNodes
    selectNodes  ${root}
    selectFromPopupMenuOnSelectedTreeNodes  ${treeName}  Save node paths
    nodesShouldBeSaved

selectNodes
    [Arguments]  ${root}=${rootNode}|
    selectTreeNode  ${treeName}  ${root}${childNode2}
    selectTreeNode  ${treeName}  ${root}${childNode1}

nodesShouldBeSaved
    savedNodesShouldBe  ${childNode2}  ${childNode1}

hideRootNode
    [Arguments]  ${root}=${rootNode}
    selectFromTreeNodePopupMenu  ${treeName}  ${root}  Hide root node

setTimeoutsAndDelays
    ${timeout}=  evaluate  ${delay}/1000
    log  ${timeout}
    runKeywordIf  ${timeout}  setJemmyTimeouts  ${timeout}
    setDelay  ${delay}
    randomizeDelay

