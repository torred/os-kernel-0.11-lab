/*
 *  linux/fs/truncate.c
 *
 *  (C) 1991  Linus Torvalds
 */
#include <linux/sched.h>
#include <sys/stat.h>

/** 
 * 释放所有一次间接块
 * @param[in]	dev		文件系统所有设备的设备号
 * @param[in]	block	逻辑块号
 * @retval  	成功返回1，失败返回0
 */
static void free_ind(int dev,int block)
{
	struct buffer_head * bh;
	unsigned short * p;
	int i;

	/* 如果逻辑块号为0，则返回 */
	if (!block) {
		return;
	}
	/* 读取一次间接块，并释放其上表明使用的所有逻辑块，然后释放该一次间接块的缓冲块 */
	if ((bh = bread(dev, block))) {
		p = (unsigned short *) bh->b_data;	/* 指向缓冲块数据区 */
		for (i = 0; i < 512; i++, p++) {	/* 每个逻辑块上可有512个块号 */
			if (*p) {
				free_block(dev,*p);		/* 释放指定的设备逻辑块 */
			}
		}
		brelse(bh);							/* 然后释放间接块占用的缓冲块 */
	}
	/* 最后释放设备上的一次间接块。但如果其中有逻辑块没有被释放，则返回0(失败) */
	free_block(dev,block);		/* 成功则返回1，否则返回0 */
}


/** 
 * 释放所有二次间接块
 * @param[in]	dev		文件系统所有设备的设备号
 * @param[in]	block	逻辑块号
 * @retval		成功返回1，失败返回0
 */
static void free_dind(int dev,int block)
{
	struct buffer_head * bh;
	unsigned short * p;
	int i;

	if (!block) {
		return;
	}
	if ((bh = bread(dev, block))) {
		p = (unsigned short *) bh->b_data;	/* 指向缓冲块数据区 */
		for (i = 0; i < 512; i++, p++) {	/* 每个逻辑块上可连接512个二级块 */
			if (*p) {
				free_ind(dev,*p);			/* 释放所有一次间接块 */
			}
		}
		brelse(bh);							/* 释放二次间接块占用的缓冲块 */
	}
	/* 最后释放设备上的二次间接块。但如果其中有逻辑块没有被释放，则返回0(失败) */
	free_block(dev,block);					/* 最后释放存放第一间接块的逻辑块 */
}

/** 
 * 截断文件数据函数
 * 将节点对应的文件长度减0，并释放占用的设备空间
 * @param[in]	inode
 * @retval  	void
 */
void truncate(struct m_inode * inode)
{
	int i;

	if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode))) {
		return;
	}
	for (i = 0; i < 7; i++) {
		if (inode->i_zone[i]) {
			free_block(inode->i_dev,inode->i_zone[i]);
			inode->i_zone[i]=0;
		}
	}
	free_ind(inode->i_dev,inode->i_zone[7]);
	free_dind(inode->i_dev,inode->i_zone[8]);
	inode->i_zone[7] = inode->i_zone[8] = 0;
	inode->i_size = 0;
	/* 设置i节点已修改标志，并且如果还有逻辑块由于“忙”而没有被释放，则把当前进程运行时间
	 片置0，以让当前进程先被切换去运行其他进程，稍等一会再重新执行释放操作 */
	inode->i_dirt = 1;
	inode->i_mtime = inode->i_ctime = CURRENT_TIME;
}

