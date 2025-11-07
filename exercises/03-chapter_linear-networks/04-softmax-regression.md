# softmax-regression — 练习解答

1. softmax 交叉熵的二阶导与方差关系。
   - 对于对数几率 o，预测分布 p=softmax(o)，一条样本的交叉熵 l=−∑k yk log pk。
   - 一阶导：∂l/∂o = p − y。
   - 二阶导（Hessian w.r.t. o）：H = diag(p) − p p^T（半正定）。
   - 类别指示随机变量的协方差：Cov[onehot] = diag(p) − p p^T，与 H 相同；方差 Var[Ik]=pk(1−pk)，协方差为 −pipj。

2. 三类等概率 p=(1/3,1/3,1/3) 的二进制编码问题。
   - 固定长度编码需 2 比特/符号，浪费（熵 H=log2 3≈1.585）。
   - 更好的方案：块编码或算术/范围编码；例如对两符号联合（9 种），可用 4 或 5 比特的前缀码，平均码长更接近 2·H；随着联合编码 n 增大，平均码长按香农极限逼近熵。

3. RealSoftMax(a,b)=log(exp(a)+exp(b))（即 log-sum-exp）。
   - 证明 RealSoftMax(a,b) > max(a,b)：设 m=max(a,b)，则 log(exp(a)+exp(b)) = m + log(1+exp(−|a−b|)) > m。
   - 证明 λ>0 时 λ^{-1}RealSoftMax(λa,λb) > max(a,b)：同上替换 a→λa，b→λb。
   - 证明极限 λ→∞：λ^{-1} log(exp(λa)+exp(λb)) → max(a,b)（由主导项和拉普拉斯法则）。
   - soft-min：SoftMin(a,b)= −log(exp(−a)+exp(−b))；更一般 K 个数的推广为 log ∑k exp(·) 与其对偶。
