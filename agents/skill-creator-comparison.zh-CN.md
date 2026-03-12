# Skill Creator 深度对比

本文档对本仓库中的两个 `skill-creator` skill 做系统比较：

- `agents/skills/skill-creator/`
- `agents/skills/.system/skill-creator/`

目标不是简单说明“它们不一样”，而是要把下面几件事讲清楚：

1. 它们各自具体是怎么工作的
2. 它们分别针对什么工作流而设计
3. 它们哪些部分重叠
4. 它们哪些部分明显分叉甚至可能冲突
5. 应该如何把它们放在同一个生命周期里理解

## 对比范围

本次重点对比的文件是：

- `agents/skills/skill-creator/SKILL.md`
- `agents/skills/.system/skill-creator/SKILL.md`

同时也参考了两个目录中的脚本、引用资料和辅助文件。

## 执行摘要

这两个 `skill-creator` 不能简单理解成“重复实现”。

它们本质上对应的是 skill 生命周期中的两个不同层级：

- `agents/skills/.system/skill-creator` 更像一个面向 Codex 的 skill 脚手架与规范指南。它关注的是：如何把 skill 正确初始化、如何组织资源、如何生成 UI 元数据、如何做结构校验。
- `agents/skills/skill-creator` 更像一个 skill 研发、评测与优化工作台。它关注的是：如何起草 skill、如何跑系统化评测、如何和 baseline 对比、如何收集人工反馈、如何做 benchmark，以及如何继续迭代优化 skill 本身和它的触发效果。

可以把它们压缩成两句话：

- `.system/skill-creator` 回答的是：“怎样把一个 skill 正确地建出来？”
- `skill-creator` 回答的是：“怎样证明并提升这个 skill 的实际效果？”

## 第一部分：`agents/skills/skill-creator` 是怎么工作的

## 核心定位

根目录版 `skill-creator` 是围绕“迭代评测闭环”设计的。

它的前提不是“把 skill 写出来就结束”，而是：

- skill 只是一个初稿
- 必须用真实 prompt 测试
- 必须和 baseline 比较
- 必须让人看结果
- 必须根据反馈不断迭代

所以它的重心不在脚手架，而在证据驱动的优化。

## 高层流程

`agents/skills/skill-creator/SKILL.md` 描述的流程大致是：

1. 明确 skill 要做什么
2. 写 skill 草稿
3. 设计真实测试 prompt
4. 让 skill 跑这些 prompt
5. 用 baseline 跑同样的 prompt
6. 帮用户同时做定性和定量评估
7. 修改 skill
8. 反复迭代
9. 需要时再单独优化 description 的触发效果
10. 最后打包 skill

这个流程更像研发实验，而不是普通的写文档流程。

## 分阶段拆解

### 1. Capture Intent

它首先会澄清：

- 这个 skill 要支持什么能力
- 什么时候应该触发
- 期望输出是什么格式
- 这个 skill 是否适合配正式测试用例

而且它强调，应该先从当前对话里尽可能抽取上下文，而不是一上来就重新问一遍。这意味着它从一开始就带有 workflow-aware 的倾向。

### 2. Interview and Research

接下来它强调主动补足信息：

- 边界条件
- 输入输出格式
- 依赖
- 示例文件
- 成功标准

如果可用，它还建议用 MCP 或子代理去并行做研究。

### 3. 写 Skill

它要求作者产出：

- `name`
- `description`
- 可选的 `compatibility`
- 具体的 Markdown 正文

其中它特别强调：`description` 是主要触发机制，而且建议写得稍微“pushy”一点，用来对抗 under-triggering。

### 4. 设计测试 Prompt

写完草稿后，它要求先设计 2-3 个真实用户风格的测试 prompt，并保存到：

- `evals/evals.json`

在这个阶段，它先要 prompt，不急着写 assertions。

### 5. 同时运行 With-Skill 和 Baseline

这是根目录版最关键的部分。

对每一个测试用例，它要求同一轮里同时跑两份：

- `with_skill`
- baseline

baseline 的定义取决于场景：

- 新建 skill：`without_skill`
- 改进已有 skill：旧版本快照

