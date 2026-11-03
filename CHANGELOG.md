# 新增功能

与原版相比，新增了 **Paragraph（段落）** 和 **ParagraphDropdown（段落下拉框）**。

---

## Paragraph（段落）

用于显示标题和文本内容，可以在 Tab 或 Groupbox 中使用。

### 在 Tab 中使用

```lua
local paragraph = Tab:AddParagraph({
    Title = "标题",
    Content = "这里是段落内容",
    Side = "Left",
})
```

### 在 Groupbox 中使用

```lua
local paragraph = Groupbox:AddParagraph({
    Title = "标题",
    Content = "这里是段落内容",
})
```

### 常用方法

```lua
paragraph:SetTitle("新标题")
paragraph:SetContent("新的段落内容")
```

---

## ParagraphDropdown（段落下拉框）

将下拉列表和段落内容组合在一起，直接添加到 Tab。

支持单选、多选、内嵌列表、悬浮列表和放大面板。

### 基本用法

```lua
local dropdown = Tab:AddParagraphDropdown({
    Title = "选择",
    Side = "Right",
    Mode = "Inline",

    Values = {
        "1",
        "2",
        "3",
    },

    Default = 1,
    MaxVisibleItems = 4,

    Contents = {
        ["1"] = "这里是 1 的内容。",
        ["2"] = "这里 2 的内容。",
        ["3"] = "这里是 3 的内容。",
    },

    Callback = function(value)
        print("当前选择：", value)
    end,
})
```

### 配置项

| 配置项 | 类型 | 说明 |
| --- | --- | --- |
| `Title` | `string` | 下拉框标题 |
| `Side` | `string` | 位置，可用 `"Left"`、`"Right"` 或 `"Full"` |
| `Mode` | `string` | 列表模式：`"Inline"` 或 `"Floating"` |
| `Values` | `table` | 可选项数组，选项值应保持唯一 |
| `Default` | `number` / `选项值` / `table` | 默认选择；数字按 `Values` 索引解释，多选时可传表 |
| `Multi` | `boolean` | 是否允许多选 |
| `AllowNull` | `boolean` | 是否允许不选择任何选项 |
| `DisabledValues` | `table` | 禁止点击的选项 |
| `MaxVisibleItems` | `number` | 列表最多显示的行数，超出后可滚动 |
| `Content` | `string` | 初始段落内容 |
| `Contents` | `table` | 选项对应的段落内容 |
| `ContentSeparator` | `string` | 多选内容之间的分隔符，默认为两个换行 |
| `ListOnly` | `boolean` | 隐藏选择框并保持列表展开，仅支持 `Inline` |
| `DefaultOpen` | `boolean` | 初始化时是否展开列表 |
| `Expandable` | `boolean` | 是否显示放大按钮，默认为 `true` |
| `ExpandColumns` | `number` | 放大面板的列数，默认为 `2` |
| `CloseOnSelect` | `boolean` | 单选后是否关闭普通列表，默认为 `true` |
| `Visible` | `boolean` | 控件是否可见，默认为 `true` |
| `Callback` | `function` | 选择变化时调用 |

### 多选用法

```lua
local dropdown = Tab:AddParagraphDropdown({
    Title = "选择",
    Side = "Right",
    Mode = "Inline",

    Multi = true,
    AllowNull = true,

    Values = {
        "1",
        "2"",
        "3",
    },

    Default = {
        "1",
        "3",
    },

    Contents = {
        ["1] = "ts 1",
        ["1"] = "ts 2",
        ["1"] = "ts 3",
    },

    Callback = function(selected)
        for value, enabled in pairs(selected) do
            if enabled then
                print("已选择：", value)
            end
        end
    end,
})
```

多选时，`Value` 和回调参数是一个表：

```lua
{
    ["1"] = true,
    ["2"] = true,
}
```

设置了 `Contents` 时，已选内容会按照 `Values` 的顺序拼接显示。

### 常用方法

| 方法 | 说明 |
| --- | --- |
| `SetValue(value)` | 设置当前选项；多选时传入表 |
| `SetValues(values)` | 替换选项列表 |
| `AddValues(values)` | 添加选项 |
| `GetActiveValues()` | 获取已选项数组 |
| `GetActiveValues(true)` | 获取已选项数量 |
| `SelectAll()` | 选择所有可用项，仅多选 |
| `DeselectAll()` | 取消选择可用项，仅多选 |
| `SetDisabledValues(values)` | 设置禁用选项 |
| `AddDisabledValues(values)` | 添加禁用选项 |
| `OnChanged(callback)` | 设置变化回调 |
| `SetTitle(title)` | 修改标题 |
| `SetContent(content)` | 修改段落内容 |
| `SetListOnly(enabled)` | 开启或关闭常驻列表模式 |
| `SetOpen(open)` | 展开或收起普通列表 |
| `SetVisible(visible)` | 设置控件是否可见 |
| `Expand()` | 打开放大面板 |
| `Collapse()` | 关闭放大面板 |
| `ToggleExpanded()` | 切换放大面板状态 |
| `IsExpanded()` | 获取放大面板是否打开 |
| `Destroy()` | 销毁控件 |

```lua
-- 单选
dropdown:SetValue("2")

-- 多选
dropdown:SetValue({
    "1",
    "3",
})

-- 打开放大面板
dropdown:Expand()
```

> [!NOTE]
> 设置了 `Contents` 后，切换选项会自动更新段落内容。如果需要完全自行控制内容，可以不设置 `Contents`，并在回调中调用 `SetContent()`。
