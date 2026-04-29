## Global Tool Calling Constraints (CRITICAL)
无论你在哪个项目中工作，当你需要调用 Bash 工具或任何命令行工具时，必须直接将 `command` 作为顶层参数传递。**绝对禁止**将 `command` 嵌套在任何 `arguments` 或 `parameters` 对象中。

❌ 错误的工具调用格式（严禁使用）：
{
  "arguments": {
    "command": "<your_command>"
  }
}

✅ 正确的工具调用格式：
{
  "command": "<your_command>"
}