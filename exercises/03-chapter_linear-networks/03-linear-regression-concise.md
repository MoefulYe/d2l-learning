# linear-regression-concise — 练习解答

1. 如果将小批量的总损失替换为小批量损失的平均值，需要如何更改学习率？
   - 将损失从“求和”改为“求平均”，梯度会缩小为原来的 `1/batch_size`。若希望保持与“求和”时相近的更新幅度，应把学习率放大 `batch_size` 倍：`lr_mean = lr_sum * batch_size`。反之，从“平均”切到“求和”需把学习率缩小 `1/batch_size`。
   - 说明：PyTorch 中许多损失（如 `nn.MSELoss(reduction='mean')`）默认是平均，需要与手写实现（常用求和）对应调整学习率。

2. 查看深度学习框架文档，它们提供了哪些损失函数和初始化方法？用 Huber 损失代替原损失如何实现？
   - 常见损失（PyTorch）：`MSELoss`、`L1Loss`、`SmoothL1Loss/HuberLoss`、`CrossEntropyLoss`、`BCEWithLogitsLoss`、`NLLLoss`、`KLDivLoss` 等。
   - 常见初始化（`torch.nn.init`）：`xavier_uniform_/normal_`（Glorot）、`kaiming_uniform_/normal_`（He）、`zeros_/ones_/constant_`、`normal_/uniform_`、`orthogonal_` 等。
   - Huber 损失实现：
     - 方式 A（推荐）：`nn.HuberLoss(delta=sigma, reduction='mean'|'sum')`
     - 方式 B：`nn.SmoothL1Loss(beta=sigma, reduction=...)`（其分段形式等价于 Huber，`beta` 为阈值）。
     - 用法示例：
       - `criterion = nn.HuberLoss(delta=sigma)` 或 `criterion = nn.SmoothL1Loss(beta=sigma)`；
       - `loss = criterion(y_hat, y)`，其余训练流程不变。

3. 如何访问线性回归的梯度？
   - 对 `nn.Linear` 层，反向传播后可通过参数的 `.grad` 访问：
     - 若模型为 `net = nn.Sequential(nn.Linear(d_in, 1))`：
       - 权重梯度：`net[0].weight.grad`
       - 偏置梯度：`net[0].bias.grad`
     - 或若定义为 `net = nn.Linear(d_in, 1)`：
       - 权重梯度：`net.weight.grad`
       - 偏置梯度：`net.bias.grad`
   - 注意先调用 `optimizer.zero_grad()` 再 `loss.backward()`，随后再 `optimizer.step()`；访问 `.grad` 应在 `backward()` 之后。
