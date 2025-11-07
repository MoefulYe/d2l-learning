# softmax-regression-scratch — 练习解答

1. 直接用定义实现 softmax 的问题？
   - 溢出/下溢：如 exp(50) 溢出，exp(−1000) 下溢为 0，导致数值不稳定。

2. 直接按定义实现交叉熵 `cross_entropy` 的问题？
   - 出现 log(0)→−∞；同时与 softmax 组合时会造成数值放大/抵消问题。

3. 解决方案。
   - 稳定 softmax：先减去最大值：`o -= o.max(dim=1, keepdim=True)[0]`，再 `exp/o.sum`。
   - 使用 `log_softmax` + NLL 形式：`logp = log_softmax(o)`，交叉熵为 `-logp[range(n), y]`；或直接用框架的 `CrossEntropyLoss`（内部已整合稳定性处理）。
   - 对概率取对数前加 `clamp(eps,1-eps)` 防止 log(0)。

4. 返回概率最大的标签总是最优吗？
   - 不一定。需考虑代价/风险与阈值设定（成本敏感学习、期望效用最大化）。如医疗诊断、欺诈检测等不对称代价场景需调整决策阈值或使用最小化期望损失的规则。

5. 预测下一个单词时候的类别过多会带来的问题？
   - 计算代价大：softmax 归一化需对全部词表求 exp 与求和，时间/显存开销随 |V| 增长。
   - 解决：分层/树形 softmax、采样 softmax、NCE、负采样、候选集截断（短列表）等近似方法。
