/*
 *  linux/fs/stat.c
 *
 *  (C) 1991  Linus Torvalds
 */

#include <errno.h>
#include <sys/stat.h>

#include <linux/fs.h>
#include <linux/sched.h>
#include <linux/kernel.h>
#include <asm/segment.h>

/**
 * 复制文件状态信息
 * @param[in]		inode		文件i节点
 * @param[in/out]	statbuf		用户数据空间中stat文件状态结构指针，用于存放取得的状态信息
 * @retval			void
 */
static void cp_stat(struct m_inode * inode, struct stat * statbuf)
{
	struct stat tmp;
	int i;

	verify_area(statbuf,sizeof (* statbuf));
	tmp.st_dev		= inode->i_dev;
	tmp.st_ino		= inode->i_num;
	tmp.st_mode		= inode->i_mode;
	tmp.st_nlink	= inode->i_nlinks;
	tmp.st_uid		= inode->i_uid;
	tmp.st_gid		= inode->i_gid;
	tmp.st_rdev		= inode->i_zone[0];	/* 特殊文件的设备号 */
	tmp.st_size		= inode->i_size;
	tmp.st_atime	= inode->i_atime;
	tmp.st_mtime	= inode->i_mtime;
	tmp.st_ctime	= inode->i_ctime;

	for (i = 0; i < sizeof(tmp); i++) {
		put_fs_byte(((char *) &tmp)[i],&((char *) statbuf)[i]);
	}
}


/**
 * 获取文件状态
 * 根据给定的文件名获取相关文件状态信息。
 * @param[in]		filename	指定的文件名
 * @param[in/out]	statbuf		存放状态信息的缓冲区指针
 * @retval			成功返回0，出错返回出错码
 */
int sys_stat(char * filename, struct stat * statbuf)
{
	struct m_inode * inode;

	if (!(inode = namei(filename))) {
		return -ENOENT;
	}
	cp_stat(inode,statbuf);
	iput(inode);
	return 0;
}


/**
 * 获取文件状态
 * 根据给定的文件名获取相关文件状态信息。
 * @param[in]		fd			指定文件的句柄
 * @param[in/out]	statbuf		存放状态信息的缓冲区指针
 * @retval			成功返回0，出错返回出错码
 */
int sys_fstat(unsigned int fd, struct stat * statbuf)
{
	struct file * f;
	struct m_inode * inode;

	if (fd >= NR_OPEN || !(f = current->filp[fd]) || !(inode = f->f_inode)) {
		return -EBADF;
	}
	cp_stat(inode,statbuf);
	return 0;
}
