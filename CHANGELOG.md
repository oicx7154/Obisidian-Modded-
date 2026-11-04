# 更新日志

## 2026-11-04

### 新增

- 新增 **Paragraph 折叠功能**，支持 Tab 和 Groupbox。
- 新增 **InfoCard（信息卡片）**，支持 Tab 和 Groupbox。

### 调整

- Paragraph 在启用折叠后，标题为空时仍保留折叠操作区域。
- Paragraph 折叠时仍可以修改内容，展开后显示最新内容。

---
# 功能说明

## Paragraph（段落）

用于显示标题和文本内容，可以直接添加到 Tab 或 Groupbox。

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

### 使用折叠功能

设置 `Collapsible = true` 后，点击标题区域即可展开或折叠内容。

```lua
local paragraph = Tab:AddParagraph({
    Title = "内容",
    Content = "内容。",
    Side = "Left",

    Collapsible = true,
    DefaultCollapsed = false,
})
```

也可以在 Groupbox 中使用：

```lua
local paragraph = Groupbox:AddParagraph({
    Title = "功能介绍",
    Content = "点击标题可以展开或折叠内容。",

    Collapsible = true,
    DefaultCollapsed = true,
})
```

### 配置项

| 配置项 | 类型 | 说明 |
| --- | --- | --- |
| `Title` | `string` | 段落标题 |
| `Content` | `string` | 段落内容 |
| `Side` | `string` / `number` | Tab 中的位置：`"Left"`、`"Right"`、`1` 或 `2` |
| `TitleSize` | `number` | 标题文字大小，默认为 `15` |
| `ContentSize` | `number` | 内容文字大小，默认为 `14` |
| `RichText` | `boolean` | 是否启用内容的富文本 |
| `Collapsible` | `boolean` | 是否启用折叠，默认为 `false` |
| `DefaultCollapsed` | `boolean` | 是否默认折叠，默认为 `false` |
| `Visible` | `boolean` | 是否显示，默认为 `true` |
| `LayoutOrder` | `number` | 控件的布局顺序 |

### 常用方法

| 方法 | 说明 |
| --- | --- |
| `SetTitle(title)` | 修改标题 |
| `SetContent(content)` | 修改内容 |
| `SetVisible(visible)` | 设置是否可见 |
| `SetCollapsed(collapsed)` | 设置折叠状态 |
| `Collapse()` | 折叠内容 |
| `Expand()` | 展开内容 |
| `ToggleCollapsed()` | 切换折叠状态 |
| `IsCollapsed()` | 获取当前折叠状态 |
| `Destroy()` | 销毁段落 |

```lua
paragraph:SetTitle("内容")
paragraph:SetContent("这里是新的内容。")

paragraph:Collapse()
paragraph:Expand()
paragraph:ToggleCollapsed()

print("是否折叠：", paragraph:IsCollapsed())
```

> [!NOTE]
> 折叠相关方法仅对启用了 `Collapsible` 的 Paragraph 生效。
> 标题为空时，仍可通过标题区域的箭头操作折叠。

---

## InfoCard（信息卡片）

用于以键值形式展示信息，例如作者、版本、更新时间和运行状态。

可以直接添加到 Tab 或 Groupbox。

### 在 Tab 中使用

```lua
local infoCard = Tab:AddInfoCard({
    Title = "脚本信息",
    Side = "Right",

    Items = {
        { Label = "内容", Value = "1111" },
        { Label = "版本", Value = "1.2.0" },
        { Label = "状态", Value = "正常运行" },
    },
})
```

### 在 Groupbox 中使用

```lua
local infoCard = Groupbox:AddInfoCard({
    Title = "用户信息",

    Items = {
        { Label = "用户名", Value = game.Players.LocalPlayer.Name },
        { Label = "等级", Value = 100 },
        { Label = "状态", Value = "在线" },
    },
})
```

### 配置项

| 配置项 | 类型 | 说明 |
| --- | --- | --- |
| `Title` | `string` | 卡片标题 |
| `Side` | `string` / `number` | Tab 中的位置：`"Left"`、`"Right"`、`1` 或 `2` |
| `Items` | `table` | 信息项数组，每项包含 `Label` 和 `Value` |
| `TitleSize` | `number` | 标题文字大小，默认为 `15` |
| `TextSize` | `number` | 信息项文字大小，默认为 `14` |
| `Visible` | `boolean` | 是否显示，默认为 `true` |
| `LayoutOrder` | `number` | 控件的布局顺序 |