这意味着它从设计上就是比较型工作流，而不是单纯看“自己跑出来像不像”。

### 6. 在测试运行时补 Assertions

它不希望作者等待测试完成再行动，而是要求在运行期间顺手把量化断言补起来。

这些 assertions 会写进：

- `eval_metadata.json`
- `evals/evals.json`

### 7. 采集 Timing 和 Token 数据

它明确要求记录：

- `total_tokens`
- `duration_ms`

并落盘到：

- `timing.json`

这说明它不仅关心“结果对不对”，还关心“代价大不大、耗时长不长”。

### 8. Grading 与 Benchmark 聚合

测试完成后，它要求继续做：

- grading
- benchmark 聚合
- 结果分析

这里会配合使用：

- `agents/grader.md`
- `agents/analyzer.md`
- `scripts/aggregate_benchmark.py`

### 9. 生成人工评审界面

它非常强调用：

- `eval-viewer/generate_review.py`

生成 review 界面给用户看。

用户在这个界面里查看输出、查看 formal grades、填写反馈。文档里对这一点非常坚持，意思是：不要在没有把结果呈现给用户前就自作主张做结论。

### 10. 读取反馈并继续迭代

用户反馈保存在：

- `feedback.json`

然后进入循环：

1. 改 skill
2. 把测试跑到新的 iteration 目录
3. 再给用户看
4. 再收反馈
5. 再改

### 11. 优化 Description

根目录版把 description 的触发效果看成一个独立优化问题。

它要求作者：

1. 构造 should-trigger / should-not-trigger 的 eval 集
2. 先让用户审核这个 eval 集
3. 再跑自动优化 loop
4. 最后把最好的 description 写回去

这一步非常高级，也说明它的目标不只是“skill 内容写对”，还包括“skill 要能稳定地被正确触发”。

### 12. 打包最终 Skill

它也包含打包，但打包出现在整个评测与迭代流程之后。这说明打包只是最终交付动作，不是它的核心价值。

## 根目录版的支撑工具链

根目录版 `skill-creator` 自带了一整套比较重的工具链：

- `scripts/run_eval.py`
- `scripts/improve_description.py`
- `scripts/run_loop.py`
- `scripts/aggregate_benchmark.py`
- `scripts/generate_report.py`
- `scripts/package_skill.py`
- `eval-viewer/generate_review.py`
- `agents/grader.md`
- `agents/comparator.md`
- `agents/analyzer.md`
- `references/schemas.md`

这说明它不是一个普通的写作指南，而是一套完整的评测与优化系统。

## 根目录版的设计哲学

根目录版隐含的信念大致是：

- skill 草稿只是一个假设
- skill 质量需要被验证，而不能凭直觉假设
- baseline 对比非常重要
- 人类 review 非常重要
- description 的触发质量可以被经验性优化
- token 和时间成本也应该被一并考察

最准确的概括是：它是一套 skill R&D 工作流。

## 第二部分：`agents/skills/.system/skill-creator` 是怎么工作的

## 核心定位

`.system` 版是围绕“为 Codex 正确构建一个 skill”设计的。

它把 skill 视为一个结构化、模块化的产物，包含：

- 必要的元数据
- 可选的资源目录
- 面向产品 UI 的配置

它的重心不是 benchmark 迭代，而是初始化正确、结构清晰、资源组织合理。

## 高层流程

`agents/skills/.system/skill-creator/SKILL.md` 的主要流程是：

1. 用具体例子理解 skill
2. 规划可复用内容
3. 用脚本初始化 skill
4. 编辑 skill 和资源
5. 校验 skill
6. 在真实使用中继续迭代

这是一个构建和规范流程，不是评测实验室。

## 分阶段拆解

### 1. 用具体例子理解 Skill

`.system` 版同样要求用真实、具体的用例来理解 skill 的边界。同时它还特别提醒：不要一次性问用户太多问题。

它的目标是让 skill 设计足够具体，从而能被正确建模。

### 2. 规划可复用内容

这是 `.system` 版非常核心的一步。

对于每一个用例，作者都应该判断 skill 是否应该沉淀出：

- scripts
- references
- assets

文档里给出的例子包括：

