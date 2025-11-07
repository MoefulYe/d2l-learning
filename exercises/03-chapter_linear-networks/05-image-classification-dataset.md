# image-classification-dataset — 练习解答

1. 将 batch_size 减小到 1 对读取性能的影响？
   - 每批开销增大、数据/线程调度频繁，GPU/向量化利用率下降，吞吐量明显降低；I/O 和 Python 解释器开销更突出。

2. 数据迭代器性能是否足够？如何改进？（PyTorch）
   - 增大 `batch_size`（在显存允许下）。
   - 使用多进程加载：`num_workers>0`，并配合 `persistent_workers=True`、`prefetch_factor`。
   - 置 `pin_memory=True`，并在训练端用 `non_blocking=True` 以加速 H2D 传输。
   - 复用变换与缓存：将解码/变换放在 `Dataset` 内，必要时进行缓存或使用更快的解码库。
   - 充分利用异步：预取数据、减少 Python 层循环与小对象创建。

3. 还有哪些可用数据集？
   - 视觉常见：MNIST、FashionMNIST、CIFAR10/100、SVHN、STL10、ImageNet、VOC、COCO、CelebA 等。
   - 也可使用自定义 `ImageFolder`/`Dataset` 及相应数据管道。
