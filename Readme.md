# UI 更新日志

## [更新日期：2026/11/4]

### 新增：Paragraph 折叠功能

- `Tab:AddParagraph()` 和 `Groupbox:AddParagraph()` 均支持折叠内容。
- 使用 `Collapsible` 开启折叠功能。
- 使用 `DefaultCollapsed` 设置默认折叠状态。
- 展开和收起时带有平滑动画。
- 标题为空时，仍可通过箭头区域操作折叠。
- 折叠状态下调用 `SetContent()` 修改内容，展开后显示新内容。
- 未开启折叠的 Paragraph 保持原有调用方式。

新增方法：

- `Collapse()`：折叠内容。
- `Expand()`：展开内容。
- `ToggleCollapsed()`：切换折叠状态。
- `IsCollapsed()`：获取当前折叠状态。
- `SetCollapsed(boolean)`：设置折叠状态。

### 新增：InfoCard 信息卡片

- 支持直接添加到 Tab 或 Groupbox。
- 使用键值形式展示信息，如作者、版本和运行状态。
- 支持设置标题及文字大小。
- 支持动态修改、添加和删除信息。
- 支持显示、隐藏和销毁卡片。
- Groupbox 内的卡片会随内容变化更新容器高度。
- 卡片颜色跟随 UI 主题。

新增方法：

- `SetTitle(title)`：修改标题。
- `SetItems(items)`：替换全部信息。
- `SetValue(label, value)`：修改指定名称的值。
- `AddItem(label, value)`：添加一项信息。
- `RemoveItem(label)`：删除指定名称的信息。
- `SetVisible(boolean)`：设置卡片是否可见。
- `Destroy()`：销毁卡片。

## [更新日期：2026/11/3]

- 将 UI 库更新至最新版 Obsidian UI。
- 将自定义的 **Paragraph（段落）** 和 **ParagraphDropdown（段落下拉框）** 移植到新版。
- 适配 ParagraphDropdown 的 Floating 悬浮列表布局和滚动。
- 适配段落 Dropdown 和普通 Dropdown 的 Expand 放大面板。
- 将自定义 **HoldButton（长按按钮）** 移植到新版。
- 调整底栏 Footer，支持显示可复制的文字和链接。
- 修复部分旧版代码与新版主题颜色及窗口结构不兼容的问题。
