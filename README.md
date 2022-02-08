# nfsdv4_probe

## 部署
1. 在nfs server上进行部署
2. 考虑不同的服务器，空闲空间路径的不同（会生成大量kernel trace日志），因此建议使用tmux/screen/nohup等方式，在空闲分区运行

## 运行

```bash
Shell> tmux
Shell> ./nfsdv4_probe
```

运行后，即刻在当前目录下生成`trace.log`

## 日志

单个日志200M，日志最多保留1024个，时间最多保留30天

## trace的函数

- nfsd4_open
- nfsd4_process_open2
- nfsd4_open_confirm
- nfsd4_lookup
- nfsd4_close
- nfsd4_remove
- nfsd4_rename
- nfsd4_lock
- nfsd4_create
- nfsd4_commit
- nfsd4_access