### 常用方法

| 方法 | 说明 |
| --- | --- |
| `SetTitle(title)` | 修改卡片标题 |
| `SetItems(items)` | 替换全部信息项 |
| `SetValue(label, value)` | 修改第一个匹配名称的信息项 |
| `AddItem(label, value)` | 添加一项信息 |
| `RemoveItem(label)` | 删除第一个匹配名称的信息项 |
| `SetVisible(visible)` | 设置是否可见 |
| `Destroy()` | 销毁卡片 |

```lua
-- 修改标题
infoCard:SetTitle("最新信息")

-- 修改指定信息
infoCard:SetValue("状态", "维护中")

-- 添加信息
infoCard:AddItem("更新时间", "2026-11-04")

-- 删除信息
infoCard:RemoveItem("等级")

-- 替换全部信息
infoCard:SetItems({
    { Label = "内容", Value = "1" },
    { Label = "内容", Value = "2.0.0" },
})

-- 隐藏或显示
infoCard:SetVisible(false)
infoCard:SetVisible(true)

-- 销毁
infoCard:Destroy()
```

> [!NOTE]
> `SetValue()` 和 `RemoveItem()` 只处理第一个匹配的 `Label`。
> 找不到对应名称时会返回 `false`。

---
## 2026-11-03

### 新增

- 新增 **Paragraph（段落）**。
- 新增 **ParagraphDropdown（段落下拉框）**。
- 新增 **HoldButton（长按按钮）**。

---
# 功能说明

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
        ["2"] = "这里是 2 的内容。",
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
| `Side` | `string` | 位置，可用 `"Left"` 或 `"Right"` |
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
        "2",
        "3",
    },

    Default = {
        "1",
        "3",
    },

    Contents = {
        ["1"] = "这里是 1 的内容。",
        ["2"] = "这里是 2 的内容。",
        ["3"] = "这里是 3 的内容。",
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
    ["3"] = true,
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

---

## HoldButton（长按按钮）

添加到 Groupbox 中，需要持续按住指定时间才会执行回调。

长按时会显示进度条；提前松开或将鼠标移出按钮会取消进度。

### 基本用法

```lua
Groupbox:AddHoldButton({
    Text = "长按执行",
    HoldTime = 2,

    Callback = function()
        print("长按完成")
    end,
})
```

### 简写方式

```lua
Groupbox:AddHoldButton(
    "长按确认",
    function()
        print("操作已确认")
    end,
    1.5
)
```

三个参数依次为：按钮文字、回调函数、长按时间（秒）。

### 配置项

| 配置项 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `Text` | `string` | `""` | 按钮显示的文字 |
| `Callback` | `function` | 空函数 | 长按完成后调用 |
| `Func` | `function` | 空函数 | 回调函数；同时设置时优先于 `Callback` |
| `HoldTime` | `number` | `1` | 长按时间，单位为秒 |
| `Time` | `number` | `1` | `HoldTime` 的别名 |
| `Disabled` | `boolean` | `false` | 是否禁用按钮 |
| `Risky` | `boolean` | `false` | 风险标记 |
| `Tooltip` | `string` | `nil` | 提示文字 |
| `DisabledTooltip` | `string` | `nil` | 禁用时的提示文字 |

> [!NOTE]
> 当前实现只保存 `Risky`、`Tooltip` 和 `DisabledTooltip`，尚未根据它们创建提示框或改变按钮外观。

### 返回对象

```lua
local holdButton = Groupbox:AddHoldButton({
    Text = "长按执行",
    HoldTime = 2,

    Callback = function()
        print("执行成功")
    end,
})
```

返回对象包含 `Base`、`Stroke` 和 `FillBar` 等属性。当前实现尚未提供 `SetDisabled`、`SetVisible` 或 `Destroy` 等方法。

---

## 关于全宽布局

- 新版 Paragraph 和 InfoCard 在容器不存在时会报错提示。
- 当前 ParagraphDropdown 在容器不存在时会回退到左列。