- PDF skill 需要可复用脚本
- 前端 skill 需要 boilerplate 资产
- BigQuery skill 需要 schema references

这说明它把“资源抽象”提升成了独立的设计阶段。

### 3. 初始化 Skill

`.system` 版明确要求，新建 skill 时优先使用：

- `scripts/init_skill.py`

这个脚本会：

- 规范 skill 名称
- 创建目录
- 生成模板 `SKILL.md`
- 按需创建资源目录
- 生成 `agents/openai.yaml`

这强烈说明 `.system` 版想从第一步就把 skill 创建过程标准化。

### 4. 生成 UI 元数据

这是 `.system` 版最独特的点之一。

它明确要求生成：

- `display_name`
- `short_description`
- `default_prompt`

并通过：

- `scripts/generate_openai_yaml.py`

写入：

- `agents/openai.yaml`

这意味着一部分 skill 定义被从 `SKILL.md` 中拆出来，放进产品 UI 元数据里。

### 5. 编辑 Skill

在编辑 skill 时，`.system` 版重点强调：

- 只放 Codex 真正需要的信息
- skill 尽量精炼
- 避免重复信息
- 大段细节移到 `references/`
- 根据任务脆弱度设置恰当的自由度

它比根目录版更在意 token 预算和信息架构。

### 6. 校验 Skill

它明确要求运行：

- `scripts/quick_validate.py`

来检查：

- YAML frontmatter 是否存在
- 必要字段是否齐全
- 命名规则是否正确
- 描述长度是否合适

### 7. 通过真实使用继续迭代

和根目录版相比，这里的迭代是轻量的：

1. 在真实任务中使用 skill
2. 发现问题或摩擦点
3. 修改 skill
4. 再试

它没有 formal benchmark，没有 viewer，也没有 baseline 对照系统。

## `.system` 版的支撑工具链

`.system` 版的工具链更小、更聚焦：

- `scripts/init_skill.py`
- `scripts/generate_openai_yaml.py`
- `scripts/quick_validate.py`
- `references/openai_yaml.md`
- `agents/openai.yaml`

这和“脚手架与元数据生成器”的定位是完全一致的。

## `.system` 版的设计哲学

`.system` 版隐含的信念大致是：

- skill 是一个结构化的 Codex 产物
- 好的默认值和脚手架能减少错误
- skill 的资源应该被有意识地规划
- context window 是稀缺资源，必须节省
- UI-facing metadata 很重要
- skill 应该保持整洁、简洁、模块化

最准确的概括是：它是一套 skill 构建与规范工作流。

## 第三部分：直接对比

## 核心差异

这两个版本解决的是不同问题。

- `agents/skills/.system/skill-creator` 解决的是 skill construction 问题
- `agents/skills/skill-creator` 解决的是 skill optimization and validation 问题

这是最准确的高层区分。

## 工作流对比

### 根目录版 `skill-creator`

主循环是：

1. draft
2. evaluate
3. compare against baseline
4. collect human review
5. revise
6. rerun
7. optimize description

### `.system/skill-creator`

主循环是：

1. understand examples
2. plan reusable resources
3. initialize structure
4. write skill contents
5. generate metadata
6. validate
7. iterate through real usage

## 能力矩阵

| 能力 | `agents/skills/skill-creator` | `agents/skills/.system/skill-creator` |
|---|---|---|
| 初始化 skill 目录 | 弱 | 强 |
| 生成 `SKILL.md` 模板 | 弱 | 强 |
| 生成 `agents/openai.yaml` | 基本不关注 | 强 |
| 规划可复用资源 | 中 | 强 |
| 基础结构校验 | 有 | 有 |
| 正式 eval 工作流 | 强 | 无 |
| baseline 对比 | 强 | 无 |
| grading 与 benchmark | 强 | 无 |
| 人工 review viewer | 强 | 无 |
| blind comparison | 有 | 无 |
| trigger description 优化 | 强 | 无 |
| 打包交付 | 有 | 非核心 |

## 章节级映射

| 主题 | 根目录版 | `.system` 版 | 关系判断 |
|---|---|---|---|
| skill 是什么 | 略讲 | 讲得很多 | `.system` 更基础 |
| 需求发现 | `Capture Intent`、`Interview and Research` | `Understanding the Skill with Concrete Examples` | 重叠 |
| 资源规划 | 提到但不是主轴 | 独立阶段 | `.system` 更强 |
| 写 `SKILL.md` | 更强调 trigger | 更强调结构和精简 | 重叠但重点不同 |
| progressive disclosure | 有 | 有 | 重叠 |
| 初始化脚手架 | 无 | 有 | `.system` 独有 |
| UI 元数据 | 很弱 | 很强 | `.system` 独有 |
| validation | 有 | 有 | 重叠 |
| test prompt 工作流 | 核心 | 没有正式体系 | 根目录独有 |
| baseline testing | 核心 | 没有 | 根目录独有 |
| benchmarking | 核心 | 没有 | 根目录独有 |
| human review UI | 核心 | 没有 | 根目录独有 |
| trigger eval 优化 | 核心 | 没有 | 根目录独有 |

## 哲学层面的对照

差别不只是“一个更长”或者“一个脚本更多”，而是体现了两套不同的工程哲学。

### 根目录版哲学

- 不要假设第一版 skill 就够好
- 要测行为
- 要和 baseline 比
- 要给人看结果
- 要把触发效果也当成优化对象
- 要反复迭代直到表现稳定

### `.system` 版哲学

- 先把结构搭对
- skill 要尽量短而精
- scripts 和 references 要有意识地规划
- UI 元数据和 trigger 元数据应分开
- 标准化生成很重要
- 尽早做基础校验

## 第四部分：脚本层面对比

## `.system` 版脚本，以及它们代表的设计思想

### `scripts/init_skill.py`

这个脚本代表的是“工厂式初始化”。

它会：

- 规范 skill 名
- 创建目录
- 写模板 `SKILL.md`
- 按需创建资源目录
- 可选生成 `agents/openai.yaml`

这个脚本背后的观念是：skill 应该从标准脚手架开始，而不是完全靠手工随意拼装。

### `scripts/generate_openai_yaml.py`

这个脚本代表的是“skill 也是 UI / 产品对象”。

它会生成：

- `display_name`
- `short_description`
- 可选 interface 字段

并写入：

- `agents/openai.yaml`

这一点非常贴近 Codex 产品模型，而根目录版基本没有这一层关注。

### `scripts/quick_validate.py`

这个脚本代表的是轻量级结构正确性：

- frontmatter 合法
- naming 合法
- description 合法

在 `.system` 的工作流里，它是关键守门步骤，不只是一个附带脚本。

## 根目录版脚本，以及它们代表的设计思想

### `scripts/run_eval.py`

这个脚本代表的是：触发行为可以被经验性测量。

它测试的是 description 是否真的会让 skill 在真实 query 下被调用。这样一来，skill invocation 就从一个模糊的文案问题，变成了一个可测量的行为问题。

### `scripts/improve_description.py`

这个脚本代表的是：`description` 不是一次性写出来的文案，而是可以被持续优化的 artifact。

它会结合失败案例和历史尝试生成更好的 description，同时尽量避免简单把失败 query 直接堆进 description 导致过拟合。

### `scripts/run_loop.py`

这个脚本代表的是：description 优化可以走 train/test 分离的闭环。

它会：

- 切分 train 和 test
- 反复评测
- 根据 train 失败点改 description
- 用 held-out 表现选最优结果

这已经很接近实验循环，而不是普通文档写作。

### `scripts/aggregate_benchmark.py`

这个脚本代表的是：skill 质量是多维的。

它会聚合：

- pass rate
- timing
- token usage

并计算不同配置的 delta。

也就是说，skill 不只是“作者觉得看起来不错”，而是要在正确性、速度、成本上一起衡量。

### `scripts/package_skill.py`

这个脚本负责在流程末尾打包 skill。在根目录版工作流里，打包是测试与迭代之后的交付动作。

## 脚本层结论

到了脚本层，对比会更清楚：

- `.system` 版脚本负责创建、规范化、校验
- 根目录版脚本负责评测、对比、优化、打包

## 第五部分：重叠点、差异点与潜在冲突

## 重叠点

这两个版本确实有一些重叠：

- 都关心 `name` 和 `description`
- 都关心资源目录
- 都讨论 progressive disclosure
- 都包含 validation
- 都默认 skill 可能需要迭代

所以它们不是互不相关，而是各自偏重不同阶段。

## `.system` 更强的地方

- 初始化 skill
- 保持目录结构整洁
- 规划可复用资源
- 生成 Codex 特有的 UI metadata
- 做简洁的信息架构设计

## 根目录版更强的地方

- 构建真实 eval
- baseline 对比
- benchmark 分析
- 人工 review 流程
- blind comparison
- trigger description 优化

## 潜在张力

### 1. Frontmatter 规范并不完全一致

`.system` 版正文里倾向于认为 frontmatter 只应该有：

- `name`
- `description`

而根目录版的 validator 允许更多字段，比如：

- `license`
- `allowed-tools`
- `metadata`
- `compatibility`

这意味着仓库里同时存在：

- 一套理想化的规范
- 一套更宽松的现实兼容范围

### 2. 对 skill 文本长度的容忍度不同

根目录版愿意支持比较复杂的工作流，只要它是有价值的、并且遵守 progressive disclosure。

`.system` 版则更强烈地强调：

- context economy
- 不要啰嗦
- 不要重复 Codex 已知知识

这会导致两种不同的写作风格：

- 根目录版：更富操作性、更偏 workflow
- `.system` 版：更精炼、更偏模块化

### 3. 抽脚本的时机不同

`.system` 版希望在设计阶段就想清楚脚本和 references。

根目录版则常常是在观察 eval 运行过程后，从重复劳动中反推出应该抽脚本。

这是方法论上的区别：

- `.system`：前置规划复用
- 根目录版：从运行现象中归纳复用

### 4. 平台取向不同

根目录版明显围绕 Claude 生态展开：

- `claude -p`
- Claude.ai
- Cowork
- subagents

`.system` 版则明显围绕 Codex / 产品 UI 展开：

- Codex
- `agents/openai.yaml`
- UI metadata

这是基于文档和脚本做出的推断，但这个推断非常稳定。

## 第六部分：如何理解两者的关系

最合理的理解方式是：这两个目录处在同一生命周期的不同层级。

### `.system/skill-creator`

更像 canonical factory 或 standards layer：

- 把 skill 建出来
- 把结构搭对
- 把 metadata 配对
- 把基础规范校验过

### `agents/skills/skill-creator`

更像 advanced lab 或 optimization layer：

- 跑真实测试
- 和其他配置比较
- 做人工 review
- 改 skill
- 调触发 description

所以它们不应该被理解成互斥替代品，而更像是互补工具。

## 第七部分：推荐的组合工作流

如果把这两个 skill 串起来，最合理的顺序是：

1. 用 `.system/skill-creator` 创建 skill 骨架
2. 用 `.system/skill-creator` 生成 `agents/openai.yaml`
3. 用 `.system/skill-creator` 校验结构和命名
4. 用根目录版 `skill-creator` 设计真实 eval prompts
5. 用根目录版 `skill-creator` 跑 with-skill / baseline 对比
6. 用根目录版 `skill-creator` 生成 benchmark 和 review artifacts
7. 用根目录版 `skill-creator` 继续迭代 skill 行为
8. 用根目录版 `skill-creator` 优化 description 的触发效果
9. 最后打包 skill

这样能把两边的优势都用上。

## 最终结论

这两个 `skill-creator` 在目的上是深度不同的。

当主要问题是下面这些时，`.system/skill-creator` 更合适：

- 想把一个新 skill 干净地建出来
- 想把目录结构组织正确
- 想生成 Codex-facing metadata
- 想确保基础规范正确

当主要问题是下面这些时，根目录版 `skill-creator` 更合适：

- 想验证 skill 的实际效果到底如何
- 想和 baseline 比较
- 想通过人工 review 持续改进输出
- 想用经验方法优化 trigger quality

最准确的最终总结是：

- `.system/skill-creator` 关注 skill construction
- 根目录版 `skill-creator` 关注 skill optimization and validation

它们一起构成的是一个更成熟的 skill 开发生命周期，而不是简单的重复实现。
